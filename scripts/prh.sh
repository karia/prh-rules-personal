#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF_USAGE'
Usage: prh.sh [textlint options...] <document_path>...

prh のルールで textlint する。
prh 単体と違い Markdown を解釈するため、コードブロック・インラインコード・
URL は指摘の対象外になる。

Examples:
  scripts/prh.sh /path/to/article.md
  scripts/prh.sh --fix /path/to/article.md
EOF_USAGE
}

if [[ $# -eq 0 || "$1" == "-h" || "$1" == "--help" ]]; then
  usage
  if [[ $# -eq 0 ]]; then
    exit 1
  fi
  exit 0
fi

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "${script_dir}/.." && pwd)"
config="${repo_root}/profiles/prh.textlintrc.json"

if [[ ! -f "$config" ]]; then
  echo "textlint の設定が見つかりません: ${config}" >&2
  exit 1
fi

rules_base_dir="$("${script_dir}/rules-base-dir.sh" npm:textlint-rule-prh)"

exec "${script_dir}/mise-exec.sh" textlint \
  --config "$config" \
  --rules-base-directory "$rules_base_dir" \
  "$@"

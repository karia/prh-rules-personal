#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF_USAGE'
Usage: textlint-rule.sh <mise_tool_name> <rule_name> [textlint options...] <document_path>...

単体の textlint ルールで textlint する。
スコープ付きパッケージはツール名とルール名が一致しないため、両方を受け取る。

Example:
  scripts/textlint-rule.sh npm:textlint-rule-ja-hiragana-fukushi ja-hiragana-fukushi /path/to/article.md
EOF_USAGE
}

if [[ $# -eq 0 || "$1" == "-h" || "$1" == "--help" ]]; then
  usage
  if [[ $# -eq 0 ]]; then
    exit 1
  fi
  exit 0
fi

if [[ $# -lt 3 ]]; then
  usage >&2
  exit 1
fi

tool="$1"
rule="$2"
shift 2

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
rules_base_dir="$("${script_dir}/rules-base-dir.sh" "$tool")"

exec "${script_dir}/mise-exec.sh" textlint \
  --no-textlintrc \
  --rule "$rule" \
  --rules-base-directory "$rules_base_dir" \
  "$@"

#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: textlint-preset.sh <preset_name> [textlint options...] <document_path>...

指定した textlint プリセットで textlint する。
npx は使わず、リポジトリの mise.toml で入れた textlint と
npm:textlint-rule-preset-<preset_name>（ルールと内蔵辞書）を使う。

Example:
  scripts/textlint-preset.sh jtf-style /path/to/article.md
EOF
}

if [[ $# -eq 0 || "$1" == "-h" || "$1" == "--help" ]]; then
  usage
  if [[ $# -eq 0 ]]; then
    exit 1
  fi
  exit 0
fi

preset="$1"
shift

if [[ $# -eq 0 ]]; then
  usage >&2
  exit 1
fi

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
rules_base_dir="$("${script_dir}/rules-base-dir.sh" "npm:textlint-rule-preset-${preset}")"

exec "${script_dir}/mise-exec.sh" textlint \
  --no-textlintrc \
  --preset "$preset" \
  --rules-base-directory "$rules_base_dir" \
  "$@"

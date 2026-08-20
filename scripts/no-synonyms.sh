#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF_USAGE'
Usage: no-synonyms.sh [textlint options...] <document_path>...

同義語の表記ゆれ（リポジトリとレポジトリの併用など）を textlint で確認する。

Example:
  scripts/no-synonyms.sh /path/to/article.md
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

exec "${script_dir}/textlint-rule.sh" \
  "npm:@textlint-ja/textlint-rule-no-synonyms" \
  "@textlint-ja/no-synonyms" \
  "$@"

#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF_USAGE'
Usage: ja-hiragana.sh [textlint options...] <document_path>...

ひらがなに開いたほうが読みやすい副詞・補助動詞・形式名詞を textlint で確認する。
ルールがパッケージごとに分かれているため、順に実行する。

Examples:
  scripts/ja-hiragana.sh /path/to/article.md
  scripts/ja-hiragana.sh --fix /path/to/article.md
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

failed=0
for rule in ja-hiragana-fukushi ja-hiragana-hojodoushi ja-hiragana-keishikimeishi; do
  if ! "${script_dir}/textlint-rule.sh" "npm:textlint-rule-${rule}" "$rule" "$@"; then
    failed=1
  fi
done

exit "$failed"

#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: ja-technical-writing.sh [textlint options...] <document_path>...

技術文書向けのルールプリセットで textlint する。

Examples:
  scripts/ja-technical-writing.sh /path/to/article.md
  scripts/ja-technical-writing.sh --fix /path/to/article.md
EOF
}

if [[ $# -eq 0 || "$1" == "-h" || "$1" == "--help" ]]; then
  usage
  if [[ $# -eq 0 ]]; then
    exit 1
  fi
  exit 0
fi

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec "${script_dir}/textlint-preset.sh" ja-technical-writing "$@"

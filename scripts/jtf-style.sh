#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: jtf-style.sh [textlint options...] <document_path>...

JTF日本語標準スタイルで textlint する。

Examples:
  scripts/jtf-style.sh /path/to/article.md
  scripts/jtf-style.sh --fix /path/to/article.md
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
exec "${script_dir}/textlint-preset.sh" jtf-style "$@"

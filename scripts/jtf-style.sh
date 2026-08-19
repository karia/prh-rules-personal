#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: jtf-style.sh [textlint options...] <document_path>...

JTF日本語標準スタイルで textlint する。
npx は使わず、リポジトリの mise.toml で入れた textlint と
textlint-rule-preset-jtf-style（ルールと内蔵辞書）を使う。

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

if ! command -v mise >/dev/null 2>&1; then
  echo "mise が PATH にありません。" >&2
  exit 1
fi

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if ! preset_root="$(mise -C "$repo_root" where npm:textlint-rule-preset-jtf-style 2>/dev/null)"; then
  echo "npm:textlint-rule-preset-jtf-style が入っていません。リポジトリで mise install を実行してください。" >&2
  exit 1
fi

preset_modules="${preset_root}/node_modules"
if [[ ! -d "$preset_modules" ]]; then
  echo "preset の node_modules が見つかりません: ${preset_modules}" >&2
  exit 1
fi

exec mise -C "$repo_root" exec -- textlint \
  --no-textlintrc \
  --preset jtf-style \
  --rules-base-directory "$preset_modules" \
  "$@"

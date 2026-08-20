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

if ! command -v mise >/dev/null 2>&1; then
  echo "mise が PATH にありません。" >&2
  exit 1
fi

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
tool="npm:textlint-rule-preset-${preset}"

if ! preset_root="$(mise -C "$repo_root" where "$tool" 2>/dev/null)"; then
  echo "${tool} が入っていません。リポジトリで mise install を実行してください。" >&2
  exit 1
fi

preset_modules="${preset_root}/node_modules"
if [[ ! -d "$preset_modules" ]]; then
  echo "preset の node_modules が見つかりません: ${preset_modules}" >&2
  exit 1
fi

exec mise -C "$repo_root" exec -- textlint \
  --no-textlintrc \
  --preset "$preset" \
  --rules-base-directory "$preset_modules" \
  "$@"

#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF_USAGE'
Usage: rules-base-dir.sh <mise_tool_name>

textlint の --rules-base-directory に渡すパスを出力する。
mise の npm ツールはツールごとに node_modules が分かれるため、
ルールを読む起点をツール単位で求める必要がある。

Example:
  scripts/rules-base-dir.sh npm:textlint-rule-prh
EOF_USAGE
}

if [[ $# -ne 1 || "$1" == "-h" || "$1" == "--help" ]]; then
  usage
  if [[ $# -ne 1 ]]; then
    exit 1
  fi
  exit 0
fi

if ! command -v mise >/dev/null 2>&1; then
  echo "mise が PATH にありません。" >&2
  exit 1
fi

tool="$1"
repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if ! tool_root="$(mise -C "$repo_root" where "$tool" 2>/dev/null)"; then
  echo "${tool} が入っていません。リポジトリで mise install を実行してください。" >&2
  exit 1
fi

modules="${tool_root}/node_modules"
if [[ ! -d "$modules" ]]; then
  echo "node_modules が見つかりません: ${modules}" >&2
  exit 1
fi

printf '%s\n' "$modules"

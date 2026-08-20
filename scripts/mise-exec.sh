#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage: mise-exec.sh <command> [args...]

リポジトリの mise.toml で入れたツールを、呼び出し元の CWD のまま実行する。

Example:
  scripts/mise-exec.sh textlint --version
USAGE
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

# mise exec は実行するコマンドの CWD をリポジトリルートに移してしまい、
# 引数に渡された相対パスが解決できなくなる。env で PATH だけ受け取り、CWD は変えない。
mise_env="$(mise -C "$repo_root" env -s bash)"
eval "$mise_env"

# mise exec と違い mise env は未インストールのツールを入れないため、
# PATH 上の別のツールに落ちる前に弾く。
if ! command -v "$1" >/dev/null 2>&1; then
  echo "${1} が入っていません。リポジトリで mise install を実行してください。" >&2
  exit 1
fi

exec "$@"

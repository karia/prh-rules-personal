#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: check.sh <document_path>...

prh・JTF-style・技術文書向けルール（textlint）をまとめて実行する。自動修正はしない。
指摘が無いチェックは「指摘事項なし」と表示する。

Example:
  scripts/check.sh /path/to/article.md
EOF
}

print_result() {
  local title="$1"
  local output="$2"

  printf '%s\n' "==> ${title}"
  if [[ -z "${output//[$' \t\n\r']/}" ]]; then
    printf '%s\n' "指摘事項なし"
  else
    printf '%s\n' "$output"
  fi
}

if [[ $# -eq 0 || "$1" == "-h" || "$1" == "--help" ]]; then
  usage
  if [[ $# -eq 0 ]]; then
    exit 1
  fi
  exit 0
fi

missing=0
for path in "$@"; do
  if [[ ! -e "$path" ]]; then
    printf '%s\n' "ファイルが存在しません: ${path}" >&2
    missing=1
  elif [[ ! -f "$path" ]]; then
    printf '%s\n' "通常ファイルではありません: ${path}" >&2
    missing=1
  fi
done
if [[ "$missing" -ne 0 ]]; then
  exit 1
fi

if ! command -v mise >/dev/null 2>&1; then
  echo "mise が PATH にありません。" >&2
  exit 1
fi

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
rules_yml="${repo_root}/profiles/default.yml"
mise_exec="${repo_root}/scripts/mise-exec.sh"

if [[ ! -f "$rules_yml" ]]; then
  echo "prh ルールが見つかりません: ${rules_yml}" >&2
  exit 1
fi

if [[ ! -x "$mise_exec" ]]; then
  echo "スクリプトが見つかりません: ${mise_exec}" >&2
  exit 1
fi

set +e
prh_output="$("$mise_exec" prh --rules "$rules_yml" "$@" 2>&1)"
prh_status=$?
set -e

failed=0
print_result "prh" "$prh_output"
if [[ "$prh_status" -ne 0 || -n "${prh_output//[$' \t\n\r']/}" ]]; then
  failed=1
fi

for preset in jtf-style ja-technical-writing; do
  script="${repo_root}/scripts/${preset}.sh"
  if [[ ! -x "$script" ]]; then
    echo "スクリプトが見つかりません: ${script}" >&2
    exit 1
  fi

  set +e
  output="$("$script" "$@" 2>&1)"
  status=$?
  set -e

  printf '\n'
  print_result "$preset" "$output"

  if [[ "$status" -ne 0 || -n "${output//[$' \t\n\r']/}" ]]; then
    failed=1
  fi
done

if [[ "$failed" -ne 0 ]]; then
  exit 1
fi

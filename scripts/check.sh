#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: check.sh <document_path>...

prh と JTF-style（textlint）をまとめて実行する。自動修正はしない。
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
jtf_script="${repo_root}/scripts/jtf-style.sh"

if [[ ! -f "$rules_yml" ]]; then
  echo "prh ルールが見つかりません: ${rules_yml}" >&2
  exit 1
fi

if [[ ! -x "$jtf_script" ]]; then
  echo "JTF-style スクリプトが見つかりません: ${jtf_script}" >&2
  exit 1
fi

prh_output=""
jtf_output=""
prh_status=0
jtf_status=0

set +e
prh_output="$(mise -C "$repo_root" exec -- prh --rules "$rules_yml" "$@" 2>&1)"
prh_status=$?
jtf_output="$("$jtf_script" "$@" 2>&1)"
jtf_status=$?
set -e

print_result "prh" "$prh_output"
printf '\n'
print_result "jtf-style" "$jtf_output"

prh_has_findings=0
jtf_has_findings=0
if [[ -n "${prh_output//[$' \t\n\r']/}" ]]; then
  prh_has_findings=1
fi
if [[ -n "${jtf_output//[$' \t\n\r']/}" ]]; then
  jtf_has_findings=1
fi

if [[ "$prh_status" -ne 0 || "$jtf_status" -ne 0 || "$prh_has_findings" -ne 0 || "$jtf_has_findings" -ne 0 ]]; then
  exit 1
fi

#!/usr/bin/env bash
# Check: the merged configuration has strict true and the source has no escape from the checker.
set -uo pipefail
cd /opt/portal || { echo "FAIL: /opt/portal is missing"; exit 1; }
command -v tsc >/dev/null || { echo "FAIL: tsc is not installed"; exit 1; }
strict="$(tsc -p tsconfig.json --showConfig 2>/dev/null | node -e "let s='';process.stdin.on('data',d=>s+=d).on('end',()=>{try{console.log(JSON.parse(s).compilerOptions.strict)}catch(e){console.log('error')}})")"
fail=0
if [ "$strict" != "true" ]; then
  echo "FAIL: merged strict is '$strict', expected true"
  fail=1
fi
if grep -REq '@ts-ignore|@ts-nocheck|@ts-expect-error|: any\b|\bas any\b' packages/*/src plugins/*/src --include=*.ts; then
  echo "FAIL: a source file uses an escape from the checker"
  fail=1
fi
[ "$fail" -eq 0 ] && echo "PASS: strict is in effect and the source has no escape"
exit "$fail"

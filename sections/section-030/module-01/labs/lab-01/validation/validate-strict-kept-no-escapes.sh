#!/usr/bin/env bash
# Check: strict is on and the source does not hide the error with an escape.
set -uo pipefail
cd /opt/portal || { echo "FAIL: /opt/portal is missing"; exit 1; }
command -v tsc >/dev/null || { echo "FAIL: tsc is not installed"; exit 1; }
fail=0
strict="$(tsc -p tsconfig.json --showConfig 2>/dev/null | node -e "let s='';process.stdin.on('data',d=>s+=d).on('end',()=>{try{console.log(JSON.parse(s).compilerOptions.strict)}catch(e){console.log('error')}})")"
if [ "$strict" != "true" ]; then
  echo "FAIL: compilerOptions.strict is '$strict', expected true"
  fail=1
fi
file=plugins/deploy-backend/src/index.ts
if grep -Eq '@ts-ignore|@ts-nocheck|@ts-expect-error' "$file"; then
  echo "FAIL: $file uses a ts comment directive"
  fail=1
fi
if grep -Eq '\bas (string|any|unknown)\b' "$file"; then
  echo "FAIL: $file uses a type assertion"
  fail=1
fi
if grep -Eq '[A-Za-z_)\]]!\.' "$file"; then
  echo "FAIL: $file uses the non-null operator"
  fail=1
fi
if ! grep -q 'owner' "$file"; then
  echo "FAIL: $file no longer reads the owner"
  fail=1
fi
if [ "$fail" -eq 0 ]; then
  echo "PASS: strict is on and the plugin has no escape from the checker"
fi
exit "$fail"

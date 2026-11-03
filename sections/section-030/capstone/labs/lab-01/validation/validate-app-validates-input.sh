#!/usr/bin/env bash
# Check: the app validates JSON through parseDeployment and does not escape the checker.
set -uo pipefail
cd /opt/portal || { echo "FAIL: /opt/portal is missing"; exit 1; }
command -v tsc >/dev/null || { echo "FAIL: tsc is not installed"; exit 1; }
fail=0
app=packages/app/src/index.ts
if ! grep -q 'parseDeployment' "$app"; then
  echo "FAIL: $app does not call parseDeployment"
  fail=1
fi
if grep -Eq 'as DeploymentRecord|\bas any\b|: any\b|@ts-ignore|@ts-nocheck|@ts-expect-error' "$app" plugins/deploy-backend/src/index.ts; then
  echo "FAIL: the app or backend source uses an assertion, any or a ts directive"
  fail=1
fi
strict="$(tsc -p tsconfig.base.json --showConfig 2>/dev/null | node -e "let s='';process.stdin.on('data',d=>s+=d).on('end',()=>{try{console.log(JSON.parse(s).compilerOptions.strict)}catch(e){console.log('error')}})")"
if [ "$strict" != "true" ]; then
  echo "FAIL: compilerOptions.strict is '$strict', expected true"
  fail=1
fi
if grep -q "status: 'done'" "$app"; then
  echo "FAIL: sample still has the invalid status done"
  fail=1
fi
if [ "$fail" -eq 0 ]; then
  echo "PASS: the app validates input with parseDeployment and strict is on"
fi
exit "$fail"

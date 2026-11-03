#!/usr/bin/env bash
# Check: the project is configured with noEmit and no .js file sits next to a source file.
set -uo pipefail
cd /opt/portal || { echo "FAIL: /opt/portal is missing"; exit 1; }
command -v tsc >/dev/null || { echo "FAIL: tsc is not installed"; exit 1; }
fail=0
noemit="$(tsc -p tsconfig.json --showConfig 2>/dev/null | node -e "let s='';process.stdin.on('data',d=>s+=d).on('end',()=>{try{console.log(JSON.parse(s).compilerOptions.noEmit)}catch(e){console.log('error')}})")"
if [ "$noemit" != "true" ]; then
  echo "FAIL: compilerOptions.noEmit is '$noemit', expected true"
  fail=1
fi
stray="$(find packages plugins -path '*/src/*.js' 2>/dev/null)"
if [ -n "$stray" ]; then
  echo "FAIL: generated .js files sit next to sources:"
  echo "$stray"
  fail=1
fi
if [ "$fail" -eq 0 ]; then
  echo "PASS: the check writes no files and no .js file is left in a src folder"
fi
exit "$fail"

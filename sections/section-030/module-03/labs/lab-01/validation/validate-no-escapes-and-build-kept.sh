#!/usr/bin/env bash
# Check: the type error was fixed in the code and the transpile-only build was not replaced.
set -uo pipefail
cd /opt/portal || { echo "FAIL: /opt/portal is missing"; exit 1; }
command -v node >/dev/null || { echo "FAIL: node is not installed"; exit 1; }
fail=0
if grep -REq '@ts-ignore|@ts-nocheck|@ts-expect-error|: any\b|\bas (any|number|string)\b' packages/*/src plugins/*/src; then
  echo "FAIL: a source file uses an escape from the checker"
  fail=1
fi
if ! grep -q 'noCheck' plugins/deploy-backend/package.json; then
  echo "FAIL: the deploy-backend build script no longer transpiles with --noCheck"
  fail=1
fi
[ "$fail" -eq 0 ] && echo "PASS: no escape and the build script is unchanged"
exit "$fail"

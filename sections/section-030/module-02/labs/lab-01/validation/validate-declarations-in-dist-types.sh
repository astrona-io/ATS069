#!/usr/bin/env bash
# Check: the check writes declaration files into dist-types and nothing next to the sources.
set -uo pipefail
cd /opt/portal || { echo "FAIL: /opt/portal is missing"; exit 1; }
command -v tsc >/dev/null || { echo "FAIL: tsc is not installed"; exit 1; }
rm -rf dist-types
find packages plugins -path '*/src/*' \( -name '*.js' -o -name '*.tsbuildinfo' \) -delete 2>/dev/null
tsc -p tsconfig.json >/dev/null 2>&1
fail=0
if [ ! -f dist-types/plugins/deploy-backend/src/index.d.ts ]; then
  echo "FAIL: dist-types/plugins/deploy-backend/src/index.d.ts was not written"
  fail=1
fi
if [ -n "$(find packages plugins -path '*/src/*' \( -name '*.js' -o -name '*.d.ts' ! -name 'legacy.d.ts' \) 2>/dev/null)" ]; then
  echo "FAIL: output files sit next to the sources"
  fail=1
fi
[ "$fail" -eq 0 ] && echo "PASS: declarations are written to dist-types only"
exit "$fail"

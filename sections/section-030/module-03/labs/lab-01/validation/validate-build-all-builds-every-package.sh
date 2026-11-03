#!/usr/bin/env bash
# Check: npm run build:all writes dist/index.js in all four packages, starting from nothing.
set -uo pipefail
cd /opt/portal || { echo "FAIL: /opt/portal is missing"; exit 1; }
command -v node >/dev/null || { echo "FAIL: node is not installed"; exit 1; }
command -v tsc >/dev/null || { echo "FAIL: tsc is not installed"; exit 1; }
for dir in packages/app packages/backend plugins/deploy-common plugins/deploy-backend; do
  rm -rf "$dir/dist"
done
if ! output="$(npm run build:all 2>&1)"; then
  echo "FAIL: npm run build:all fails"
  echo "$output" | tail -n 10
  exit 1
fi
fail=0
for dir in packages/app packages/backend plugins/deploy-common plugins/deploy-backend; do
  if [ ! -f "$dir/dist/index.js" ]; then
    echo "FAIL: $dir/dist/index.js was not built by build:all"
    fail=1
  fi
done
[ "$fail" -eq 0 ] && echo "PASS: build:all builds every package"
exit "$fail"

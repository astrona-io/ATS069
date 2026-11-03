#!/usr/bin/env bash
# Check: one tsc run over /opt/portal includes the app package and both plugins.
set -uo pipefail
cd /opt/portal || { echo "FAIL: /opt/portal is missing"; exit 1; }
command -v tsc >/dev/null || { echo "FAIL: tsc is not installed"; exit 1; }
files="$(tsc -p tsconfig.json --listFilesOnly 2>/dev/null)"
fail=0
for path in packages/app/src/index.ts plugins/deploy-backend/src/index.ts plugins/deploy-common/src/index.ts; do
  if ! echo "$files" | grep -q "/opt/portal/$path"; then
    echo "FAIL: $path is not part of the type check"
    fail=1
  fi
done
if [ "$fail" -eq 0 ]; then
  echo "PASS: the type check covers the app package and both plugins"
fi
exit "$fail"

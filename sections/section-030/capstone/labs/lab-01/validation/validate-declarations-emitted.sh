#!/usr/bin/env bash
# Check: each project has JavaScript and declaration output. Builds first so a stale state does not matter.
set -uo pipefail
cd /opt/portal || { echo "FAIL: /opt/portal is missing"; exit 1; }
command -v tsc >/dev/null || { echo "FAIL: tsc is not installed"; exit 1; }
tsc --build >/dev/null 2>&1
fail=0
for project in plugins/deploy-common plugins/deploy-backend packages/app; do
  for file in index.js index.d.ts; do
    if [ ! -f "$project/dist/$file" ]; then
      echo "FAIL: $project/dist/$file does not exist"
      fail=1
    fi
  done
done
if [ "$fail" -eq 0 ]; then
  echo "PASS: all three projects emitted JavaScript and declaration files"
fi
exit "$fail"

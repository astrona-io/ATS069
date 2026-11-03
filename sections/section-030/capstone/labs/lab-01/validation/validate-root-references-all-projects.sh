#!/usr/bin/env bash
# Check: the merged root configuration references the three projects.
set -uo pipefail
cd /opt/portal || { echo "FAIL: /opt/portal is missing"; exit 1; }
command -v tsc >/dev/null || { echo "FAIL: tsc is not installed"; exit 1; }
config="$(tsc -p tsconfig.json --showConfig 2>&1)"
fail=0
for project in deploy-common deploy-backend app; do
  if ! echo "$config" | grep -q "\"path\": \".*$project\""; then
    echo "FAIL: the root tsconfig.json does not reference $project"
    fail=1
  fi
done
if [ "$fail" -eq 0 ]; then
  echo "PASS: the root solution file references all three projects"
fi
exit "$fail"

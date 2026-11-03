#!/usr/bin/env bash
# Check: tsc reports no type error. Runs with --noEmit so the check writes nothing.
set -uo pipefail
cd /opt/portal || { echo "FAIL: /opt/portal is missing"; exit 1; }
command -v tsc >/dev/null || { echo "FAIL: tsc is not installed"; exit 1; }
if output="$(tsc -p tsconfig.json --noEmit 2>&1)"; then
  echo "PASS: tsc reports no error"
  exit 0
fi
echo "FAIL: tsc reports errors"
echo "$output" | head -n 10
exit 1

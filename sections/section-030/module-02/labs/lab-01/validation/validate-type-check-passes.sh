#!/usr/bin/env bash
# Check: the root check reports no error.
set -uo pipefail
cd /opt/portal || { echo "FAIL: /opt/portal is missing"; exit 1; }
command -v tsc >/dev/null || { echo "FAIL: tsc is not installed"; exit 1; }
if output="$(tsc -p tsconfig.json 2>&1)"; then
  echo "PASS: tsc reports no error"
  exit 0
fi
echo "FAIL: tsc reports errors"
echo "$output" | head -n 10
exit 1

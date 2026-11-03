#!/usr/bin/env bash
# Check: a forced build of the whole workspace ends without error. --force ignores old output.
set -uo pipefail
cd /opt/portal || { echo "FAIL: /opt/portal is missing"; exit 1; }
command -v tsc >/dev/null || { echo "FAIL: tsc is not installed"; exit 1; }
if output="$(tsc --build --force 2>&1)"; then
  echo "PASS: tsc --build --force ends without error"
  exit 0
fi
echo "FAIL: the forced build reports errors"
echo "$output" | head -n 10
exit 1

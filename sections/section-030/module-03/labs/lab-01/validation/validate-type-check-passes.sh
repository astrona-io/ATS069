#!/usr/bin/env bash
# Check: the root type check reports no error.
set -uo pipefail
cd /opt/portal || { echo "FAIL: /opt/portal is missing"; exit 1; }
command -v node >/dev/null || { echo "FAIL: node is not installed"; exit 1; }
command -v tsc >/dev/null || { echo "FAIL: tsc is not installed"; exit 1; }
if output="$(npm run tsc 2>&1)"; then
  echo "PASS: the type check reports no error"
  exit 0
fi
echo "FAIL: the type check reports errors"
echo "$output" | tail -n 10
exit 1

#!/usr/bin/env bash
# Check: .gitignore lists dist-types.
set -uo pipefail
cd /opt/portal || { echo "FAIL: /opt/portal is missing"; exit 1; }
command -v tsc >/dev/null || { echo "FAIL: tsc is not installed"; exit 1; }
if grep -qx 'dist-types/\?' .gitignore 2>/dev/null; then
  echo "PASS: dist-types is ignored"
  exit 0
fi
echo "FAIL: .gitignore does not list dist-types"
exit 1

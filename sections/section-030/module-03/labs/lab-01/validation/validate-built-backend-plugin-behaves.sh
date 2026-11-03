#!/usr/bin/env bash
# Check: the built deploy-backend plugin returns the name and its length.
set -uo pipefail
cd /opt/portal || { echo "FAIL: /opt/portal is missing"; exit 1; }
command -v node >/dev/null || { echo "FAIL: node is not installed"; exit 1; }
command -v tsc >/dev/null || { echo "FAIL: tsc is not installed"; exit 1; }
npm run build --workspace plugins/deploy-backend >/dev/null 2>&1
result="$(node -e "console.log(require('/opt/portal/plugins/deploy-backend').describeBackend('abc'))" 2>&1)"
if [ "$result" = "abc (3)" ]; then
  echo "PASS: describeBackend returns the name and its length"
  exit 0
fi
echo "FAIL: describeBackend('abc') returned: $result"
exit 1

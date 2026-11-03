#!/usr/bin/env bash
# Check: deploy-backend declares its dependency on deploy-common.
set -uo pipefail
cd /opt/portal || { echo "FAIL: /opt/portal is missing"; exit 1; }
command -v tsc >/dev/null || { echo "FAIL: tsc is not installed"; exit 1; }
if tsc -p plugins/deploy-backend --showConfig 2>&1 | grep -q '"path": ".*deploy-common"'; then
  echo "PASS: deploy-backend references deploy-common"
  exit 0
fi
echo "FAIL: plugins/deploy-backend/tsconfig.json has no reference to deploy-common"
exit 1

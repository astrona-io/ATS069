#!/usr/bin/env bash
set -u

cd /opt/scaffold 2>/dev/null || { echo "FAIL: /opt/scaffold does not exist"; exit 1; }

role=$(node -p "((require(\"./plugins/status-backend/package.json\").backstage)||{}).role" 2>/dev/null)
if [ "$role" != "backend-plugin" ]; then
  echo "FAIL: backstage.role of plugins/status-backend is \"$role\", expected backend-plugin"
  exit 1
fi
echo "PASS: plugins/status-backend has the role backend-plugin"
exit 0

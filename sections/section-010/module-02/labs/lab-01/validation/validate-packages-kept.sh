#!/usr/bin/env bash
set -u

cd /opt/scaffold 2>/dev/null || { echo "FAIL: /opt/scaffold does not exist"; exit 1; }

for f in backstage.json packages/app/package.json packages/backend/package.json plugins/status/package.json plugins/status-backend/package.json tools/check-env.js; do
  if [ ! -f "$f" ]; then
    echo "FAIL: $f is missing"
    exit 1
  fi
done
role=$(node -p "require(\"./plugins/status/package.json\").backstage.role")
if [ "$role" != "frontend-plugin" ]; then
  echo "FAIL: the role of plugins/status was changed"
  exit 1
fi
echo "PASS: all packages and backstage.json are still present"
exit 0

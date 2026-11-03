#!/usr/bin/env bash
set -u
cd /opt/portal || { echo "FAIL: /opt/portal is missing"; exit 1; }
if ! grep -Eq '^[[:space:]]*backend\.add\(helloBackendPlugin\);' packages/backend/src/index.ts; then
  echo "FAIL: packages/backend/src/index.ts does not call backend.add(helloBackendPlugin)"
  exit 1
fi
echo "PASS: the backend adds the plugin"

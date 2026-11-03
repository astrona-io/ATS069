#!/usr/bin/env bash
set -u
cd /opt/portal || { echo "FAIL: /opt/portal is missing"; exit 1; }
if ! yarn workspaces list 2>/dev/null | grep -q "plugins/hello-backend"; then
  echo "FAIL: yarn workspaces list does not show plugins/hello-backend"
  exit 1
fi
echo "PASS: the backend plugin is a workspace"

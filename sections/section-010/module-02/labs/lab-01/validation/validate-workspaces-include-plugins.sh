#!/usr/bin/env bash
set -u

cd /opt/scaffold 2>/dev/null || { echo "FAIL: /opt/scaffold does not exist"; exit 1; }

if ! node -e "
const p = require(\"./package.json\");
const w = Array.isArray(p.workspaces) ? p.workspaces : (p.workspaces && p.workspaces.packages) || [];
for (const g of [\"packages/*\", \"plugins/*\"]) { if (!w.includes(g)) { console.error(\"missing \" + g); process.exit(1); } }
" 2>/tmp/lab-ws.log; then
  echo "FAIL: workspaces field is missing an entry ($(cat /tmp/lab-ws.log))"
  exit 1
fi
if ! yarn workspaces list 2>/dev/null | grep -q "plugin-status-backend"; then
  echo "FAIL: yarn workspaces list does not show @internal/plugin-status-backend"
  exit 1
fi
echo "PASS: packages/* and plugins/* are workspaces"
exit 0

#!/usr/bin/env bash
set -u
cd /opt/portal || { echo "FAIL: /opt/portal is missing"; exit 1; }
peer=$(node -p "((require('./packages/plugin/package.json').peerDependencies)||{})['@internal/shared']||''" 2>/dev/null)
dev=$(node -p "((require('./packages/plugin/package.json').devDependencies)||{})['@internal/shared']||''" 2>/dev/null)
[ -n "$peer" ] || { echo "FAIL: the plugin does not declare @internal/shared in peerDependencies"; exit 1; }
case "$peer" in workspace:*) echo "FAIL: the peer range '$peer' uses the workspace: protocol; use a version range such as ^1.0.0"; exit 1 ;; esac
[ -n "$dev" ] || { echo "FAIL: the plugin does not declare @internal/shared in devDependencies"; exit 1; }
echo "PASS: the plugin declares @internal/shared as a peer '$peer' and as a development dependency '$dev'"

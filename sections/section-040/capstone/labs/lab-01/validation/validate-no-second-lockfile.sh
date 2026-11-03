#!/usr/bin/env bash
set -u
cd /opt/portal || { echo "FAIL: /opt/portal is missing"; exit 1; }
[ ! -e package-lock.json ] || { echo "FAIL: package-lock.json still exists next to yarn.lock"; exit 1; }
[ -f yarn.lock ] || { echo "FAIL: yarn.lock is missing"; exit 1; }
[ "$(node -p "require('./package.json').packageManager" 2>/dev/null)" = "yarn@4.4.1" ] || { echo "FAIL: packageManager is not yarn@4.4.1"; exit 1; }
echo "PASS: only yarn.lock remains and packageManager is yarn@4.4.1"

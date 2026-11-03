#!/usr/bin/env bash
set -u
cd /opt/portal || { echo "FAIL: /opt/portal is missing"; exit 1; }
[ "$(node -p "require('./package.json').packageManager" 2>/dev/null)" = "yarn@4.4.1" ] || { echo "FAIL: packageManager is not yarn@4.4.1"; exit 1; }
[ "$(node -p "require('./packages/shared/package.json').version" 2>/dev/null)" = "1.0.0" ] || { echo "FAIL: @internal/shared no longer has version 1.0.0"; exit 1; }
grep -q '^nodeLinker: node-modules' .yarnrc.yml || { echo "FAIL: .yarnrc.yml no longer sets nodeLinker: node-modules"; exit 1; }
[ ! -e package-lock.json ] || { echo "FAIL: package-lock.json exists in a Yarn project"; exit 1; }
echo "PASS: Yarn is still the package manager and the shared package keeps version 1.0.0"

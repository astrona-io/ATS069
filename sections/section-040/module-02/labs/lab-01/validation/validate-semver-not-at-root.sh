#!/usr/bin/env bash
set -u
cd /opt/portal || { echo "FAIL: /opt/portal is missing"; exit 1; }
value=$(node -p "((require('./package.json').dependencies)||{}).semver||''" 2>/dev/null)
dev=$(node -p "((require('./package.json').devDependencies)||{}).semver||''" 2>/dev/null)
if [ -z "$value" ] && [ -z "$dev" ]; then
  echo "PASS: the root manifest does not declare semver"; exit 0
fi
echo "FAIL: package.json at the root still declares semver"; exit 1

#!/usr/bin/env bash
set -u
cd /opt/portal || { echo "FAIL: /opt/portal is missing"; exit 1; }
value=$(node -p "((require('./packages/backend/package.json').dependencies)||{})['@internal/shared']||''" 2>/dev/null)
if [ -n "$value" ]; then
  echo "PASS: backend declares @internal/shared '$value' under dependencies"; exit 0
fi
echo "FAIL: packages/backend/package.json does not declare @internal/shared under dependencies"; exit 1

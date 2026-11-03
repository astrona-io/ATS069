#!/usr/bin/env bash
set -u
cd /opt/portal || { echo "FAIL: /opt/portal is missing"; exit 1; }
range=$(node -p "(require('./packages/app/package.json').dependencies||{})['@internal/shared']||''" 2>/dev/null)
if [ -z "$range" ]; then
  echo "FAIL: packages/app/package.json has no dependency on @internal/shared"; exit 1
fi
if echo "$range" | grep -Eq '^(workspace:.*|[\^~]?1(\.[0-9x]+){0,2})$'; then
  echo "PASS: app asks for @internal/shared '$range', which version 1.0.0 satisfies"; exit 0
fi
echo "FAIL: app asks for @internal/shared '$range', which the local version 1.0.0 does not satisfy"; exit 1

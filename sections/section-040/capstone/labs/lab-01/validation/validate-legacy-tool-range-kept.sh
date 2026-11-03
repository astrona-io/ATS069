#!/usr/bin/env bash
set -u
cd /opt/portal || { echo "FAIL: /opt/portal is missing"; exit 1; }
range=$(node -p "((require('./packages/legacy-tool/package.json').dependencies)||{})['semver']||''" 2>/dev/null)
[ "$range" = "^5.7.2" ] || { echo "FAIL: legacy-tool no longer declares semver ^5.7.2 (found '$range')"; exit 1; }
res=$(node -p "Object.keys(require('./package.json').resolutions||{}).filter(k=>k.startsWith('semver')).length" 2>/dev/null)
[ "${res:-0}" -ge 1 ] || { echo "FAIL: the root package.json has no resolutions entry for semver"; exit 1; }
echo "PASS: legacy-tool keeps its range and the root manifest overrides semver with resolutions"

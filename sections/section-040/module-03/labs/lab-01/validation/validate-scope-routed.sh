#!/usr/bin/env bash
set -u
cd /opt/portal || { echo "FAIL: /opt/portal is missing"; exit 1; }
grep -q '^npmScopes:' .yarnrc.yml || { echo "FAIL: .yarnrc.yml has no npmScopes entry"; exit 1; }
block=$(awk '/^npmScopes:/{f=1;next} f&&/^[^ ]/{f=0} f{print}' .yarnrc.yml)
echo "$block" | grep -Eq '^  internal:' || { echo "FAIL: npmScopes has no entry named internal (no at sign)"; exit 1; }
echo "$block" | grep -Eq 'npmRegistryServer: *"?https://npm.internal.example.com"?' || { echo "FAIL: the internal scope does not use https://npm.internal.example.com"; exit 1; }
echo "$block" | grep -q 'NPM_TOKEN' || { echo "FAIL: the internal scope does not read its token from NPM_TOKEN"; exit 1; }
echo "PASS: the internal scope is routed to the private registry with a token from NPM_TOKEN"

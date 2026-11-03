#!/usr/bin/env bash
set -u
cd /opt/portal || { echo "FAIL: /opt/portal is missing"; exit 1; }
[ -f yarn.lock ] || { echo "FAIL: yarn.lock is missing"; exit 1; }
block=$(awk '/^"backend@workspace:/{f=1;print;next} f&&/^"/{f=0} f{print}' yarn.lock)
if [ -z "$block" ]; then
  echo "FAIL: yarn.lock has no entry for the backend workspace"; exit 1
fi
if echo "$block" | grep -q '@internal/shared'; then
  echo "PASS: yarn.lock lists @internal/shared as a dependency of backend"; exit 0
fi
echo "FAIL: the backend entry in yarn.lock does not list @internal/shared; run yarn install"; exit 1

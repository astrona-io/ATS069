#!/usr/bin/env bash
set -u
cd /opt/portal || { echo "FAIL: /opt/portal is missing"; exit 1; }
if yarn install --immutable >/tmp/immutable-install.log 2>&1; then
  echo "PASS: yarn install --immutable exits with code 0"; exit 0
fi
echo "FAIL: yarn install --immutable fails. Last lines:"
tail -n 5 /tmp/immutable-install.log
exit 1

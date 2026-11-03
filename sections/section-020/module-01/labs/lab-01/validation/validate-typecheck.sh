#!/usr/bin/env bash
set -u
cd /opt/portal || { echo "FAIL: /opt/portal is missing"; exit 1; }
if ! node_modules/.bin/tsc --noEmit; then
  echo "FAIL: tsc reports errors"
  exit 1
fi
echo "PASS: tsc finished without errors"

#!/usr/bin/env bash
set -u
cd /opt/portal || { echo "FAIL: /opt/portal is missing"; exit 1; }
if ! sha256sum --check --quiet /var/lib/portal-lab/tests.sha256; then
  echo "FAIL: a test file was changed"
  exit 1
fi
if ! node --experimental-strip-types --test "packages/**/*.test.ts" >/dev/null 2>&1; then
  echo "FAIL: yarn test does not pass"
  exit 1
fi
echo "PASS: the tests pass and are unchanged"

#!/usr/bin/env bash
set -u
cd /opt/portal || { echo "FAIL: /opt/portal is missing"; exit 1; }
if ! node scripts/lint.mjs >/dev/null 2>&1; then
  echo "FAIL: the lint script reports problems"
  exit 1
fi
echo "PASS: lint reports no problems"

#!/usr/bin/env bash
set -u
cd /opt/portal || { echo "FAIL: /opt/portal is missing"; exit 1; }
if ! git diff --quiet HEAD -- scripts/lint.mjs; then
  echo "FAIL: scripts/lint.mjs was changed"
  exit 1
fi
if ! node scripts/lint.mjs >/dev/null 2>&1; then
  echo "FAIL: lint reports problems"
  exit 1
fi
echo "PASS: lint reports no problems"

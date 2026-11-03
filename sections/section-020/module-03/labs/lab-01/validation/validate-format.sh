#!/usr/bin/env bash
set -u
cd /opt/portal || { echo "FAIL: /opt/portal is missing"; exit 1; }
if ! node scripts/format.mjs --check >/dev/null 2>&1; then
  echo "FAIL: some files are not formatted"
  exit 1
fi
echo "PASS: all files are formatted"

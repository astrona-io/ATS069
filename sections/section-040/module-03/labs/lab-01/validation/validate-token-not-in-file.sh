#!/usr/bin/env bash
set -u
cd /opt/portal || { echo "FAIL: /opt/portal is missing"; exit 1; }
if grep -q 'npm_FAKE' .yarnrc.yml; then
  echo "FAIL: .yarnrc.yml still contains the literal token"; exit 1
fi
echo "PASS: no literal token in .yarnrc.yml"

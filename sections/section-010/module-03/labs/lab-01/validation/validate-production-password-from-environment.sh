#!/usr/bin/env bash
set -u

cd /opt/envcfg 2>/dev/null || { echo "FAIL: /opt/envcfg does not exist"; exit 1; }

if out=$(python3 tools/check-config.py password 2>&1); then
  echo "PASS: the production password comes from POSTGRES_PASSWORD"
  exit 0
fi
echo "FAIL: $out"
exit 1

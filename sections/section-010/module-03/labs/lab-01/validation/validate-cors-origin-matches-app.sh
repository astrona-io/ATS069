#!/usr/bin/env bash
set -u

cd /opt/envcfg 2>/dev/null || { echo "FAIL: /opt/envcfg does not exist"; exit 1; }

if out=$(python3 tools/check-config.py cors 2>&1); then
  echo "PASS: backend.cors.origin matches app.baseUrl"
  exit 0
fi
echo "FAIL: $out"
exit 1

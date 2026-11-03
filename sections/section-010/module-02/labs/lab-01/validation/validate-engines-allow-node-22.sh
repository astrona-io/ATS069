#!/usr/bin/env bash
set -u

cd /opt/scaffold 2>/dev/null || { echo "FAIL: /opt/scaffold does not exist"; exit 1; }

if ! node tools/check-env.js >/tmp/lab-env.log 2>&1; then
  echo "FAIL: $(tail -n 1 /tmp/lab-env.log)"
  exit 1
fi
echo "PASS: engines.node allows the installed Node.js version"
exit 0

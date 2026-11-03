#!/usr/bin/env bash
# Check: tsc:full runs the check with skipLibCheck off and incremental off, and passes.
set -uo pipefail
cd /opt/portal || { echo "FAIL: /opt/portal is missing"; exit 1; }
command -v tsc >/dev/null || { echo "FAIL: tsc is not installed"; exit 1; }
script="$(node -p "(require('./package.json').scripts||{})['tsc:full']||''")"
fail=0
case "$script" in *"--skipLibCheck false"*) ;; *) echo "FAIL: tsc:full does not pass --skipLibCheck false"; fail=1;; esac
case "$script" in *"--incremental false"*) ;; *) echo "FAIL: tsc:full does not pass --incremental false"; fail=1;; esac
if [ "$fail" -eq 0 ]; then
  if npm run tsc:full >/dev/null 2>&1; then
    echo "PASS: tsc:full is defined and passes"
  else
    echo "FAIL: npm run tsc:full fails"
    fail=1
  fi
fi
exit "$fail"

#!/usr/bin/env bash
# Check: the build:all script in the root package.json runs tsc in build mode.
set -uo pipefail
cd /opt/portal || { echo "FAIL: /opt/portal is missing"; exit 1; }
script="$(node -e "try{console.log(require('/opt/portal/package.json').scripts['build:all']||'')}catch(e){console.log('')}")"
case "$script" in
  *"tsc --build"*|*"tsc -b"*)
    echo "PASS: build:all runs '$script'"
    exit 0 ;;
esac
echo "FAIL: build:all is '$script', expected a tsc --build command"
exit 1

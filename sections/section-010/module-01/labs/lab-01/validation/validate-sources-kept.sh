#!/usr/bin/env bash
set -u

for file in packages/backend/src/index.js packages/backend/src/config.js scripts/build.js; do
  if [ ! -f "/opt/portal/$file" ]; then
    echo "FAIL: /opt/portal/$file was removed"
    exit 1
  fi
done

echo "PASS: the source files and the build script still exist"
exit 0

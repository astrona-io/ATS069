#!/usr/bin/env bash
set -u

dist=/opt/portal/packages/backend/dist

for file in index.js config.js; do
  if [ ! -f "$dist/$file" ]; then
    echo "FAIL: $dist/$file is missing. Run yarn build:backend after fixing the build script."
    exit 1
  fi
done

echo "PASS: packages/backend/dist contains index.js and config.js"
exit 0

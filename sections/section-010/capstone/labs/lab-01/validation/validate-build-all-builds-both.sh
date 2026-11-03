#!/usr/bin/env bash
set -u

cd /opt/portal || exit 1
rm -rf packages/app/dist packages/backend/dist

if ! yarn build:all >/tmp/lab-build.log 2>&1; then
  echo "FAIL: yarn build:all failed: $(tail -c 300 /tmp/lab-build.log)"
  exit 1
fi

for file in packages/app/dist/server.js packages/app/dist/index.html packages/app/dist/config.json packages/backend/dist/index.js packages/backend/dist/config.js; do
  if [ ! -f "$file" ]; then
    echo "FAIL: $file is missing after yarn build:all"
    exit 1
  fi
done

echo "PASS: yarn build:all built both workspaces"
exit 0

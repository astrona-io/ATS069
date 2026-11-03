#!/usr/bin/env bash
# Reference solution for the lab: used only by astrona test.
set -eu
cd /opt/portal

# 1. Add the missing listen block under backend.
sed -i 's|^  baseUrl: http://localhost:7007$|  baseUrl: http://localhost:7007\n  listen:\n    port: 7007|' app-config.yaml

# 2. Point the start script at the configuration file two directories up.
sed -i 's|--config app-config.yaml|--config ../../app-config.yaml|' packages/backend/package.json

# 3. Copy the whole src directory in the build script, then build.
sed -i "/^for (const file of \['index.js'\]) {/,/^}/c\\fs.cpSync(src, dist, { recursive: true });" scripts/build.js
yarn build:backend

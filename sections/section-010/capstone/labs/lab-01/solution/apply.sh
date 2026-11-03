#!/usr/bin/env bash
# Reference solution for the capstone: used only by astrona test.
set -eu
cd /opt/portal

sed -i 's|--config app-config.yaml|--config ../../app-config.yaml|' packages/backend/package.json
sed -i 's|http://localhost:3001|http://localhost:3000|' app-config.yaml
sed -i '/^  githubToken: ghp_example_token$/d' app-config.yaml
sed -i 's|^  baseUrl: http://localhost:7007$|  baseUrl: http://localhost:7007\n  githubToken: ghp_example_token|' app-config.yaml
sed -i 's|"build:all": "yarn workspace backend build"|"build:all": "yarn workspaces foreach --all run build"|' package.json
yarn build:all

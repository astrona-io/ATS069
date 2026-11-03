#!/usr/bin/env bash
# Reference solution, applied only by astrona test.
set -euo pipefail
cd /opt/portal
sed -i 's#"workspaces": \["packages/\*"\]#"workspaces": ["packages/*", "plugins/*"]#' package.json
sed -i "s/id: 'hello-backend'/id: 'hello'/" plugins/hello-backend/src/plugin.ts
sed -i "s#^backend.start#backend.add(helloBackendPlugin);\nbackend.start#" packages/backend/src/index.ts
cat > packages/backend/package.json <<'JSON'
{
  "name": "@portal/backend",
  "version": "1.0.0",
  "private": true,
  "dependencies": {
    "@internal/plugin-hello-backend": "workspace:^"
  }
}
JSON
yarn install

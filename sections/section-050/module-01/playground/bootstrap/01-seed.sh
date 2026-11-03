#!/usr/bin/env bash
set -eu
# Playground: a working portal workspace, a host-build Dockerfile and a multi-stage Dockerfile.

# Writes the simplified portal workspace into /opt/portal. It has the same shape as a
# Backstage project (workspaces, app-config files, a backend bundle) but no registry
# dependencies. The backend is a tiny Node.js server that reads --config files.
write_fixture() {
  local root=/opt/portal
  sudo mkdir -p "$root"
  sudo chmod 777 "$root"
  find "$root" -mindepth 1 -delete
  mkdir -p "$root/scripts" "$root/packages/app/src" "$root/packages/backend/src"

  cat > "$root/package.json" <<'EOF'
{
  "name": "portal",
  "private": true,
  "version": "1.0.0",
  "workspaces": ["packages/*"],
  "scripts": {
    "build:backend": "sh scripts/build-backend.sh"
  }
}
EOF

  cat > "$root/app-config.yaml" <<'EOF'
app:
  title: Starfleet Portal
  baseUrl: http://localhost:3000
backend:
  baseUrl: http://localhost:7007
  listen:
    port: 7007
    host: 127.0.0.1
EOF

  cat > "$root/app-config.production.yaml" <<'EOF'
app:
  baseUrl: http://localhost:7007
backend:
  baseUrl: http://localhost:7007
  listen:
    host: 0.0.0.0
EOF

  cat > "$root/app-config.local.yaml" <<'EOF'
# Developer-only overrides. Never part of an image.
backend:
  auth:
    keys:
      - secret: lab-secret-token-4471
EOF

  cat > "$root/packages/app/package.json" <<'EOF'
{
  "name": "app",
  "version": "1.0.0",
  "private": true,
  "main": "src/index.js"
}
EOF
  echo "// Placeholder for the frontend package." > "$root/packages/app/src/index.js"

  cat > "$root/packages/backend/package.json" <<'EOF'
{
  "name": "backend",
  "version": "1.0.0",
  "private": true,
  "main": "dist/index.cjs.js"
}
EOF

  cat > "$root/packages/backend/src/index.cjs.js" <<'EOF'
'use strict';
const http = require('http');
const fs = require('fs');
const path = require('path');

const configFiles = [];
const args = process.argv.slice(2);
for (let i = 0; i < args.length; i++) {
  if (args[i] === '--config') configFiles.push(args[++i]);
}

// Minimal reader: the last config file that sets "key: value" wins.
function readValue(key, fallback) {
  let value = fallback;
  for (const file of configFiles) {
    let text;
    try {
      text = fs.readFileSync(file, 'utf8');
    } catch (error) {
      console.error('Cannot read config file ' + file);
      process.exit(1);
    }
    const match = text.match(new RegExp('^\\s*' + key + ':\\s*(\\S+)\\s*$', 'm'));
    if (match) value = match[1];
  }
  return value;
}

const port = Number(readValue('port', '7007'));
const host = readValue('host', '127.0.0.1');
const build = fs.readFileSync(path.join(__dirname, 'build-id'), 'utf8').trim();

const server = http.createServer((request, response) => {
  response.setHeader('Content-Type', 'application/json');
  if (request.url === '/healthcheck') {
    response.end(JSON.stringify({ status: 'ok' }));
  } else if (request.url === '/build') {
    response.end(JSON.stringify({ build }));
  } else if (request.url === '/status') {
    response.end(JSON.stringify({ tokenConfigured: Boolean(process.env.PORTAL_TOKEN) }));
  } else {
    response.statusCode = 404;
    response.end(JSON.stringify({ error: 'not found' }));
  }
});
server.listen(port, host, () => console.log('portal backend listening on ' + host + ':' + port));
EOF
  echo "r1" > "$root/packages/backend/src/build-id"

  cat > "$root/scripts/build-backend.sh" <<'EOF'
#!/bin/sh
# Simplified stand-in for `yarn build:backend`: packs the backend into
# packages/backend/dist/bundle.tar.gz. The real command also writes skeleton.tar.gz.
set -eu
cd "$(dirname "$0")/.."
rm -rf packages/backend/dist
mkdir -p packages/backend/dist
stage="$(mktemp -d)"
mkdir -p "$stage/packages/backend/dist"
cp packages/backend/package.json "$stage/packages/backend/package.json"
cp packages/backend/src/index.cjs.js "$stage/packages/backend/dist/index.cjs.js"
cp packages/backend/src/build-id "$stage/packages/backend/dist/build-id"
tar -czf packages/backend/dist/bundle.tar.gz -C "$stage" .
rm -rf "$stage"
echo "wrote packages/backend/dist/bundle.tar.gz"
EOF
  chmod +x "$root/scripts/build-backend.sh"
}

write_fixture
root=/opt/portal
echo "r2" > "$root/packages/backend/src/build-id"
cat > "$root/.dockerignore" <<'IGN'
.git
node_modules
*.local.yaml
IGN
cat > "$root/packages/backend/Dockerfile" <<'DF'
FROM node:22-bookworm-slim

WORKDIR /app
RUN chown node:node /app
USER node

ENV NODE_ENV=production

COPY --chown=node:node packages/backend/dist/bundle.tar.gz ./
RUN tar xzf bundle.tar.gz && rm bundle.tar.gz

COPY --chown=node:node app-config.yaml app-config.production.yaml ./

EXPOSE 7007
CMD ["node", "packages/backend", "--config", "app-config.yaml", "--config", "app-config.production.yaml"]
DF
cat > "$root/Dockerfile.multistage" <<'DF'
FROM node:22-bookworm-slim AS build
WORKDIR /app
COPY . .
RUN sh scripts/build-backend.sh

FROM node:22-bookworm-slim
WORKDIR /app
RUN chown node:node /app
USER node
ENV NODE_ENV=production
COPY --from=build --chown=node:node /app/packages/backend/dist/bundle.tar.gz ./
RUN tar xzf bundle.tar.gz && rm bundle.tar.gz
COPY --from=build --chown=node:node /app/app-config.yaml /app/app-config.production.yaml ./
EXPOSE 7007
CMD ["node", "packages/backend", "--config", "app-config.yaml", "--config", "app-config.production.yaml"]
DF
(cd "$root" && sh scripts/build-backend.sh)
docker pull node:22-bookworm-slim
echo "Playground ready: cd /opt/portal"

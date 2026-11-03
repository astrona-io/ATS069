#!/usr/bin/env bash
# Lab: the image portal:run is built; the task is to run it with runtime configuration.
set -eu
# Writes a simplified portal workspace into /opt/portal and builds the image portal:run from it.
# The backend is a tiny Node.js server that reads --config files. It is not a real Backstage backend.
root=/opt/portal
sudo mkdir -p "$root"
sudo chmod 777 "$root"
find "$root" -mindepth 1 -delete
mkdir -p "$root/packages/backend" "$root/runtime"

cat > "$root/app-config.yaml" <<'YML'
app:
  title: Starfleet Portal
backend:
  baseUrl: http://localhost:7007
  listen:
    port: 7007
    host: 127.0.0.1
YML
cat > "$root/app-config.production.yaml" <<'YML'
backend:
  listen:
    host: 0.0.0.0
YML
cat > "$root/runtime/app-config.runtime.yaml" <<'YML'
# Environment-specific values, mounted into the container at run time.
backend:
  listen:
    port: 7100
YML
echo "PORTAL_TOKEN=lab-run-token-5530" > "$root/runtime/portal.env"

cat > "$root/packages/backend/package.json" <<'JSON'
{
  "name": "backend",
  "version": "1.0.0",
  "private": true,
  "main": "index.cjs.js"
}
JSON
echo "r1" > "$root/packages/backend/build-id"
cat > "$root/packages/backend/index.cjs.js" <<'JS'
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
  } else if (request.url === '/config') {
    response.end(JSON.stringify({ files: configFiles, port, host }));
  } else if (request.url === '/status') {
    response.end(JSON.stringify({ tokenConfigured: Boolean(process.env.PORTAL_TOKEN) }));
  } else {
    response.statusCode = 404;
    response.end(JSON.stringify({ error: 'not found' }));
  }
});
server.listen(port, host, () => console.log('portal backend listening on ' + host + ':' + port));
JS

cat > "$root/Dockerfile" <<'DF'
FROM node:22-bookworm-slim
WORKDIR /app
RUN chown node:node /app
USER node
ENV NODE_ENV=production
COPY --chown=node:node packages/backend/package.json packages/backend/index.cjs.js packages/backend/build-id ./packages/backend/
COPY --chown=node:node app-config.yaml app-config.production.yaml ./
EXPOSE 7007
CMD ["node", "packages/backend", "--config", "app-config.yaml", "--config", "app-config.production.yaml"]
DF

(cd "$root" && docker image build . --tag portal:run)
sudo mkdir -p /etc/portal-lab
docker image inspect --format '{{.Id}}' portal:run | sudo tee /etc/portal-lab/image.id >/dev/null
sudo chmod 644 /etc/portal-lab/image.id
(cd "$root" && sha256sum runtime/app-config.runtime.yaml runtime/portal.env) | sudo tee /etc/portal-lab/runtime.sha256 >/dev/null

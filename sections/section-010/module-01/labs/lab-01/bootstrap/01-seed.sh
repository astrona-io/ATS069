#!/usr/bin/env bash
# Creates the example portal workspace in /opt/portal.
# The workspace is a small stand-in with the shape of a Backstage project, not a real one.
# Faults seeded: port, startpath, copylist
set -eu

sudo mkdir -p /opt/portal
sudo chmod 777 /opt/portal
cd /opt/portal

cat > package.json <<'EOF_FILE'
{
  "name": "portal",
  "private": true,
  "version": "1.0.0",
  "packageManager": "yarn@4.4.1",
  "workspaces": ["packages/*"],
  "scripts": {
    "start": "node scripts/dev.js",
    "start:backend": "yarn workspace backend start",
    "build:backend": "yarn workspace backend build",
    "build:all": "yarn workspaces foreach --all run build"
  }
}
EOF_FILE

cat > .yarnrc.yml <<'EOF_FILE'
nodeLinker: node-modules
enableTelemetry: false
EOF_FILE

cat > .gitignore <<'EOF_FILE'
node_modules
dist
.yarn/install-state.gz
EOF_FILE

cat > app-config.yaml <<'EOF_FILE'
# Base configuration, loaded first.
app:
  baseUrl: http://localhost:3000
backend:
  baseUrl: http://localhost:7007
  githubToken: ghp_example_token
EOF_FILE

cat > app-config.production.yaml <<'EOF_FILE'
# Loaded after app-config.yaml and overrides it.
environment: production
EOF_FILE

mkdir -p scripts
cat > scripts/dev.js <<'EOF_FILE'
'use strict';
// Starts the app and the backend as two separate processes.
const { spawn } = require('child_process');
const children = ['backend', 'app'].map(name =>
  spawn('yarn', ['workspace', name, 'start'], { stdio: 'inherit' }));
const stop = () => children.forEach(c => c.kill('SIGTERM'));
process.on('SIGINT', stop);
process.on('SIGTERM', stop);
EOF_FILE

mkdir -p scripts
cat > scripts/build.js <<'EOF_FILE'
'use strict';
// Copies <package>/src to <package>/dist. With --config it also writes the
// browser-visible configuration to dist/config.json.
const fs = require('fs');
const path = require('path');
const { loadConfig } = require('./config');

const pkgDir = process.cwd();
const src = path.join(pkgDir, 'src');
const dist = path.join(pkgDir, 'dist');
fs.rmSync(dist, { recursive: true, force: true });
fs.mkdirSync(dist, { recursive: true });
for (const file of ['index.js']) {
  fs.copyFileSync(path.join(src, file), path.join(dist, file));
}

const args = process.argv.slice(2);
const configFiles = [];
for (let i = 0; i < args.length; i++) {
  if (args[i] === '--config') configFiles.push(path.resolve(pkgDir, args[++i]));
}
if (configFiles.length > 0) {
  const cfg = loadConfig(configFiles);
  const visible = { app: cfg.app, backendUrl: cfg.backend.baseUrl };
  fs.writeFileSync(path.join(dist, 'config.json'), JSON.stringify(visible));
}
console.log('built ' + path.basename(pkgDir));
EOF_FILE

mkdir -p scripts
cat > scripts/config.js <<'EOF_FILE'
'use strict';
// Minimal configuration reader for the example workspace. It reads nested
// "key: value" lines and merges files in order, the way repeated --config
// options are merged in a Backstage project.
const fs = require('fs');

function parse(text) {
  const root = {};
  const stack = [{ indent: -1, node: root }];
  for (const raw of text.split('\n')) {
    const line = raw.replace(/\s+#.*$/, '').replace(/^#.*$/, '').replace(/\s+$/, '');
    if (!line.trim()) continue;
    const indent = line.match(/^ */)[0].length;
    const m = line.trim().match(/^([A-Za-z0-9_.-]+):\s*(.*)$/);
    if (!m) throw new Error('Cannot parse config line: ' + raw);
    while (stack[stack.length - 1].indent >= indent) stack.pop();
    const parent = stack[stack.length - 1].node;
    if (m[2] === '') {
      parent[m[1]] = {};
      stack.push({ indent, node: parent[m[1]] });
    } else {
      parent[m[1]] = /^\d+$/.test(m[2]) ? Number(m[2]) : m[2];
    }
  }
  return root;
}

function merge(a, b) {
  for (const key of Object.keys(b)) {
    if (typeof b[key] === 'object' && typeof a[key] === 'object') merge(a[key], b[key]);
    else a[key] = b[key];
  }
  return a;
}

function loadConfig(files) {
  let cfg = {};
  for (const file of files) {
    let text;
    try {
      text = fs.readFileSync(file, 'utf8');
    } catch (e) {
      throw new Error('Failed to read config file ' + file);
    }
    cfg = merge(cfg, parse(text));
  }
  return cfg;
}

function requireKey(cfg, key) {
  let value = cfg;
  for (const part of key.split('.')) value = value === undefined ? undefined : value[part];
  if (value === undefined) throw new Error("Missing required config value at '" + key + "'");
  return value;
}

module.exports = { loadConfig, requireKey };
EOF_FILE

mkdir -p packages/backend
cat > packages/backend/package.json <<'EOF_FILE'
{
  "name": "backend",
  "version": "1.0.0",
  "private": true,
  "main": "src/index.js",
  "scripts": {
    "start": "node src/index.js --config app-config.yaml",
    "build": "node ../../scripts/build.js"
  }
}
EOF_FILE

mkdir -p packages/backend/src
cat > packages/backend/src/config.js <<'EOF_FILE'
'use strict';
// Minimal configuration reader for the example workspace. It reads nested
// "key: value" lines and merges files in order, the way repeated --config
// options are merged in a Backstage project.
const fs = require('fs');

function parse(text) {
  const root = {};
  const stack = [{ indent: -1, node: root }];
  for (const raw of text.split('\n')) {
    const line = raw.replace(/\s+#.*$/, '').replace(/^#.*$/, '').replace(/\s+$/, '');
    if (!line.trim()) continue;
    const indent = line.match(/^ */)[0].length;
    const m = line.trim().match(/^([A-Za-z0-9_.-]+):\s*(.*)$/);
    if (!m) throw new Error('Cannot parse config line: ' + raw);
    while (stack[stack.length - 1].indent >= indent) stack.pop();
    const parent = stack[stack.length - 1].node;
    if (m[2] === '') {
      parent[m[1]] = {};
      stack.push({ indent, node: parent[m[1]] });
    } else {
      parent[m[1]] = /^\d+$/.test(m[2]) ? Number(m[2]) : m[2];
    }
  }
  return root;
}

function merge(a, b) {
  for (const key of Object.keys(b)) {
    if (typeof b[key] === 'object' && typeof a[key] === 'object') merge(a[key], b[key]);
    else a[key] = b[key];
  }
  return a;
}

function loadConfig(files) {
  let cfg = {};
  for (const file of files) {
    let text;
    try {
      text = fs.readFileSync(file, 'utf8');
    } catch (e) {
      throw new Error('Failed to read config file ' + file);
    }
    cfg = merge(cfg, parse(text));
  }
  return cfg;
}

function requireKey(cfg, key) {
  let value = cfg;
  for (const part of key.split('.')) value = value === undefined ? undefined : value[part];
  if (value === undefined) throw new Error("Missing required config value at '" + key + "'");
  return value;
}

module.exports = { loadConfig, requireKey };
EOF_FILE

mkdir -p packages/backend/src
cat > packages/backend/src/index.js <<'EOF_FILE'
'use strict';
const http = require('http');
const { loadConfig, requireKey } = require('./config');

const args = process.argv.slice(2);
const files = [];
for (let i = 0; i < args.length; i++) {
  if (args[i] === '--config') files.push(args[++i]);
}

let cfg;
try {
  cfg = loadConfig(files);
  ['backend.baseUrl', 'backend.listen.port', 'app.baseUrl'].forEach(key => requireKey(cfg, key));
} catch (e) {
  console.error('Error: ' + e.message);
  process.exit(1);
}

const environment = cfg.environment || 'development';
const server = http.createServer((req, res) => {
  res.setHeader('Content-Type', 'application/json');
  if (req.url === '/healthcheck') {
    res.end(JSON.stringify({ status: 'ok', environment }));
  } else if (req.url === '/api/deployment-status') {
    res.end(JSON.stringify({ service: 'portal-backend', state: 'ready' }));
  } else {
    res.statusCode = 404;
    res.end(JSON.stringify({ error: 'not found' }));
  }
});
server.listen(cfg.backend.listen.port, () => {
  console.log('backend listening on ' + cfg.backend.listen.port + ' (' + environment + ')');
});
EOF_FILE

mkdir -p packages/app
cat > packages/app/package.json <<'EOF_FILE'
{
  "name": "app",
  "version": "1.0.0",
  "private": true,
  "scripts": {
    "start": "node src/server.js --config ../../app-config.yaml",
    "build": "node ../../scripts/build.js --config ../../app-config.yaml --config ../../app-config.production.yaml"
  }
}
EOF_FILE

mkdir -p packages/app/src
cat > packages/app/src/config.js <<'EOF_FILE'
'use strict';
// Minimal configuration reader for the example workspace. It reads nested
// "key: value" lines and merges files in order, the way repeated --config
// options are merged in a Backstage project.
const fs = require('fs');

function parse(text) {
  const root = {};
  const stack = [{ indent: -1, node: root }];
  for (const raw of text.split('\n')) {
    const line = raw.replace(/\s+#.*$/, '').replace(/^#.*$/, '').replace(/\s+$/, '');
    if (!line.trim()) continue;
    const indent = line.match(/^ */)[0].length;
    const m = line.trim().match(/^([A-Za-z0-9_.-]+):\s*(.*)$/);
    if (!m) throw new Error('Cannot parse config line: ' + raw);
    while (stack[stack.length - 1].indent >= indent) stack.pop();
    const parent = stack[stack.length - 1].node;
    if (m[2] === '') {
      parent[m[1]] = {};
      stack.push({ indent, node: parent[m[1]] });
    } else {
      parent[m[1]] = /^\d+$/.test(m[2]) ? Number(m[2]) : m[2];
    }
  }
  return root;
}

function merge(a, b) {
  for (const key of Object.keys(b)) {
    if (typeof b[key] === 'object' && typeof a[key] === 'object') merge(a[key], b[key]);
    else a[key] = b[key];
  }
  return a;
}

function loadConfig(files) {
  let cfg = {};
  for (const file of files) {
    let text;
    try {
      text = fs.readFileSync(file, 'utf8');
    } catch (e) {
      throw new Error('Failed to read config file ' + file);
    }
    cfg = merge(cfg, parse(text));
  }
  return cfg;
}

function requireKey(cfg, key) {
  let value = cfg;
  for (const part of key.split('.')) value = value === undefined ? undefined : value[part];
  if (value === undefined) throw new Error("Missing required config value at '" + key + "'");
  return value;
}

module.exports = { loadConfig, requireKey };
EOF_FILE

mkdir -p packages/app/src
cat > packages/app/src/index.html <<'EOF_FILE'
<!doctype html>
<html><head><title>Portal</title></head>
<body><h1>Portal</h1><p>Catalog page</p></body></html>
EOF_FILE

mkdir -p packages/app/src
cat > packages/app/src/server.js <<'EOF_FILE'
'use strict';
// Serves the browser files. In development it reads the configuration;
// from a build it serves the config.json that the build wrote.
const http = require('http');
const fs = require('fs');
const path = require('path');
const { loadConfig, requireKey } = require('./config');

const args = process.argv.slice(2);
const files = [];
for (let i = 0; i < args.length; i++) {
  if (args[i] === '--config') files.push(path.resolve(args[++i]));
}
const builtConfig = path.join(__dirname, 'config.json');

let visible;
if (fs.existsSync(builtConfig)) {
  visible = JSON.parse(fs.readFileSync(builtConfig, 'utf8'));
} else {
  try {
    const cfg = loadConfig(files);
    requireKey(cfg, 'app.baseUrl');
    requireKey(cfg, 'backend.baseUrl');
    visible = { app: cfg.app, backendUrl: cfg.backend.baseUrl };
  } catch (e) {
    console.error('Error: ' + e.message);
    process.exit(1);
  }
}

const port = Number(new URL(visible.app.baseUrl).port);
const server = http.createServer((req, res) => {
  if (req.url === '/config.json') {
    res.setHeader('Content-Type', 'application/json');
    res.end(JSON.stringify(visible));
  } else {
    res.setHeader('Content-Type', 'text/html');
    res.end(fs.readFileSync(path.join(__dirname, 'index.html')));
  }
});
server.listen(port, () => console.log('app listening on ' + port));
EOF_FILE

yarn install
sudo chmod -R a+rwX /opt/portal

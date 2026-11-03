#!/usr/bin/env bash
# Creates the example scaffold workspace in /opt/scaffold.
# The workspace is a small stand-in with the layout of a project made by @backstage/create-app. It has no registry dependencies.
# Faults seeded: none
set -eu

sudo mkdir -p /opt/scaffold
sudo chmod 777 /opt/scaffold
cd /opt/scaffold

cat > package.json <<'EOF_FILE'
{
  "name": "root",
  "version": "1.0.0",
  "private": true,
  "engines": {
    "node": "20 || 22"
  },
  "packageManager": "yarn@4.4.1",
  "workspaces": {
    "packages": ["packages/*", "plugins/*"]
  },
  "scripts": {
    "dev": "yarn workspaces foreach -A --include backend --include app --parallel -v -i run start",
    "start": "yarn workspace app start",
    "start-backend": "yarn workspace backend start",
    "build:backend": "yarn workspace backend build",
    "build:all": "backstage-cli repo build --all",
    "tsc": "tsc",
    "lint": "backstage-cli repo lint --since origin/master",
    "test": "backstage-cli repo test",
    "new": "backstage-cli new"
  }
}
EOF_FILE

cat > .yarnrc.yml <<'EOF_FILE'
nodeLinker: node-modules
enableTelemetry: false
EOF_FILE

cat > backstage.json <<'EOF_FILE'
{
  "version": "1.35.0"
}
EOF_FILE

cat > app-config.yaml <<'EOF_FILE'
app:
  title: Scaffolded App
  baseUrl: http://localhost:3000
backend:
  baseUrl: http://localhost:7007
  listen:
    port: 7007
EOF_FILE

cat > catalog-info.yaml <<'EOF_FILE'
apiVersion: backstage.io/v1alpha1
kind: Component
metadata:
  name: scaffold-app
spec:
  type: website
  lifecycle: experimental
  owner: platform-team
EOF_FILE

mkdir -p packages/app packages/backend plugins/status plugins/status-backend tools

cat > packages/app/package.json <<'EOF_FILE'
{
  "name": "app",
  "version": "0.0.0",
  "private": true,
  "backstage": { "role": "frontend" },
  "scripts": {
    "start": "backstage-cli package start",
    "build": "backstage-cli package build",
    "lint": "backstage-cli package lint",
    "test": "backstage-cli package test"
  }
}
EOF_FILE

cat > packages/backend/package.json <<'EOF_FILE'
{
  "name": "backend",
  "version": "0.0.0",
  "private": true,
  "backstage": { "role": "backend" },
  "main": "dist/index.cjs.js",
  "scripts": {
    "start": "backstage-cli package start",
    "build": "backstage-cli package build",
    "lint": "backstage-cli package lint",
    "test": "backstage-cli package test"
  }
}
EOF_FILE

cat > plugins/status/package.json <<'EOF_FILE'
{
  "name": "@internal/plugin-status",
  "version": "0.1.0",
  "backstage": { "role": "frontend-plugin" },
  "scripts": {
    "build": "backstage-cli package build",
    "test": "backstage-cli package test"
  }
}
EOF_FILE

cat > plugins/status-backend/package.json <<'EOF_FILE'
{
  "name": "@internal/plugin-status-backend",
  "version": "0.1.0",
  "backstage": { "role": "backend-plugin" },
  "scripts": {
    "build": "backstage-cli package build",
    "test": "backstage-cli package test"
  }
}
EOF_FILE

cat > tools/check-env.js <<'EOF_FILE'
'use strict';
// Compares the running Node.js major version with the engines.node field of the root package.json.
const pkg = require('../package.json');
const major = Number(process.versions.node.split('.')[0]);
const allowed = String(pkg.engines.node).split('||').map(s => Number(s.trim()));
console.log('node major: ' + major);
console.log('allowed majors: ' + allowed.join(', '));
console.log('yarn field: ' + pkg.packageManager);
if (!allowed.includes(major)) {
  console.error('This project does not allow Node.js ' + major);
  process.exit(1);
}
EOF_FILE

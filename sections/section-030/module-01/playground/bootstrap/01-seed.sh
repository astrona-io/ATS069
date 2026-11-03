#!/usr/bin/env bash
# Playground seed: a small TypeScript workspace shaped like a Backstage repository.
# It is a simplified fixture, not a real Backstage app. No task, no grading.
set -euo pipefail
cd /opt/portal
mkdir -p plugins/deploy-common/src plugins/deploy-backend/src packages/app/src

cat > package.json <<'EOF'
{
  "name": "portal",
  "private": true,
  "workspaces": ["packages/*", "plugins/*"],
  "scripts": {
    "tsc": "tsc -p tsconfig.check.json",
    "build:all": "tsc --build"
  }
}
EOF

cat > tsconfig.base.json <<'EOF'
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "commonjs",
    "moduleResolution": "node10",
    "strict": true,
    "skipLibCheck": true,
    "types": [],
    "composite": true,
    "paths": {
      "@portal/deploy-common": ["./plugins/deploy-common/src"]
    }
  }
}
EOF

# Flat project: one check over every source folder. It writes no files.
cat > tsconfig.check.json <<'EOF'
{
  "extends": "./tsconfig.base.json",
  "compilerOptions": { "composite": false, "noEmit": true },
  "include": ["packages/*/src", "plugins/*/src"]
}
EOF

# Solution file: builds the three projects in dependency order.
cat > tsconfig.json <<'EOF'
{
  "files": [],
  "references": [
    { "path": "./plugins/deploy-common" },
    { "path": "./plugins/deploy-backend" },
    { "path": "./packages/app" }
  ]
}
EOF

cat > plugins/deploy-common/package.json <<'EOF'
{ "name": "@portal/deploy-common", "version": "1.0.0", "private": true }
EOF
cat > plugins/deploy-common/tsconfig.json <<'EOF'
{
  "extends": "../../tsconfig.base.json",
  "compilerOptions": { "rootDir": "src", "outDir": "dist" },
  "include": ["src"]
}
EOF
cat > plugins/deploy-common/src/index.ts <<'EOF'
export type DeploymentStatus = 'running' | 'failed';

export interface DeploymentRecord {
  id: string;
  status: DeploymentStatus;
  owner?: string;
}

export function isDeploymentStatus(value: unknown): value is DeploymentStatus {
  return value === 'running' || value === 'failed';
}

export function parseDeployment(input: unknown): DeploymentRecord {
  if (typeof input !== 'object' || input === null) {
    throw new Error('deployment must be an object');
  }
  const { id, status, owner } = input as Record<string, unknown>;
  if (typeof id !== 'string') {
    throw new Error('id must be a string');
  }
  if (!isDeploymentStatus(status)) {
    throw new Error('status must be running or failed');
  }
  if (owner !== undefined && typeof owner !== 'string') {
    throw new Error('owner must be a string');
  }
  return { id, status, owner };
}
EOF

cat > plugins/deploy-backend/package.json <<'EOF'
{ "name": "@portal/deploy-backend", "version": "1.0.0", "private": true }
EOF
cat > plugins/deploy-backend/tsconfig.json <<'EOF'
{
  "extends": "../../tsconfig.base.json",
  "compilerOptions": { "rootDir": "src", "outDir": "dist" },
  "include": ["src"],
  "references": [{ "path": "../deploy-common" }]
}
EOF
cat > plugins/deploy-backend/src/index.ts <<'EOF'
import type { DeploymentRecord } from '@portal/deploy-common';

export function describeOwner(record: DeploymentRecord): string {
  return record.owner === undefined ? 'unassigned' : record.owner.toUpperCase();
}

export function summarize(record: DeploymentRecord): string {
  return `${record.id}: ${record.status} (${describeOwner(record)})`;
}
EOF

cat > packages/app/package.json <<'EOF'
{ "name": "app", "version": "1.0.0", "private": true }
EOF
cat > packages/app/tsconfig.json <<'EOF'
{
  "extends": "../../tsconfig.base.json",
  "compilerOptions": { "rootDir": "src", "outDir": "dist" },
  "include": ["src"],
  "references": [{ "path": "../../plugins/deploy-common" }]
}
EOF
cat > packages/app/src/index.ts <<'EOF'
import { parseDeployment } from '@portal/deploy-common';

export function renderRow(body: string): string {
  const record = parseDeployment(JSON.parse(body));
  return `${record.id} - ${record.status}`;
}
EOF
chmod -R a+rwX /opt/portal

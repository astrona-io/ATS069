#!/usr/bin/env bash
# Capstone seed: a composite TypeScript workspace shaped like a Backstage repository, with faults.
# Fault 1: the root tsconfig.json does not reference the app project.
# Fault 2: deploy-backend does not reference deploy-common.
# Fault 3: the app passes an invalid status and trusts parsed JSON with an assertion.
# Fault 4: deploy-common has no runtime parser; the build:all script runs plain tsc.
set -euo pipefail
cd /opt/portal
mkdir -p plugins/deploy-common/src plugins/deploy-backend/src packages/app/src

cat > package.json <<'EOF'
{
  "name": "portal",
  "private": true,
  "workspaces": ["packages/*", "plugins/*"],
  "scripts": {
    "tsc": "tsc",
    "build:all": "tsc"
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

cat > tsconfig.json <<'EOF'
{
  "files": [],
  "references": [
    { "path": "./plugins/deploy-common" },
    { "path": "./plugins/deploy-backend" }
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
EOF

cat > plugins/deploy-backend/package.json <<'EOF'
{ "name": "@portal/deploy-backend", "version": "1.0.0", "private": true }
EOF
cat > plugins/deploy-backend/tsconfig.json <<'EOF'
{
  "extends": "../../tsconfig.base.json",
  "compilerOptions": { "rootDir": "src", "outDir": "dist" },
  "include": ["src"]
}
EOF
cat > plugins/deploy-backend/src/index.ts <<'EOF'
import type { DeploymentRecord } from '@portal/deploy-common';

export function describeOwner(record: DeploymentRecord): string {
  return record.owner === undefined ? 'unassigned' : record.owner.toUpperCase();
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
import type { DeploymentRecord } from '@portal/deploy-common';

export const sample: DeploymentRecord = { id: 'bridge-1', status: 'done' };

export function renderRow(body: string): string {
  const record = JSON.parse(body) as DeploymentRecord;
  return `${record.id} - ${record.status}`;
}
EOF
chmod -R a+rwX /opt/portal

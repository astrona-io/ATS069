#!/usr/bin/env bash
# Reference solution, applied by astrona test only.
set -euo pipefail
cd /opt/portal

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
cat > plugins/deploy-backend/tsconfig.json <<'EOF'
{
  "extends": "../../tsconfig.base.json",
  "compilerOptions": { "rootDir": "src", "outDir": "dist" },
  "include": ["src"],
  "references": [{ "path": "../deploy-common" }]
}
EOF
cat >> plugins/deploy-common/src/index.ts <<'EOF'

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
cat > packages/app/src/index.ts <<'EOF'
import { parseDeployment } from '@portal/deploy-common';
import type { DeploymentRecord } from '@portal/deploy-common';

export const sample: DeploymentRecord = { id: 'bridge-1', status: 'running' };

export function renderRow(body: string): string {
  const record = parseDeployment(JSON.parse(body));
  return `${record.id} - ${record.status}`;
}
EOF
sed -i 's#"build:all": "tsc"#"build:all": "tsc --build"#' package.json
tsc --build

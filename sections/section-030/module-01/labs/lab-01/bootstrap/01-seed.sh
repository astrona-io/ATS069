#!/usr/bin/env bash
# Lab seed: a simplified Backstage-shaped TypeScript workspace with three faults.
# Fault 1: tsconfig.json includes only packages/*/src, so the plugins are never checked.
# Fault 2: deploy-backend reads an optional property without handling absence.
# Fault 3: tsconfig.json does not set noEmit, so a check would write .js files next to the sources.
set -euo pipefail
cd /opt/portal
mkdir -p plugins/deploy-common/src plugins/deploy-backend/src packages/app/src

cat > package.json <<'EOF'
{
  "name": "portal",
  "private": true,
  "workspaces": ["packages/*", "plugins/*"],
  "scripts": { "tsc": "tsc" }
}
EOF

cat > tsconfig.json <<'EOF'
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "commonjs",
    "moduleResolution": "node10",
    "strict": true,
    "skipLibCheck": true,
    "types": [],
    "paths": {
      "@portal/deploy-common": ["./plugins/deploy-common/src"]
    }
  },
  "include": ["packages/*/src"]
}
EOF

cat > plugins/deploy-common/package.json <<'EOF'
{ "name": "@portal/deploy-common", "version": "1.0.0", "private": true }
EOF
cat > plugins/deploy-common/src/index.ts <<'EOF'
export type DeploymentStatus = 'running' | 'failed';

export interface DeploymentRecord {
  id: string;
  status: DeploymentStatus;
  owner?: string;
}
EOF

cat > plugins/deploy-backend/package.json <<'EOF'
{ "name": "@portal/deploy-backend", "version": "1.0.0", "private": true }
EOF
cat > plugins/deploy-backend/src/index.ts <<'EOF'
import type { DeploymentRecord } from '@portal/deploy-common';

export function describeOwner(record: DeploymentRecord): string {
  return record.owner.toUpperCase();
}

export function summarize(record: DeploymentRecord): string {
  return `${record.id}: ${record.status} (${describeOwner(record)})`;
}
EOF

cat > packages/app/package.json <<'EOF'
{ "name": "app", "version": "1.0.0", "private": true }
EOF
cat > packages/app/src/index.ts <<'EOF'
import type { DeploymentRecord } from '@portal/deploy-common';

export function renderRow(record: DeploymentRecord): string {
  return `${record.id} - ${record.status}`;
}
EOF
chmod -R a+rwX /opt/portal

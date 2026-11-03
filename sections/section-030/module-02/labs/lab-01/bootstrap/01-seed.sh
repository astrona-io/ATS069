#!/usr/bin/env bash
# Lab seed. Faults:
# 1. tsconfig.json does not extend the shared base and sets strict to false.
# 2. Under strict, deploy-backend has an implicit any parameter.
# 3. package.json has no tsc:full script.
# 4. The root check writes .js files next to sources and .gitignore does not list dist-types.
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

cat > tsconfig.base.json <<'EOF'
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "commonjs",
    "moduleResolution": "node10",
    "strict": true,
    "skipLibCheck": true,
    "incremental": true,
    "declaration": true,
    "emitDeclarationOnly": true,
    "types": [],
    "paths": {
      "@portal/deploy-common": ["./plugins/deploy-common/src"]
    }
  }
}
EOF

cat > tsconfig.json <<'EOF'
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "commonjs",
    "moduleResolution": "node10",
    "strict": false,
    "skipLibCheck": true,
    "types": [],
    "paths": {
      "@portal/deploy-common": ["./plugins/deploy-common/src"]
    }
  },
  "include": ["packages/*/src", "plugins/*/src"]
}
EOF

printf 'node_modules\n' > .gitignore

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

export function summarize(record) {
  return `${record.id}: ${record.status}`;
}

export function listIds(records: DeploymentRecord[]): string[] {
  return records.map(item => item.id);
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

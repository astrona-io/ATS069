#!/usr/bin/env bash
# Playground seed: a TypeScript workspace with a shared base configuration, the root check
# scripts and a declaration file with a deliberate error that only the full check reports.
# Simplified fixture, not a real Backstage app. No task, no grading.
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
    "tsc:full": "tsc --skipLibCheck false --incremental false"
  }
}
EOF

# Stand-in for the shared base that a Backstage repository extends from @backstage/cli.
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
  "extends": "./tsconfig.base.json",
  "include": ["packages/*/src", "plugins/*/src"],
  "exclude": ["node_modules"],
  "compilerOptions": {
    "outDir": "dist-types",
    "rootDir": "."
  }
}
EOF

printf 'node_modules\ndist-types\n' > .gitignore

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

export function summarize(record: DeploymentRecord): string {
  return `${record.id}: ${record.status}`;
}
EOF
# A declaration file with an error. skipLibCheck hides it; the full check reports it.
cat > plugins/deploy-backend/src/legacy.d.ts <<'EOF'
declare module 'legacy-lib' {
  export function run(options: LegacyOptions): void;
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

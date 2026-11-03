#!/usr/bin/env bash
# Reference solution, applied by astrona test only.
set -euo pipefail
cd /opt/portal
cat > tsconfig.json <<'EOF'
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "commonjs",
    "moduleResolution": "node10",
    "strict": true,
    "skipLibCheck": true,
    "noEmit": true,
    "types": [],
    "paths": {
      "@portal/deploy-common": ["./plugins/deploy-common/src"]
    }
  },
  "include": ["packages/*/src", "plugins/*/src"]
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

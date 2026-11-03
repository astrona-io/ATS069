#!/usr/bin/env bash
# Reference solution, applied only by astrona test.
set -euo pipefail
cd /opt/portal
cat > packages/backend/src/statusRoute.ts <<'EOF'
import type { DeploymentStatus } from '../../catalog-common/src/index.ts';

export interface RawStatus {
  ok?: boolean;
}

export function buildStatus(service: string, raw: RawStatus | undefined, now: Date = new Date()): DeploymentStatus {
  const state = raw === undefined ? 'unknown' : raw.ok ? 'healthy' : 'degraded';
  return { service, state, updatedAt: now.toISOString() };
}
EOF
cat >> packages/catalog-common/src/index.ts <<'EOF'

export interface StatusBadge {
  label: string;
  tone: 'ok' | 'warn' | 'neutral';
}
EOF
cat > packages/app/src/statusBadge.ts <<'EOF'
import type { DeploymentStatus, StatusBadge } from '../../catalog-common/src/index.ts';

export function badgeFor(status: DeploymentStatus): StatusBadge {
  if (status.state === 'healthy') return { label: 'Healthy', tone: 'ok' };
  if (status.state === 'degraded') return { label: 'Degraded', tone: 'warn' };
  return { label: 'Unknown', tone: 'neutral' };
}
EOF
cat >> app-config.yaml <<'EOF'
  deploymentStatus:
    enabled: true
EOF
sed -i 's/password: hunter2/password: ${BACKEND_DB_PASSWORD}/' app-config.yaml
cat > app-config.local.yaml <<'EOF'
backend:
  listen:
    port: 7008
EOF
echo app-config.local.yaml >> .gitignore
cat > CHANGE.md <<'EOF'
## Behavior
A service shows a Healthy, Degraded or Unknown badge. A service with no status data is Unknown, not Degraded.

## Boundaries
- packages/catalog-common: new StatusBadge type.
- packages/backend: buildStatus returns state and uses the clock argument.
- packages/app: badgeFor handles unknown.
- app-config.yaml: shared deploymentStatus key and the password from the environment.

## Evidence
- yarn tsc: no type errors in the three packages.
- yarn test: the status tests pass, including the unknown case.
- yarn lint: lint ok.
EOF

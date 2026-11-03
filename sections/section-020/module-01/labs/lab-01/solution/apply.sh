#!/usr/bin/env bash
# Reference solution, applied only by astrona test.
set -euo pipefail
cd /opt/portal
cat > packages/app/src/ownerWarning.ts <<'EOF'
import type { Entity, OwnerState } from '../../catalog-common/src/index.ts';

export function ownerState(entity: Entity | undefined): OwnerState {
  if (!entity) return 'error';
  if (!entity.spec?.owner) return 'missing';
  return 'owned';
}
EOF
cat >> app-config.yaml <<'EOF'
catalog:
  ownerWarning:
    enabled: true
EOF
sed -i 's/password: hunter2/password: ${BACKEND_DB_PASSWORD}/' app-config.yaml
cat > app-config.local.yaml <<'EOF'
backend:
  listen:
    port: 7008
  database:
    connection:
      host: 127.0.0.1
EOF
echo app-config.local.yaml >> .gitignore

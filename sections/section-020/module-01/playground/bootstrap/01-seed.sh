#!/usr/bin/env bash
# Seeds the simplified portal workspace in /opt/portal. The shape follows a Backstage project
# (Yarn workspaces, app and backend packages, app-config files); it is not a generated Backstage app.
set -euo pipefail
cd /opt/portal
rm -rf ./* ./.git ./.gitignore ./.yarnrc.yml 2>/dev/null || true
mkdir -p packages/app/src packages/backend/src packages/catalog-common/src scripts

cat > package.json <<'EOF'
{
  "name": "portal",
  "version": "1.0.0",
  "private": true,
  "packageManager": "yarn@4.9.2",
  "workspaces": ["packages/*"],
  "scripts": {
    "start": "node --watch --experimental-strip-types packages/backend/src/index.ts",
    "tsc": "tsc --noEmit",
    "lint": "node scripts/lint.mjs",
    "test": "node --experimental-strip-types --test \"packages/**/*.test.ts\""
  },
  "devDependencies": {
    "@types/node": "^22.15.0",
    "typescript": "5.8.3"
  }
}
EOF
cat > .yarnrc.yml <<'EOF'
nodeLinker: node-modules
EOF
cat > tsconfig.json <<'EOF'
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "esnext",
    "moduleResolution": "bundler",
    "strict": true,
    "noEmit": true,
    "allowImportingTsExtensions": true,
    "erasableSyntaxOnly": true,
    "skipLibCheck": true,
    "types": ["node"]
  },
  "include": ["packages/*/src"]
}
EOF
for pkg in app backend catalog-common; do
cat > packages/$pkg/package.json <<EOF
{
  "name": "@portal/$pkg",
  "version": "1.0.0",
  "private": true
}
EOF
done

cat > scripts/lint.mjs <<'EOF'
import { readdirSync, readFileSync } from 'node:fs';
import { join } from 'node:path';

const rules = [
  { name: 'no-explicit-any', pattern: /:\s*any\b/ },
  { name: 'no-console-debug', pattern: /console\.debug\(/ },
  { name: 'no-debugger', pattern: /\bdebugger\b/ },
];

function walk(dir) {
  const files = [];
  for (const entry of readdirSync(dir, { withFileTypes: true })) {
    if (entry.name === 'node_modules') continue;
    const path = join(dir, entry.name);
    if (entry.isDirectory()) files.push(...walk(path));
    else if (path.endsWith('.ts')) files.push(path);
  }
  return files;
}

let problems = 0;
for (const file of walk('packages')) {
  readFileSync(file, 'utf8').split('\n').forEach((line, index) => {
    for (const rule of rules) {
      if (rule.pattern.test(line)) {
        console.error(`${file}:${index + 1} ${rule.name}`);
        problems += 1;
      }
    }
  });
}
if (problems > 0) {
  console.error(`${problems} lint problem(s)`);
  process.exit(1);
}
console.log('lint ok');
EOF

cat > scripts/show-config.py <<'EOF'
#!/usr/bin/env python3
"""Print the merge of the config files given as arguments. The last file has the highest priority.
Objects merge deeply; values and arrays are replaced. ${ENV} references are printed as written."""
import sys
import yaml


def merge(base, extra):
    for key, value in extra.items():
        if isinstance(value, dict) and isinstance(base.get(key), dict):
            merge(base[key], value)
        else:
            base[key] = value
    return base


merged = {}
for path in sys.argv[1:]:
    with open(path) as handle:
        merge(merged, yaml.safe_load(handle) or {})
print(yaml.safe_dump(merged, default_flow_style=False, sort_keys=True), end="")
EOF
chmod +x scripts/show-config.py

cat > packages/backend/src/index.ts <<'EOF'
import { createServer } from 'node:http';

const port = Number(process.env.PORTAL_PORT ?? '7007');

const server = createServer((request, response) => {
  if (request.url === '/api/health') {
    response.writeHead(200, { 'content-type': 'application/json' });
    response.end(JSON.stringify({ status: 'ok' }));
    return;
  }
  response.writeHead(404);
  response.end();
});

server.listen(port, () => {
  console.log(`portal backend listening on ${port}`);
});
EOF

cat > app-config.production.yaml <<'EOF'
app:
  baseUrl: https://portal.example.com
backend:
  baseUrl: https://portal.example.com
EOF

cat > packages/catalog-common/src/index.ts <<'EOF'
export interface Entity {
  kind: string;
  metadata: { name: string };
  spec?: { owner?: string };
}

export type OwnerState = 'owned' | 'missing' | 'error';
EOF

cat > packages/app/src/ownerWarning.test.ts <<'EOF'
import assert from 'node:assert/strict';
import { test } from 'node:test';
import { ownerState } from './ownerWarning.ts';

test('an entity with an owner is owned', () => {
  const entity = { kind: 'Component', metadata: { name: 'scout' }, spec: { owner: 'team-a' } };
  assert.equal(ownerState(entity), 'owned');
});

test('an entity without an owner is missing, not an error', () => {
  const entity = { kind: 'Component', metadata: { name: 'probe' }, spec: {} };
  assert.equal(ownerState(entity), 'missing');
});

test('a failed catalog request is an error', () => {
  assert.equal(ownerState(undefined), 'error');
});
EOF

cat > packages/app/src/ownerWarning.ts <<'EOF'
import type { Entity, OwnerState } from '../../catalog-common/src/index.ts';

export function ownerState(entity: Entity | undefined): OwnerState {
  if (!entity) return 'error';
  if (!entity.spec?.owner) return 'missing';
  return 'owned';
}
EOF

cat > .gitignore <<'EOF'
node_modules/
.yarn/
dist/
app-config.local.yaml
EOF
cat > app-config.yaml <<'EOF'
app:
  title: Starfleet Portal
  baseUrl: http://localhost:3000
backend:
  baseUrl: http://localhost:7007
  listen:
    port: 7007
  database:
    client: pg
    connection:
      host: localhost
      port: 5432
      user: portal
      password: ${BACKEND_DB_PASSWORD}
catalog:
  ownerWarning:
    enabled: true
EOF

sudo mkdir -p /var/lib/portal-lab
sudo sh -c 'cd /opt/portal && sha256sum $(find packages -name "*.test.ts" | sort) > /var/lib/portal-lab/tests.sha256'
sudo git config --system --add safe.directory /opt/portal
yarn install
git init -q
git add -A
git -c user.name=portal -c user.email=portal@example.com commit -q -m "initial portal workspace"

cat > app-config.local.yaml <<'EOF'
backend:
  listen:
    port: 7008
  database:
    connection:
      host: 127.0.0.1
EOF

sudo tee /usr/local/bin/portal-check >/dev/null <<'EOF'
#!/usr/bin/env bash
# Runs the three feedback checks in order and reports each result.
cd /opt/portal
for check in tsc lint test; do
  if yarn "$check" >/dev/null 2>&1; then echo "ok   $check"; else echo "FAIL $check"; fi
done
EOF
sudo chmod +x /usr/local/bin/portal-check

#!/usr/bin/env bash
# Playground seed: a workspace with four packages that have Backstage roles, a transpile-only build
# and a root type check. Simplified fixture, not a real Backstage app. No task, no grading.
set -euo pipefail
cd /opt/portal
mkdir -p packages/app/src packages/backend/src plugins/deploy-common/src plugins/deploy-backend/src scripts

cat > tsconfig.base.json <<'EOF'
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "commonjs",
    "moduleResolution": "node10",
    "strict": true,
    "skipLibCheck": true,
    "types": []
  }
}
EOF

# Root type check: reads every package and writes nothing.
cat > tsconfig.json <<'EOF'
{
  "extends": "./tsconfig.base.json",
  "compilerOptions": { "noEmit": true },
  "include": ["packages/*/src", "plugins/*/src"]
}
EOF

# Per-package build configuration. The build script transpiles with --noCheck:
# it removes the types and writes JavaScript, and it does not report type errors.
for dir in packages/app packages/backend plugins/deploy-common plugins/deploy-backend; do
  cat > "$dir/tsconfig.build.json" <<'EOF'
{
  "extends": "../../tsconfig.base.json",
  "compilerOptions": { "outDir": "dist", "rootDir": "src" },
  "include": ["src"]
}
EOF
done

cat > scripts/list-roles.mjs <<'EOF'
import { readdirSync, readFileSync, existsSync } from 'node:fs';

for (const group of ['packages', 'plugins']) {
  for (const name of readdirSync(group).sort()) {
    const file = `${group}/${name}/package.json`;
    if (!existsSync(file)) continue;
    const manifest = JSON.parse(readFileSync(file, 'utf8'));
    const role = manifest.backstage?.role ?? '(no role)';
    console.log(`${manifest.name}\t${role}`);
  }
}
EOF

cat > packages/app/src/index.ts <<'EOF'
export function renderPage(title: string): string {
  return `<h1>${title}</h1>`;
}
EOF
cat > packages/backend/src/index.ts <<'EOF'
export function startBackend(port: number): string {
  return `backend listening on ${port}`;
}
EOF
cat > plugins/deploy-common/src/index.ts <<'EOF'
export type DeploymentStatus = 'running' | 'failed';

export function isDeploymentStatus(value: unknown): value is DeploymentStatus {
  return value === 'running' || value === 'failed';
}
EOF

cat > package.json <<'EOF'
{
  "name": "portal",
  "private": true,
  "workspaces": ["packages/*", "plugins/*"],
  "scripts": {
    "tsc": "tsc",
    "build:all": "npm run build --workspaces --if-present",
    "build:backend": "npm run build --workspace backend"
  }
}
EOF

cat > plugins/deploy-backend/src/index.ts <<'EOF'
export function describeBackend(name: string): string {
  return `${name} (${name.length})`;
}
EOF

write_manifest() {
  cat > "$1/package.json" <<EOF
{
  "name": "$2",
  "version": "1.0.0",
  "private": true,
  "main": "dist/index.js",
  "backstage": { "role": "$3" },
  "files": ["dist"],
  "scripts": {
    "build": "tsc -p tsconfig.build.json --noCheck",
    "clean": "rm -rf dist"
  }
}
EOF
}
write_manifest packages/app app frontend
write_manifest packages/backend backend backend
write_manifest plugins/deploy-common @portal/deploy-common common-library
write_manifest plugins/deploy-backend @portal/deploy-backend backend-plugin
chmod -R a+rwX /opt/portal

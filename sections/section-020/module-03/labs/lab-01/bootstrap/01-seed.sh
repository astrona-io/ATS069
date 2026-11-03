#!/usr/bin/env bash
# Seeds the simplified portal workspace with type check, lint, format check, test, a check script and a Git hook.
# The shape follows the root scripts of a Backstage project; it does not use backstage-cli, Jest or Prettier.
set -euo pipefail
cd /opt/portal
rm -rf ./* ./.git ./.gitignore ./.yarnrc.yml ./.githooks 2>/dev/null || true
mkdir -p packages/app/src packages/backend/src packages/catalog-common/src scripts .githooks

cat > package.json <<'EOF'
{
  "name": "portal",
  "version": "1.0.0",
  "private": true,
  "packageManager": "yarn@4.9.2",
  "workspaces": ["packages/*"],
  "scripts": {
    "tsc": "tsc --noEmit",
    "lint": "node scripts/lint.mjs",
    "lint:changed": "node scripts/lint.mjs --since HEAD",
    "format:check": "node scripts/format.mjs --check",
    "format": "node scripts/format.mjs --write",
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
cat > .gitignore <<'EOF'
node_modules/
.yarn/
dist/
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

cat > scripts/files.mjs <<'EOF'
import { readdirSync } from 'node:fs';
import { execFileSync } from 'node:child_process';
import { join } from 'node:path';

export function allFiles(dir = 'packages') {
  const files = [];
  for (const entry of readdirSync(dir, { withFileTypes: true })) {
    if (entry.name === 'node_modules') continue;
    const path = join(dir, entry.name);
    if (entry.isDirectory()) files.push(...allFiles(path));
    else if (path.endsWith('.ts')) files.push(path);
  }
  return files;
}

// Files that differ from a Git ref, like the --since option of the Backstage repo commands.
export function changedFiles(ref) {
  const out = execFileSync('git', ['diff', '--name-only', ref, '--', 'packages'], { encoding: 'utf8' });
  const untracked = execFileSync('git', ['ls-files', '--others', '--exclude-standard', 'packages'], { encoding: 'utf8' });
  return `${out}${untracked}`.split('\n').filter(f => f.endsWith('.ts'));
}
EOF
cat > scripts/lint.mjs <<'EOF'
import { readFileSync } from 'node:fs';
import { allFiles, changedFiles } from './files.mjs';

const rules = [
  { name: 'no-explicit-any', pattern: /:\s*any\b/ },
  { name: 'no-console-debug', pattern: /console\.debug\(/ },
  { name: 'no-debugger', pattern: /\bdebugger\b/ },
];

const sinceIndex = process.argv.indexOf('--since');
const files = sinceIndex > -1 ? changedFiles(process.argv[sinceIndex + 1]) : allFiles();

let problems = 0;
for (const file of files) {
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
console.log(`lint ok (${files.length} file(s))`);
EOF
cat > scripts/format.mjs <<'EOF'
import { readFileSync, writeFileSync } from 'node:fs';
import { allFiles } from './files.mjs';

// Format rules: two-space indentation (no tabs), no trailing spaces, one newline at the end of the file.
function format(text) {
  const lines = text.split('\n').map(line => line.replace(/^\t+/, tabs => '  '.repeat(tabs.length)).replace(/[ \t]+$/, ''));
  return `${lines.join('\n').replace(/\n+$/, '')}\n`;
}

const write = process.argv.includes('--write');
let wrong = 0;
for (const file of allFiles()) {
  const text = readFileSync(file, 'utf8');
  const formatted = format(text);
  if (text === formatted) continue;
  if (write) writeFileSync(file, formatted);
  else console.error(`${file} is not formatted`);
  wrong += 1;
}
if (wrong > 0 && !write) process.exit(1);
console.log(write ? `formatted ${wrong} file(s)` : 'format ok');
EOF

cat > packages/catalog-common/src/index.ts <<'EOF'
export interface Entity {
  kind: string;
  metadata: { name: string };
  spec?: { owner?: string };
}
EOF
cat > packages/backend/src/health.ts <<'EOF'
export interface Health {
  status: 'ok' | 'degraded';
}

export function healthOf(failedChecks: number): Health {
	console.debug('failed checks', failedChecks);   
	return { status: failedChecks === 0 ? 'ok' : 'degraded' };
}
EOF
cat > packages/backend/src/health.test.ts <<'EOF'
import assert from 'node:assert/strict';
import { test } from 'node:test';
import { healthOf } from './health.ts';

test('no failed checks means ok', () => {
  assert.equal(healthOf(0).status, 'ok');
});

test('one failed check means degraded', () => {
  assert.equal(healthOf(1).status, 'degraded');
});
EOF
cat > packages/app/src/label.ts <<'EOF'
import type { Entity } from '../../catalog-common/src/index.ts';

export function label(entity: Entity): string {
  return `${entity.kind}: ${entity.metadata.name}`;
}
EOF
cat > packages/app/src/label.test.ts <<'EOF'
import assert from 'node:assert/strict';
import { test } from 'node:test';
import { label } from './label.ts';

test('the label joins kind and name', () => {
  assert.equal(label({ kind: 'Component', metadata: { name: 'scout' } }), 'Component: scout');
});
EOF

cat > .githooks/pre-commit <<'EOF'
#!/usr/bin/env bash
# Runs before every commit. A non-zero exit code stops the commit.
set -e
cd "$(git rev-parse --show-toplevel)"
echo "no checks yet"
EOF

sudo mkdir -p /var/lib/portal-lab
sudo sh -c 'cd /opt/portal && sha256sum $(find packages -name "*.test.ts" | sort) > /var/lib/portal-lab/tests.sha256'
sudo git config --system --add safe.directory /opt/portal
yarn install
git init -q
git add -A
git -c user.name=portal -c user.email=portal@example.com commit -q -m "initial portal workspace"

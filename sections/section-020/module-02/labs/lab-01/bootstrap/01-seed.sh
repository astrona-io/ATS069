#!/usr/bin/env bash
# Seeds the simplified portal workspace with one backend plugin and one frontend plugin in /opt/portal.
# The shape follows a Backstage project (plugins/ folder, dev/ entry points, backend.add wiring);
# it is not a generated Backstage app and does not use the Backstage packages.
set -euo pipefail
cd /opt/portal
rm -rf ./* ./.git ./.gitignore ./.yarnrc.yml 2>/dev/null || true
mkdir -p packages/app/src packages/backend/src plugins/hello/src plugins/hello/dev plugins/hello-backend/src plugins/hello-backend/dev scripts

cat > package.json <<'EOF'
{
  "name": "portal",
  "version": "1.0.0",
  "private": true,
  "packageManager": "yarn@4.9.2",
  "workspaces": ["packages/*"],
  "scripts": {
    "start": "node --watch --experimental-strip-types packages/backend/src/index.ts",
    "new": "node scripts/new-plugin.mjs",
    "tsc": "tsc --noEmit",
    "test": "node --experimental-strip-types --test \"packages/**/*.test.ts\" \"plugins/**/*.test.ts\""
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
  "include": ["packages/*/src", "plugins/*/src", "plugins/*/dev"]
}
EOF
cat > .gitignore <<'EOF'
node_modules/
.yarn/
dist/
EOF

cat > packages/backend/package.json <<'EOF'
{
  "name": "@portal/backend",
  "version": "1.0.0",
  "private": true
}
EOF
cat > packages/app/package.json <<'EOF'
{
  "name": "@portal/app",
  "version": "1.0.0",
  "private": true,
  "dependencies": {
    "@internal/plugin-hello": "workspace:^"
  }
}
EOF
cat > packages/backend/src/createBackend.ts <<'EOF'
import { createServer } from 'node:http';

export interface BackendPlugin {
  id: string;
  handle(path: string): { status: number; body: unknown } | undefined;
}

// A small stand-in for the Backstage backend: each plugin owns the routes under /api/<plugin id>.
export function createBackend() {
  const plugins: BackendPlugin[] = [];
  return {
    add(plugin: BackendPlugin) {
      plugins.push(plugin);
    },
    start(port: number) {
      const server = createServer((request, response) => {
        const url = request.url ?? '/';
        for (const plugin of plugins) {
          const prefix = `/api/${plugin.id}`;
          if (url === prefix || url.startsWith(`${prefix}/`)) {
            const result = plugin.handle(url.slice(prefix.length) || '/');
            if (result) {
              response.writeHead(result.status, { 'content-type': 'application/json' });
              response.end(JSON.stringify(result.body));
              return;
            }
          }
        }
        response.writeHead(404);
        response.end();
      });
      server.listen(port, () => {
        console.log(`portal backend listening on ${port}`);
      });
      return server;
    },
  };
}
EOF
cat > packages/backend/src/index.ts <<'EOF'
import { createBackend } from './createBackend.ts';
import { helloBackendPlugin } from '../../../plugins/hello-backend/src/index.ts';

const backend = createBackend();
backend.start(Number(process.env.PORTAL_PORT ?? '7007'));
EOF

cat > plugins/hello-backend/package.json <<'EOF'
{
  "name": "@internal/plugin-hello-backend",
  "version": "0.1.0",
  "private": true,
  "scripts": {
    "start": "node --watch --experimental-strip-types dev/index.ts"
  }
}
EOF
cat > plugins/hello-backend/src/plugin.ts <<'EOF'
import type { BackendPlugin } from '../../../packages/backend/src/createBackend.ts';

export const helloBackendPlugin: BackendPlugin = {
  id: 'hello-backend',
  handle(path) {
    if (path === '/greeting') {
      return { status: 200, body: { greeting: 'Hello from the hello plugin' } };
    }
    return undefined;
  },
};
EOF
cat > plugins/hello-backend/src/index.ts <<'EOF'
export { helloBackendPlugin } from './plugin.ts';
EOF
cat > plugins/hello-backend/src/plugin.test.ts <<'EOF'
import assert from 'node:assert/strict';
import { test } from 'node:test';
import { helloBackendPlugin } from './plugin.ts';

test('the plugin id is hello, so its routes live under /api/hello', () => {
  assert.equal(helloBackendPlugin.id, 'hello');
});

test('the greeting route answers with status 200', () => {
  assert.equal(helloBackendPlugin.handle('/greeting')?.status, 200);
});

test('an unknown route is not handled', () => {
  assert.equal(helloBackendPlugin.handle('/other'), undefined);
});
EOF
cat > plugins/hello-backend/dev/index.ts <<'EOF'
import { createBackend } from '../../../packages/backend/src/createBackend.ts';
import { helloBackendPlugin } from '../src/index.ts';

// Standalone development entry: only this plugin runs, on its own port.
const backend = createBackend();
backend.add(helloBackendPlugin);
backend.start(Number(process.env.PLUGIN_DEV_PORT ?? '7008'));
EOF

cat > plugins/hello/package.json <<'EOF'
{
  "name": "@internal/plugin-hello",
  "version": "0.1.0",
  "private": true,
  "scripts": {
    "start": "node --watch --experimental-strip-types dev/index.ts"
  }
}
EOF
cat > plugins/hello/src/plugin.ts <<'EOF'
export interface FrontendPlugin {
  id: string;
  routePath: string;
  render(data: { greeting?: string } | undefined): string;
}

export const helloPlugin: FrontendPlugin = {
  id: 'hello',
  routePath: '/hello',
  render(data) {
    return data?.greeting ? `Greeting: ${data.greeting}` : 'The greeting could not be loaded';
  },
};
EOF
cat > plugins/hello/src/index.ts <<'EOF'
export { helloPlugin } from './plugin.ts';
export type { FrontendPlugin } from './plugin.ts';
EOF
cat > plugins/hello/src/plugin.test.ts <<'EOF'
import assert from 'node:assert/strict';
import { test } from 'node:test';
import { helloPlugin } from './plugin.ts';

test('the page shows the greeting when data arrives', () => {
  assert.equal(helloPlugin.render({ greeting: 'Hi' }), 'Greeting: Hi');
});

test('the page shows an error text when the request failed', () => {
  assert.equal(helloPlugin.render(undefined), 'The greeting could not be loaded');
});
EOF
cat > plugins/hello/dev/index.ts <<'EOF'
import { helloPlugin } from '../src/index.ts';

// Standalone development entry: renders the plugin page with sample data, no app and no backend needed.
console.log(helloPlugin.render({ greeting: 'sample data from dev/index.ts' }));
EOF
cat > packages/app/src/plugins.ts <<'EOF'
import { helloPlugin } from '../../../plugins/hello/src/index.ts';

export const installedPlugins = [helloPlugin];
EOF
cat > packages/app/src/index.ts <<'EOF'
import { installedPlugins } from './plugins.ts';

const backendUrl = process.env.BACKEND_URL ?? 'http://127.0.0.1:7007';

for (const plugin of installedPlugins) {
  const response = await fetch(`${backendUrl}/api/${plugin.id}/greeting`).catch(() => undefined);
  const data = response?.ok ? ((await response.json()) as { greeting?: string }) : undefined;
  console.log(`${plugin.routePath}: ${plugin.render(data)}`);
}
EOF

cat > scripts/new-plugin.mjs <<'EOF'
// Stand-in for `yarn new`. Usage: yarn new <id>   creates plugins/<id>-backend with a plugin, an index and a test.
import { mkdirSync, writeFileSync } from 'node:fs';

const id = process.argv[2];
if (!id || !/^[a-z][a-z0-9-]*$/.test(id)) {
  console.error('usage: yarn new <plugin-id>   (lowercase letters, digits and dashes)');
  process.exit(1);
}
const dir = `plugins/${id}-backend`;
mkdirSync(`${dir}/src`, { recursive: true });
writeFileSync(
  `${dir}/package.json`,
  JSON.stringify({ name: `@internal/plugin-${id}-backend`, version: '0.1.0', private: true }, null, 2) + '\n',
);
writeFileSync(
  `${dir}/src/plugin.ts`,
  `import type { BackendPlugin } from '../../../packages/backend/src/createBackend.ts';\n\nexport const ${id.replace(/-./g, m => m[1].toUpperCase())}BackendPlugin: BackendPlugin = {\n  id: '${id}',\n  handle() {\n    return undefined;\n  },\n};\n`,
);
console.log(`created ${dir}`);
EOF

sudo mkdir -p /var/lib/portal-lab
sudo sh -c 'cd /opt/portal && sha256sum $(find plugins packages -name "*.test.ts" | sort) > /var/lib/portal-lab/tests.sha256'
sudo git config --system --add safe.directory /opt/portal
yarn install
git init -q
git add -A
git -c user.name=portal -c user.email=portal@example.com commit -q -m "initial portal workspace"

#!/usr/bin/env bash
# Reference solution, applied by astrona test only.
set -euo pipefail
cd /opt/portal
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
printf 'node_modules\ndist-types\n' > .gitignore
sed -i 's/summarize(record)/summarize(record: DeploymentRecord): string/' plugins/deploy-backend/src/index.ts
find packages plugins -path '*/src/*' \( -name '*.js' -o -name '*.tsbuildinfo' \) -delete

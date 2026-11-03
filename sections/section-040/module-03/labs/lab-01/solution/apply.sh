#!/usr/bin/env bash
# Applies the reference solution. Run only by `astrona test`.
set -euo pipefail
cd /opt/portal
node -e "
const fs = require('fs');
const edit = (file, change) => { const p = JSON.parse(fs.readFileSync(file, 'utf8')); change(p); fs.writeFileSync(file, JSON.stringify(p, null, 2) + '\n'); };
edit('packages/plugin/package.json', (p) => { p.peerDependencies = { '@internal/shared': '^1.0.0' }; p.devDependencies = { '@internal/shared': 'workspace:^' }; });
"
grep -v '^npmAuthToken: "npm_FAKE' .yarnrc.yml > .yarnrc.yml.new
mv .yarnrc.yml.new .yarnrc.yml
cat >> .yarnrc.yml <<'EOT'
npmScopes:
  internal:
    npmRegistryServer: "https://npm.internal.example.com"
    npmAlwaysAuth: true
    npmAuthToken: "${NPM_TOKEN:-}"
EOT
yarn install
printf 'backend\n@internal/plugin\n' > answers.txt

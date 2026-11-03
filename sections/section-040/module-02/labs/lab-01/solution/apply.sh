#!/usr/bin/env bash
# Applies the reference solution. Run only by `astrona test`.
set -euo pipefail
cd /opt/portal
node -e "
const fs = require('fs');
const edit = (file, change) => { const p = JSON.parse(fs.readFileSync(file, 'utf8')); change(p); fs.writeFileSync(file, JSON.stringify(p, null, 2) + '\n'); };
edit('package.json', (p) => { delete p.dependencies; p.scripts = { 'lint:all': 'yarn workspaces foreach -A run lint' }; });
edit('packages/backend/package.json', (p) => { p.dependencies.semver = '^7.6.0'; });
"
yarn install

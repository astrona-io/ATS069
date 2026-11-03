#!/usr/bin/env bash
# Applies the reference solution. Run only by `astrona test`.
set -euo pipefail
cd /opt/portal
node -e "
const fs = require('fs');
const edit = (file, change) => { const p = JSON.parse(fs.readFileSync(file, 'utf8')); change(p); fs.writeFileSync(file, JSON.stringify(p, null, 2) + '\n'); };
edit('packages/app/package.json', (p) => { p.dependencies['@internal/shared'] = 'workspace:^'; });
edit('packages/backend/package.json', (p) => { p.dependencies = { '@internal/shared': 'workspace:^' }; });
"
yarn install

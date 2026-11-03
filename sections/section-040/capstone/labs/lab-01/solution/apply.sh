#!/usr/bin/env bash
# Applies the reference solution. Run only by `astrona test`.
set -euo pipefail
cd /opt/portal
rm -f package-lock.json
sed -i 's/^yarn install$/yarn install --immutable/' ci/install.sh
node -e "
const fs = require('fs');
const edit = (file, change) => { const p = JSON.parse(fs.readFileSync(file, 'utf8')); change(p); fs.writeFileSync(file, JSON.stringify(p, null, 2) + '\n'); };
edit('packages/backend/package.json', (p) => { p.dependencies.semver = '^7.6.0'; });
edit('package.json', (p) => { p.resolutions = { 'semver@^5.7.2': '^7.6.0' }; });
"
yarn install

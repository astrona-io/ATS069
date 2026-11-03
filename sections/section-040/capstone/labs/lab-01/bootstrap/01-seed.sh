#!/usr/bin/env bash
# Seeds /opt/portal: a Yarn 4 workspace with a failing CI install script.
# Faults: ci/install.sh uses a plain install, backend imports semver without declaring it,
# legacy-tool pulls in semver 5.x next to semver 7.x, and a stray package-lock.json exists.
# Needs internet access for the semver packages.
set -eu

mkdir -p /opt/portal/.yarn/releases
curl -fsSL https://repo.yarnpkg.com/4.4.1/packages/yarnpkg-cli/bin/yarn.js -o /opt/portal/.yarn/releases/yarn-4.4.1.cjs
sudo tee /usr/local/bin/yarn >/dev/null <<'EOF'
#!/usr/bin/env bash
exec node /opt/portal/.yarn/releases/yarn-4.4.1.cjs "$@"
EOF
sudo chmod +x /usr/local/bin/yarn

cd /opt/portal
cat > package.json <<'EOF'
{
  "name": "root",
  "version": "1.0.0",
  "private": true,
  "workspaces": ["packages/*"],
  "packageManager": "yarn@4.4.1"
}
EOF
cat > .yarnrc.yml <<'EOF'
nodeLinker: node-modules
enableGlobalCache: false
yarnPath: .yarn/releases/yarn-4.4.1.cjs
EOF
printf 'node_modules\n' > .gitignore

mkdir -p packages/app/src packages/backend/src packages/shared/src packages/legacy-tool/src ci
cat > packages/shared/package.json <<'EOF'
{
  "name": "@internal/shared",
  "version": "1.0.0",
  "main": "src/index.js",
  "dependencies": { "semver": "^7.6.0" }
}
EOF
cat > packages/shared/src/index.js <<'EOF'
const semver = require('semver');
module.exports = { isValid: (value) => semver.valid(value) !== null };
EOF
cat > packages/legacy-tool/package.json <<'EOF'
{
  "name": "legacy-tool",
  "version": "1.0.0",
  "main": "src/index.js",
  "dependencies": { "semver": "^5.7.2" }
}
EOF
cat > packages/legacy-tool/src/index.js <<'EOF'
const semver = require('semver');
module.exports = { check: (value) => semver.valid(value) };
EOF
cat > packages/app/package.json <<'EOF'
{
  "name": "app",
  "version": "0.0.0",
  "private": true,
  "dependencies": {
    "@internal/shared": "workspace:^",
    "legacy-tool": "workspace:^"
  }
}
EOF
cat > packages/app/src/index.js <<'EOF'
console.log(require('legacy-tool').check('1.2.3'));
EOF
# The backend imports semver but does not declare it.
cat > packages/backend/package.json <<'EOF'
{
  "name": "backend",
  "version": "0.0.0",
  "private": true,
  "scripts": { "start": "node src/index.js" },
  "dependencies": { "@internal/shared": "workspace:^" }
}
EOF
cat > packages/backend/src/index.js <<'EOF'
const semver = require('semver');
console.log(semver.inc('1.2.3', 'minor'));
EOF
cat > ci/install.sh <<'EOF'
#!/usr/bin/env bash
# CI install step for the portal workspace.
set -eu
cd "$(dirname "$0")/.."
yarn install
EOF
chmod +x ci/install.sh

yarn install

# A developer ran npm in the Yarn project once and committed the result.
cat > package-lock.json <<'EOF'
{
  "name": "root",
  "version": "1.0.0",
  "lockfileVersion": 3,
  "requires": true,
  "packages": {}
}
EOF
sudo chmod -R a+rwX /opt/portal

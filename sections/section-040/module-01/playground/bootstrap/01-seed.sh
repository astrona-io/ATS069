#!/usr/bin/env bash
# Seeds the playground: a Yarn 4 workspace at /opt/portal and an npm project at /opt/npm-demo.
# The project has the shape of a Backstage workspace but is a simplified fixture, not a generated app.
set -eu

# Install Yarn 4.4.1 as a committed release file and a `yarn` command that runs it.
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
  "packageManager": "yarn@4.4.1",
  "scripts": {
    "start": "yarn workspace backend start",
    "tsc": "echo tsc is not part of this fixture"
  }
}
EOF
cat > .yarnrc.yml <<'EOF'
nodeLinker: node-modules
enableGlobalCache: false
yarnPath: .yarn/releases/yarn-4.4.1.cjs
EOF
printf 'node_modules\n' > .gitignore

mkdir -p packages/app/src packages/backend/src packages/shared/src
cat > packages/shared/package.json <<'EOF'
{
  "name": "@internal/shared",
  "version": "1.0.0",
  "main": "src/index.js",
  "dependencies": {
    "semver": "^7.6.0"
  }
}
EOF
cat > packages/shared/src/index.js <<'EOF'
const semver = require('semver');
module.exports = { isValidVersion: (value) => semver.valid(value) !== null };
EOF
cat > packages/app/package.json <<'EOF'
{
  "name": "app",
  "version": "0.0.0",
  "private": true,
  "dependencies": {
    "@internal/shared": "workspace:^"
  }
}
EOF
cat > packages/app/src/index.js <<'EOF'
const { isValidVersion } = require('@internal/shared');
console.log('app: 1.2.3 is a valid version?', isValidVersion('1.2.3'));
EOF
# The backend imports semver but does not declare it (a hidden dependency on purpose).
cat > packages/backend/package.json <<'EOF'
{
  "name": "backend",
  "version": "0.0.0",
  "private": true,
  "scripts": { "start": "node src/index.js" },
  "dependencies": {
    "@internal/shared": "workspace:^"
  }
}
EOF
cat > packages/backend/src/index.js <<'EOF'
const semver = require('semver');
console.log('backend: next minor after 1.2.3 is', semver.inc('1.2.3', 'minor'));
EOF

yarn install

mkdir -p /opt/npm-demo
cd /opt/npm-demo
cat > package.json <<'EOF'
{
  "name": "npm-demo",
  "version": "1.0.0",
  "private": true,
  "dependencies": { "semver": "^7.6.0" }
}
EOF
npm install
sudo chmod -R a+rwX /opt/portal /opt/npm-demo

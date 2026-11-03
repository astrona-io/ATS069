#!/usr/bin/env bash
# Seeds /opt/portal: a Yarn 4 workspace whose install is not reproducible.
# Faults: app asks for @internal/shared ^2.0.0 (no such local version), backend imports it without declaring it,
# and yarn.lock was written before those changes. All packages are local, so no registry package is needed.
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

mkdir -p packages/app/src packages/backend/src packages/shared/src
cat > packages/shared/package.json <<'EOF'
{
  "name": "@internal/shared",
  "version": "1.0.0",
  "main": "src/index.js"
}
EOF
cat > packages/shared/src/index.js <<'EOF'
module.exports = { greeting: (name) => 'hello ' + name };
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
console.log(require('@internal/shared').greeting('app'));
EOF
cat > packages/backend/package.json <<'EOF'
{
  "name": "backend",
  "version": "0.0.0",
  "private": true,
  "scripts": { "start": "node src/index.js" }
}
EOF
cat > packages/backend/src/index.js <<'EOF'
console.log(require('@internal/shared').greeting('backend'));
EOF

# Write the lockfile for the good state, then introduce the faults.
yarn install
cat > packages/app/package.json <<'EOF'
{
  "name": "app",
  "version": "0.0.0",
  "private": true,
  "dependencies": {
    "@internal/shared": "^2.0.0"
  }
}
EOF
sudo chmod -R a+rwX /opt/portal

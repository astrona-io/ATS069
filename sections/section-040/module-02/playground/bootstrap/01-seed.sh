#!/usr/bin/env bash
# Seeds /opt/portal for the Yarn workflow playground: a Yarn 4 workspace with lint and build scripts and a backstage.json file.
set -eu

mkdir -p /opt/portal/.yarn/releases
curl -fsSL https://repo.yarnpkg.com/4.4.1/packages/yarnpkg-cli/bin/yarn.js -o /opt/portal/.yarn/releases/yarn-4.4.1.cjs
sudo tee /usr/local/bin/yarn >/dev/null <<'EOF'
#!/usr/bin/env bash
exec node /opt/portal/.yarn/releases/yarn-4.4.1.cjs "$@"
EOF
sudo chmod +x /usr/local/bin/yarn

cd /opt/portal
cat > .yarnrc.yml <<'EOF'
nodeLinker: node-modules
enableGlobalCache: false
yarnPath: .yarn/releases/yarn-4.4.1.cjs
EOF
printf 'node_modules\n' > .gitignore
echo '{ "version": "1.30.0" }' > backstage.json
mkdir -p packages/app/src packages/backend/src packages/shared/src
cat > packages/shared/package.json <<'EOF'
{
  "name": "@internal/shared",
  "version": "1.0.0",
  "main": "src/index.js",
  "scripts": { "lint": "echo linting @internal/shared", "build": "echo building @internal/shared" }
}
EOF
cat > packages/shared/src/index.js <<'EOF'
module.exports = { greeting: (name) => 'hello ' + name };
EOF

cat > package.json <<'EOT'
{
  "name": "root",
  "version": "1.0.0",
  "private": true,
  "workspaces": ["packages/*"],
  "packageManager": "yarn@4.4.1",
  "scripts": {
    "lint:all": "yarn workspaces foreach -A run lint",
    "build:all": "yarn workspaces foreach -A --topological run build"
  }
}
EOT
cat > packages/app/package.json <<'EOT'
{
  "name": "app",
  "version": "0.0.0",
  "private": true,
  "scripts": { "lint": "echo linting app", "build": "echo building app" },
  "dependencies": { "@internal/shared": "workspace:^" }
}
EOT
cat > packages/app/src/index.js <<'EOT'
console.log(require('@internal/shared').greeting('app'));
EOT
cat > packages/backend/package.json <<'EOT'
{
  "name": "backend",
  "version": "0.0.0",
  "private": true,
  "scripts": { "start": "node src/index.js", "lint": "echo linting backend", "build": "echo building backend" },
  "dependencies": { "@internal/shared": "workspace:^" }
}
EOT
cat > packages/backend/src/index.js <<'EOT'
console.log(require('@internal/shared').greeting('backend'));
EOT
yarn install
sudo chmod -R a+rwX /opt/portal

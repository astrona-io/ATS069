#!/usr/bin/env bash
# Seeds /opt/portal for the peer dependency and registry lab. Faults: the plugin has no peerDependencies, and .yarnrc.yml holds a literal token and no scope registry.
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

mkdir -p packages/plugin/src
cat > package.json <<'EOT'
{
  "name": "root",
  "version": "1.0.0",
  "private": true,
  "workspaces": ["packages/*"],
  "packageManager": "yarn@4.4.1"
}
EOT
cat > packages/plugin/package.json <<'EOT'
{
  "name": "@internal/plugin",
  "version": "0.1.0",
  "main": "src/index.js"
}
EOT
cat > packages/plugin/src/index.js <<'EOT'
module.exports = { render: () => require('@internal/shared').greeting('plugin') };
EOT
cat > packages/app/package.json <<'EOT'
{
  "name": "app",
  "version": "0.0.0",
  "private": true,
  "dependencies": { "@internal/plugin": "workspace:^", "@internal/shared": "workspace:^" }
}
EOT
cat > packages/app/src/index.js <<'EOT'
console.log(require('@internal/plugin').render());
EOT
cat > packages/backend/package.json <<'EOT'
{
  "name": "backend",
  "version": "0.0.0",
  "private": true,
  "dependencies": { "@internal/shared": "workspace:^"
  }
}
EOT
cat > packages/backend/src/index.js <<'EOT'
console.log(require('@internal/shared').greeting('backend'));
EOT
# The fault: a literal token sits in the committed file.
cat >> .yarnrc.yml <<'EOT'
npmAuthToken: "npm_FAKE0000000000000000000000000000TOKEN"
EOT
yarn install
sudo chmod -R a+rwX /opt/portal

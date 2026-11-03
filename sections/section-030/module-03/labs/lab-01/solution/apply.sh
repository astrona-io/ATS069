#!/usr/bin/env bash
# Reference solution, applied by astrona test only.
set -euo pipefail
cd /opt/portal
node -e '
const fs = require("fs");
const edit = (file, change) => { const m = JSON.parse(fs.readFileSync(file, "utf8")); change(m); fs.writeFileSync(file, JSON.stringify(m, null, 2) + "\n"); };
edit("plugins/deploy-backend/package.json", m => { m.backstage = { role: "backend-plugin" }; });
edit("plugins/deploy-common/package.json", m => { m.files = ["dist"]; });
edit("package.json", m => { m.scripts["build:all"] = "npm run build --workspaces --if-present"; });
'
cat > plugins/deploy-backend/src/index.ts <<'EOF'
export function describeBackend(name: string): string {
  const length: number = name.length;
  return `${name} (${length})`;
}
EOF

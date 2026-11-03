#!/usr/bin/env bash
# Check: each package declares the expected backstage.role.
set -uo pipefail
cd /opt/portal || { echo "FAIL: /opt/portal is missing"; exit 1; }
command -v node >/dev/null || { echo "FAIL: node is not installed"; exit 1; }
node -e '
const fs = require("fs");
const expected = {
  "packages/app": "frontend",
  "packages/backend": "backend",
  "plugins/deploy-common": "common-library",
  "plugins/deploy-backend": "backend-plugin"
};
let fail = 0;
for (const [dir, role] of Object.entries(expected)) {
  const manifest = JSON.parse(fs.readFileSync(dir + "/package.json", "utf8"));
  const actual = manifest.backstage && manifest.backstage.role;
  if (actual !== role) { console.log("FAIL: " + dir + " has role " + actual + ", expected " + role); fail = 1; }
}
if (!fail) console.log("PASS: every package has the expected role");
process.exit(fail);
'

#!/usr/bin/env bash
# Check: every package lists dist in its files field.
set -uo pipefail
cd /opt/portal || { echo "FAIL: /opt/portal is missing"; exit 1; }
command -v node >/dev/null || { echo "FAIL: node is not installed"; exit 1; }
node -e '
const fs = require("fs");
let fail = 0;
for (const dir of ["packages/app", "packages/backend", "plugins/deploy-common", "plugins/deploy-backend"]) {
  const manifest = JSON.parse(fs.readFileSync(dir + "/package.json", "utf8"));
  if (!Array.isArray(manifest.files) || !manifest.files.includes("dist")) { console.log("FAIL: " + dir + " does not list dist in files"); fail = 1; }
}
if (!fail) console.log("PASS: every package publishes dist");
process.exit(fail);
'

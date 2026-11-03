#!/usr/bin/env bash
# Check: the root tsconfig.json extends the shared base and does not switch strict off.
set -uo pipefail
cd /opt/portal || { echo "FAIL: /opt/portal is missing"; exit 1; }
command -v tsc >/dev/null || { echo "FAIL: tsc is not installed"; exit 1; }
node -e '
const fs = require("fs");
const config = JSON.parse(fs.readFileSync("tsconfig.json", "utf8"));
const extendsValue = String(config.extends || "");
if (!/tsconfig\.base\.json$/.test(extendsValue)) { console.log("FAIL: tsconfig.json does not extend ./tsconfig.base.json"); process.exit(1); }
const own = config.compilerOptions || {};
if (own.strict === false) { console.log("FAIL: tsconfig.json sets strict to false"); process.exit(1); }
console.log("PASS: tsconfig.json extends the shared base");
'

#!/usr/bin/env bash
# Reference solution for the lab: used only by astrona test.
set -eu
cd /opt/scaffold

node -e '
const fs = require("fs");
const p = JSON.parse(fs.readFileSync("package.json", "utf8"));
p.workspaces = { packages: ["packages/*", "plugins/*"] };
p.engines.node = "20 || 22";
p.packageManager = "yarn@4.4.1";
fs.writeFileSync("package.json", JSON.stringify(p, null, 2) + "\n");

const f = "plugins/status-backend/package.json";
const b = JSON.parse(fs.readFileSync(f, "utf8"));
b.backstage = { role: "backend-plugin" };
fs.writeFileSync(f, JSON.stringify(b, null, 2) + "\n");
'

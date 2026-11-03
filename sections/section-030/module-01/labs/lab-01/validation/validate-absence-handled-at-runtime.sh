#!/usr/bin/env bash
# Check: compile the project to a temporary folder and call describeOwner with and without an owner.
set -uo pipefail
cd /opt/portal || { echo "FAIL: /opt/portal is missing"; exit 1; }
command -v tsc >/dev/null || { echo "FAIL: tsc is not installed"; exit 1; }
out="$(mktemp -d)"
trap 'rm -rf "$out"' EXIT
tsc -p tsconfig.json --noEmit false --outDir "$out" >/dev/null 2>&1
file="$(find "$out" -path '*deploy-backend/src/index.js' | head -n 1)"
if [ -z "$file" ]; then
  echo "FAIL: the plugin could not be compiled"
  exit 1
fi
result="$(node -e "
const m = require(process.argv[1]);
const a = m.describeOwner({ id: 'x', status: 'running' });
const b = m.describeOwner({ id: 'x', status: 'running', owner: 'ada' });
console.log(a + '|' + b);
" "$file" 2>&1)"
if [ "$result" = "unassigned|ADA" ]; then
  echo "PASS: describeOwner returns unassigned without an owner and ADA for ada"
  exit 0
fi
echo "FAIL: describeOwner returned '$result', expected 'unassigned|ADA'"
exit 1

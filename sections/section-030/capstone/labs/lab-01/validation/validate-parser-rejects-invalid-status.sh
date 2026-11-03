#!/usr/bin/env bash
# Check: the compiled parseDeployment accepts a valid record and throws for status done.
set -uo pipefail
cd /opt/portal || { echo "FAIL: /opt/portal is missing"; exit 1; }
file=plugins/deploy-common/dist/index.js
tsc --build >/dev/null 2>&1
if [ ! -f "$file" ]; then
  echo "FAIL: $file does not exist"
  exit 1
fi
result="$(node -e "
const m = require(process.argv[1]);
if (typeof m.parseDeployment !== 'function') { console.log('missing'); process.exit(0); }
const ok = m.parseDeployment({ id: 'a', status: 'running', owner: 'ada' });
let thrown = false;
try { m.parseDeployment({ id: 'a', status: 'done' }); } catch (e) { thrown = e instanceof Error; }
let thrownNull = false;
try { m.parseDeployment(null); } catch (e) { thrownNull = e instanceof Error; }
console.log(ok.id + '|' + ok.status + '|' + thrown + '|' + thrownNull);
" "/opt/portal/$file" 2>&1)"
if [ "$result" = "a|running|true|true" ]; then
  echo "PASS: parseDeployment accepts a valid record and throws for an invalid status and for null"
  exit 0
fi
echo "FAIL: parseDeployment returned '$result', expected 'a|running|true|true'"
exit 1

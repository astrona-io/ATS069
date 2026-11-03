#!/usr/bin/env bash
set -u

cd /opt/portal 2>/dev/null || { echo "FAIL: /opt/portal does not exist"; exit 1; }

if ! node -e "
const { loadConfig, requireKey } = require(\"./scripts/config.js\");
const cfg = loadConfig([\"app-config.yaml\"]);
for (const key of [\"backend.baseUrl\", \"backend.listen.port\", \"app.baseUrl\"]) requireKey(cfg, key);
if (cfg.backend.listen.port !== 7007) { throw new Error(\"backend.listen.port must be 7007\"); }
" 2>/tmp/lab-config.log; then
  echo "FAIL: $(cat /tmp/lab-config.log | grep -m1 Error)"
  exit 1
fi

echo "PASS: app-config.yaml defines backend.baseUrl, backend.listen.port (7007) and app.baseUrl"
exit 0

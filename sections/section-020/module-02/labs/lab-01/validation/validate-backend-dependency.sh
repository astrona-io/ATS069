#!/usr/bin/env bash
set -u
cd /opt/portal || { echo "FAIL: /opt/portal is missing"; exit 1; }
if ! python3 - <<'PY'
import json, sys
deps = json.load(open("packages/backend/package.json")).get("dependencies", {})
sys.exit(0 if deps.get("@internal/plugin-hello-backend", "").startswith("workspace:") else 1)
PY
then
  echo "FAIL: packages/backend/package.json does not depend on @internal/plugin-hello-backend with a workspace: version"
  exit 1
fi
echo "PASS: the backend declares the plugin dependency"

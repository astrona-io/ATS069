#!/usr/bin/env bash
set -u
cd /opt/portal || { echo "FAIL: /opt/portal is missing"; exit 1; }
python3 - <<'PY'
import sys
import yaml

shared = yaml.safe_load(open("app-config.yaml")) or {}
try:
    local = yaml.safe_load(open("app-config.local.yaml")) or {}
except FileNotFoundError:
    print("FAIL: app-config.local.yaml was removed")
    sys.exit(1)

enabled = shared.get("catalog", {}).get("ownerWarning", {}).get("enabled")
if enabled is not True:
    print("FAIL: app-config.yaml must set catalog.ownerWarning.enabled: true")
    sys.exit(1)
if "catalog" in local:
    print("FAIL: app-config.local.yaml must not hold the catalog block any more")
    sys.exit(1)
if local.get("backend", {}).get("listen", {}).get("port") != 7008:
    print("FAIL: the local override backend.listen.port: 7008 must stay")
    sys.exit(1)
print("PASS: the shared key is in app-config.yaml and the local override keeps only local values")
PY

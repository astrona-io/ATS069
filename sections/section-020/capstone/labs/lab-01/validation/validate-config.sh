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

if shared.get("catalog", {}).get("deploymentStatus", {}).get("enabled") is not True:
    print("FAIL: app-config.yaml must set catalog.deploymentStatus.enabled: true")
    sys.exit(1)
if shared.get("catalog", {}).get("ownerWarning", {}).get("enabled") is not True:
    print("FAIL: the existing catalog.ownerWarning.enabled key was lost")
    sys.exit(1)
if "catalog" in local:
    print("FAIL: app-config.local.yaml must not hold the catalog block any more")
    sys.exit(1)
if local.get("backend", {}).get("listen", {}).get("port") != 7008:
    print("FAIL: the local override backend.listen.port: 7008 must stay")
    sys.exit(1)
password = shared.get("backend", {}).get("database", {}).get("connection", {}).get("password")
if password != "${BACKEND_DB_PASSWORD}":
    print("FAIL: the password must be ${BACKEND_DB_PASSWORD}, found: %r" % (password,))
    sys.exit(1)
PY
status=$?
[ "$status" -eq 0 ] || exit 1
if ! git check-ignore -q app-config.local.yaml; then
  echo "FAIL: Git does not ignore app-config.local.yaml"
  exit 1
fi
echo "PASS: shared key, environment password and ignored local override are correct"

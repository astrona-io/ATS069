#!/usr/bin/env bash
set -u
cd /opt/portal || { echo "FAIL: /opt/portal is missing"; exit 1; }
if grep -q "hunter2" app-config.yaml app-config.production.yaml; then
  echo "FAIL: the plain-text password is still in a committed config file"
  exit 1
fi
python3 - <<'PY'
import sys
import yaml

shared = yaml.safe_load(open("app-config.yaml")) or {}
password = shared.get("backend", {}).get("database", {}).get("connection", {}).get("password")
if password != "${BACKEND_DB_PASSWORD}":
    print("FAIL: backend.database.connection.password must be ${BACKEND_DB_PASSWORD}, found: %r" % (password,))
    sys.exit(1)
print("PASS: the password comes from BACKEND_DB_PASSWORD")
PY

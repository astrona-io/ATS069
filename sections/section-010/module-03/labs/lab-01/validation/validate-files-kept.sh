#!/usr/bin/env bash
set -u

cd /opt/envcfg 2>/dev/null || { echo "FAIL: /opt/envcfg does not exist"; exit 1; }

for f in app-config.yaml app-config.production.yaml examples/entities.yaml tools/check-config.py; do
  if [ ! -f "$f" ]; then
    echo "FAIL: $f is missing"
    exit 1
  fi
done
if ! grep -q "client: pg" app-config.production.yaml || ! grep -q "client: better-sqlite3" app-config.yaml; then
  echo "FAIL: a database client was changed"
  exit 1
fi
echo "PASS: all files are present and the database clients are unchanged"
exit 0

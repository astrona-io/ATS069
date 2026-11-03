#!/usr/bin/env bash
set -u

cd /opt/scaffold 2>/dev/null || { echo "FAIL: /opt/scaffold does not exist"; exit 1; }

pm=$(node -p "require(\"./package.json\").packageManager" 2>/dev/null)
case "$pm" in
  yarn@4.*) echo "PASS: packageManager is $pm"; exit 0 ;;
  *) echo "FAIL: packageManager is \"$pm\", expected yarn@4.x"; exit 1 ;;
esac

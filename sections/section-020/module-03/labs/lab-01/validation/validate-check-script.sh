#!/usr/bin/env bash
set -u
cd /opt/portal || { echo "FAIL: /opt/portal is missing"; exit 1; }
script=$(python3 -c 'import json; print(json.load(open("package.json")).get("scripts", {}).get("check", ""))')
for step in "yarn tsc" "yarn lint" "yarn format:check" "yarn test"; do
  case "$script" in
    *"$step"*) ;;
    *) echo "FAIL: the check script does not run '$step'"; exit 1 ;;
  esac
done
if ! yarn check >/dev/null 2>&1; then
  echo "FAIL: yarn check does not pass"
  exit 1
fi
echo "PASS: yarn check runs all four checks and passes"

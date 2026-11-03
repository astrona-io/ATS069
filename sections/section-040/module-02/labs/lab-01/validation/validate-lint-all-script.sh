#!/usr/bin/env bash
set -u
cd /opt/portal || { echo "FAIL: /opt/portal is missing"; exit 1; }
script=$(node -p "((require('./package.json').scripts)||{})['lint:all']||''" 2>/dev/null)
case "$script" in
  *"workspaces foreach"*) ;;
  *) echo "FAIL: the root script lint:all is missing or does not use yarn workspaces foreach"; exit 1 ;;
esac
if yarn run lint:all >/tmp/lint-all.log 2>&1; then
  echo "PASS: yarn run lint:all exits with code 0"; exit 0
fi
echo "FAIL: yarn run lint:all fails. Last lines:"
tail -n 5 /tmp/lint-all.log
exit 1

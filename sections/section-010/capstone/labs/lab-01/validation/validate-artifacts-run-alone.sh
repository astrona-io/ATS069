#!/usr/bin/env bash
set -u

start_background() {
  # Run the given command from /opt/portal in its own process group.
  cd /opt/portal || exit 1
  setsid "$@" >/tmp/lab-process.log 2>&1 &
  PROCESS_PID=$!
}

stop_background() {
  kill -- "-${PROCESS_PID}" 2>/dev/null || kill "${PROCESS_PID}" 2>/dev/null || true
}

wait_for_url() {
  # Try the URL once per second for up to 20 seconds.
  for _ in $(seq 1 20); do
    if curl -fsS "$1" 2>/dev/null; then
      return 0
    fi
    sleep 1
  done
  return 1
}
cd /opt/portal
if [ ! -f packages/app/dist/config.json ] || [ ! -f packages/backend/dist/index.js ]; then
  echo "FAIL: run yarn build:all first"
  exit 1
fi

if grep -q 'ghp_example_token' packages/app/dist/config.json; then
  echo "FAIL: dist/config.json of the app contains the GitHub token. Fix the configuration and build again."
  exit 1
fi

start_background node packages/backend/dist/index.js --config app-config.yaml --config app-config.production.yaml
backend=$(wait_for_url http://localhost:7007/healthcheck)
stop_background
if ! echo "$backend" | grep -q '"environment":"production"'; then
  echo "FAIL: the built backend did not report environment production"
  exit 1
fi

start_background node packages/app/dist/server.js
app=$(wait_for_url http://localhost:3000/config.json)
stop_background
if ! echo "$app" | grep -q 'http://localhost:3000'; then
  echo "FAIL: the built app did not serve its config.json for http://localhost:3000"
  exit 1
fi

echo "PASS: both built artifacts run alone and the browser configuration holds no secret"
exit 0

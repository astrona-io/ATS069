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

if [ ! -f /opt/portal/packages/backend/dist/index.js ]; then
  echo "FAIL: packages/backend/dist/index.js does not exist. Build the backend first."
  exit 1
fi

start_background node packages/backend/dist/index.js --config app-config.yaml --config app-config.production.yaml
body=$(wait_for_url http://localhost:7007/healthcheck)
stop_background

if ! echo "$body" | grep -q '"environment":"production"'; then
  echo "FAIL: the built backend did not report environment production"
  echo "Process output: $(head -c 300 /tmp/lab-process.log)"
  exit 1
fi

echo "PASS: the built backend runs alone and reports environment production"
exit 0

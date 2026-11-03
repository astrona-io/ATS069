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
start_background yarn workspace app start
body=$(wait_for_url http://localhost:3000/)
stop_background

if ! echo "$body" | grep -q 'Portal'; then
  echo "FAIL: the app did not answer on http://localhost:3000/"
  echo "Process output: $(head -c 300 /tmp/lab-process.log)"
  exit 1
fi

echo "PASS: the app development server answered on port 3000"
exit 0

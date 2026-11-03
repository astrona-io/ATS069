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
body=$(wait_for_url http://localhost:3000/config.json)
stop_background

if [ -z "$body" ]; then
  echo "FAIL: the app did not serve /config.json on port 3000"
  exit 1
fi
if echo "$body" | grep -q 'ghp_example_token'; then
  echo "FAIL: the GitHub token is in the browser-visible configuration"
  exit 1
fi

cd /opt/portal
if ! node -e '
const { loadConfig } = require("./scripts/config.js");
const cfg = loadConfig(["app-config.yaml"]);
if (!cfg.backend || cfg.backend.githubToken !== "ghp_example_token") process.exit(1);
'; then
  echo "FAIL: backend.githubToken must still hold ghp_example_token"
  exit 1
fi

echo "PASS: the token is not browser-visible and the backend still has it"
exit 0

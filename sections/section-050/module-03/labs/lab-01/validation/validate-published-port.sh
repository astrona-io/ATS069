#!/usr/bin/env bash
# Host port 7007 reaches the backend, which listens on 7100 inside the container.
set -u
body="$(curl -s --max-time 3 http://127.0.0.1:7007/healthcheck || true)"
if echo "$body" | grep -q '"status":"ok"'; then
  echo "PASS: host port 7007 answers the health check"
  exit 0
fi
echo "FAIL: no health check answer on host port 7007. Check the port mapping with docker container ls."
exit 1

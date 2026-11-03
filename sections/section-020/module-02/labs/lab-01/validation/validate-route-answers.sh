#!/usr/bin/env bash
set -u
cd /opt/portal || { echo "FAIL: /opt/portal is missing"; exit 1; }
PORTAL_PORT=17007 node --experimental-strip-types packages/backend/src/index.ts >/tmp/portal-backend.log 2>&1 &
pid=$!
trap 'kill $pid 2>/dev/null' EXIT
status=000
for _ in $(seq 1 20); do
  status=$(curl -s -o /dev/null -w '%{http_code}' http://127.0.0.1:17007/api/hello/greeting || true)
  [ "$status" = "200" ] && break
  sleep 0.5
done
if [ "$status" != "200" ]; then
  echo "FAIL: GET /api/hello/greeting answered $status instead of 200"
  exit 1
fi
echo "PASS: the route answers with status 200"

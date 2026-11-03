#!/usr/bin/env bash
# A container from the image answers the health check on the published port 7007.
set -u
name="lab-grader-check"
cleanup() { docker rm -f "$name" >/dev/null 2>&1 || true; }
trap cleanup EXIT
cleanup
if ! docker image inspect backstage:lab >/dev/null 2>&1; then
  echo "FAIL: image backstage:lab does not exist"
  exit 1
fi
docker run -d --name "$name" -p 17007:7007 backstage:lab >/dev/null 2>&1 || { echo "FAIL: the container did not start"; exit 1; }
for attempt in $(seq 1 20); do
  body="$(curl -s --max-time 2 http://127.0.0.1:17007/healthcheck || true)"
  if echo "$body" | grep -q '"status":"ok"'; then
    echo "PASS: the health check answers through the published port"
    exit 0
  fi
  sleep 1
done
echo "FAIL: no health check answer from the container. Last logs:"
docker logs "$name" 2>&1 | tail -n 5
exit 1

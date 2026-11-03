#!/usr/bin/env bash
# The image backstage:cache exists and a container from it answers the health check.
set -u
name="lab-grader-check"
cleanup() { docker rm -f "$name" >/dev/null 2>&1 || true; }
trap cleanup EXIT
cleanup
if ! docker image inspect backstage:cache >/dev/null 2>&1; then
  echo "FAIL: image backstage:cache does not exist"
  exit 1
fi
docker run -d --name "$name" -p 17007:7007 backstage:cache >/dev/null 2>&1 || { echo "FAIL: the container did not start"; exit 1; }
for attempt in $(seq 1 20); do
  if curl -s --max-time 2 http://127.0.0.1:17007/healthcheck | grep -q '"status":"ok"'; then
    echo "PASS: the image builds and answers the health check"
    exit 0
  fi
  sleep 1
done
echo "FAIL: the container does not answer /healthcheck. Last logs:"
docker logs "$name" 2>&1 | tail -n 5
exit 1

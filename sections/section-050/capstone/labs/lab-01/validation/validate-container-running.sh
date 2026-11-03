#!/usr/bin/env bash
# A container named portal-backend runs from backstage:multistage and answers on port 7007.
set -u
name=portal-backend
running="$(docker inspect --format '{{.State.Running}}' "$name" 2>/dev/null || true)"
if [ "$running" != "true" ]; then
  echo "FAIL: the container $name is not running"
  exit 1
fi
container_image="$(docker inspect --format '{{.Image}}' "$name")"
tag_image="$(docker image inspect --format '{{.Id}}' backstage:multistage 2>/dev/null || true)"
if [ "$container_image" != "$tag_image" ]; then
  echo "FAIL: $name does not run the current backstage:multistage image"
  exit 1
fi
for attempt in $(seq 1 10); do
  if curl -s --max-time 2 http://127.0.0.1:7007/healthcheck | grep -q '"status":"ok"'; then
    echo "PASS: $name answers the health check on port 7007"
    exit 0
  fi
  sleep 1
done
echo "FAIL: $name does not answer on http://127.0.0.1:7007/healthcheck"
docker logs "$name" 2>&1 | tail -n 5
exit 1

#!/usr/bin/env bash
# The container has a health check that passes and a restart policy.
set -u
for attempt in $(seq 1 30); do
  status="$(docker inspect --format '{{if .State.Health}}{{.State.Health.Status}}{{end}}' portal 2>/dev/null || true)"
  [ "$status" = "healthy" ] && break
  sleep 2
done
if [ "$status" != "healthy" ]; then
  echo "FAIL: the health status is '${status:-none}', expected healthy"
  exit 1
fi
policy="$(docker inspect --format '{{.HostConfig.RestartPolicy.Name}}' portal)"
if [ "$policy" != "unless-stopped" ]; then
  echo "FAIL: the restart policy is '$policy', expected unless-stopped"
  exit 1
fi
echo "PASS: the container is healthy and restarts unless stopped"
exit 0

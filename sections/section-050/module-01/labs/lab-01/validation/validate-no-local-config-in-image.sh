#!/usr/bin/env bash
# The developer-only file app-config.local.yaml and its secret are not in the image.
set -u
if ! docker image inspect backstage:lab >/dev/null 2>&1; then
  echo "FAIL: image backstage:lab does not exist"
  exit 1
fi
if docker run --rm --entrypoint sh backstage:lab -c 'test -e /app/app-config.local.yaml'; then
  echo "FAIL: /app/app-config.local.yaml is inside the image"
  exit 1
fi
if docker run --rm --entrypoint sh backstage:lab -c 'grep -rq "lab-secret-token-4471" /app'; then
  echo "FAIL: the secret value from app-config.local.yaml is inside the image"
  exit 1
fi
echo "PASS: no developer-only configuration in the image"
exit 0

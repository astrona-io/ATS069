#!/usr/bin/env bash
# The developer-only file app-config.local.yaml and its secret are not in the image, and no recordings.
set -u
if ! docker image inspect backstage:cache >/dev/null 2>&1; then
  echo "FAIL: image backstage:cache does not exist"
  exit 1
fi
if docker run --rm --entrypoint sh backstage:cache -c 'test -e /app/app-config.local.yaml || test -e /app/recordings'; then
  echo "FAIL: the image holds app-config.local.yaml or the recordings folder"
  exit 1
fi
if docker run --rm --entrypoint sh backstage:cache -c 'grep -rq "lab-secret-token-4471" /app'; then
  echo "FAIL: the secret value from app-config.local.yaml is inside the image"
  exit 1
fi
echo "PASS: no developer-only files in the image"
exit 0

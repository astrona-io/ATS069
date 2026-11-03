#!/usr/bin/env bash
# The final image holds the bundle only: no source, no build script, no local configuration, no secret.
set -u
image=backstage:multistage
docker image inspect "$image" >/dev/null 2>&1 || { echo "FAIL: image $image does not exist"; exit 1; }
for path in /app/packages/backend/src /app/scripts /app/app-config.local.yaml /app/.dockerignore; do
  if docker run --rm --entrypoint sh "$image" -c "test -e $path"; then
    echo "FAIL: $path is inside the final image. Copy only the bundle and the two config files from the build stage."
    exit 1
  fi
done
if docker run --rm --entrypoint sh "$image" -c 'grep -rq "lab-secret-token-4471" /app'; then
  echo "FAIL: the secret from app-config.local.yaml is inside the image"
  exit 1
fi
echo "PASS: the final image has no source, build script or local configuration"
exit 0

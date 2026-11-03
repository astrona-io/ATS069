#!/usr/bin/env bash
# The backend in the image was built from the current source revision.
set -u
image=backstage:multistage
expected="$(tr -d '[:space:]' < /opt/portal/packages/backend/src/build-id 2>/dev/null)"
docker image inspect "$image" >/dev/null 2>&1 || { echo "FAIL: image $image does not exist"; exit 1; }
actual="$(docker run --rm --entrypoint cat "$image" /app/packages/backend/dist/build-id 2>/dev/null | tr -d '[:space:]')"
if [ -z "$expected" ] || [ "$actual" != "$expected" ]; then
  echo "FAIL: the image holds build '$actual' but the source is build '$expected'"
  exit 1
fi
echo "PASS: the image holds build $actual"
exit 0

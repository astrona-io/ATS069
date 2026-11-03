#!/usr/bin/env bash
# The backend in the image was built from the current source revision.
set -u
expected="$(tr -d '[:space:]' < /opt/portal/packages/backend/src/build-id 2>/dev/null)"
[ -n "$expected" ] || { echo "FAIL: /opt/portal/packages/backend/src/build-id is missing"; exit 1; }
if ! docker image inspect backstage:lab >/dev/null 2>&1; then
  echo "FAIL: image backstage:lab does not exist"
  exit 1
fi
actual="$(docker run --rm --entrypoint cat backstage:lab /app/packages/backend/dist/build-id 2>/dev/null | tr -d '[:space:]')"
if [ "$actual" != "$expected" ]; then
  echo "FAIL: the image holds build '$actual' but the source is build '$expected'. Rebuild the bundle before packaging."
  exit 1
fi
echo "PASS: the image holds build $actual, the same as the source"
exit 0

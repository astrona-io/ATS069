#!/usr/bin/env bash
# The final image runs as a user other than root.
set -u
image=backstage:multistage
docker image inspect "$image" >/dev/null 2>&1 || { echo "FAIL: image $image does not exist"; exit 1; }
uid="$(docker run --rm --entrypoint id "$image" -u 2>/dev/null | tr -d '[:space:]')"
if [ -z "$uid" ] || [ "$uid" = "0" ]; then
  echo "FAIL: the container runs as uid '${uid:-unknown}'. Add a USER instruction to the final stage."
  exit 1
fi
echo "PASS: the container runs as uid $uid"
exit 0

#!/usr/bin/env bash
# The image runs as a user other than root.
set -u
if ! docker image inspect backstage:lab >/dev/null 2>&1; then
  echo "FAIL: image backstage:lab does not exist"
  exit 1
fi
uid="$(docker run --rm --entrypoint id backstage:lab -u 2>/dev/null | tr -d '[:space:]')"
if [ -z "$uid" ]; then
  echo "FAIL: could not read the user id inside the image"
  exit 1
fi
if [ "$uid" = "0" ]; then
  echo "FAIL: the container runs as root (uid 0). Add a USER instruction."
  exit 1
fi
echo "PASS: the container runs as uid $uid"
exit 0

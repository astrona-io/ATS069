#!/usr/bin/env bash
# A container named portal runs from the image portal:run.
set -u
state="$(docker inspect --format '{{.State.Running}} {{.Config.Image}}' portal 2>/dev/null || true)"
if [ "$state" = "true portal:run" ]; then
  echo "PASS: the container portal is running from portal:run"
  exit 0
fi
echo "FAIL: expected a running container named portal from portal:run, found: ${state:-none}"
exit 1

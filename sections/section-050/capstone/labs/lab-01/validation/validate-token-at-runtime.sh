#!/usr/bin/env bash
# PORTAL_TOKEN reaches the container at run time and is not part of the image.
set -u
name=portal-backend
if ! curl -s --max-time 3 http://127.0.0.1:7007/status | grep -q '"tokenConfigured":true'; then
  echo "FAIL: the running container has no PORTAL_TOKEN. Start it with -e PORTAL_TOKEN=<value>."
  exit 1
fi
if docker image inspect --format '{{json .Config.Env}}' backstage:multistage | grep -q 'PORTAL_TOKEN'; then
  echo "FAIL: PORTAL_TOKEN is set inside the image. Pass it with docker run -e instead of ENV."
  exit 1
fi
if docker history --no-trunc backstage:multistage 2>/dev/null | grep -q 'PORTAL_TOKEN'; then
  echo "FAIL: PORTAL_TOKEN appears in the image history"
  exit 1
fi
echo "PASS: the token is set at run time and is not in the image"
exit 0

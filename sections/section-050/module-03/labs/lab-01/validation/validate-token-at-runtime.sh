#!/usr/bin/env bash
# The token reaches the running process and is not stored in the image.
set -u
body="$(curl -s --max-time 3 http://127.0.0.1:7007/status || true)"
if ! echo "$body" | grep -q '"tokenConfigured":true'; then
  echo "FAIL: the process does not see PORTAL_TOKEN. Response: $body"
  exit 1
fi
if docker image inspect portal:run | grep -q "lab-run-token-5530"; then
  echo "FAIL: the token is stored in the image metadata"
  exit 1
fi
if docker image history --no-trunc portal:run | grep -q "lab-run-token-5530"; then
  echo "FAIL: the token appears in the image history"
  exit 1
fi
echo "PASS: the token is set at run time and absent from the image"
exit 0

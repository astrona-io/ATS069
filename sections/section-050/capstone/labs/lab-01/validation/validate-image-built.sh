#!/usr/bin/env bash
# The image backstage:multistage exists and was built from a Dockerfile with two stages.
set -u
if ! docker image inspect backstage:multistage >/dev/null 2>&1; then
  echo "FAIL: image backstage:multistage does not exist. Build it with: docker image build . --tag backstage:multistage"
  exit 1
fi
stages="$(grep -ci '^FROM ' /opt/portal/Dockerfile)"
if [ "$stages" -lt 2 ]; then
  echo "FAIL: /opt/portal/Dockerfile has $stages FROM line. A multi-stage build needs at least 2."
  exit 1
fi
echo "PASS: backstage:multistage exists and /opt/portal/Dockerfile has $stages stages"
exit 0

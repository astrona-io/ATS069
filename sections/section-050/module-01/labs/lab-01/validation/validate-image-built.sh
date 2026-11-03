#!/usr/bin/env bash
# The image backstage:lab exists.
set -u
if docker image inspect backstage:lab >/dev/null 2>&1; then
  echo "PASS: image backstage:lab exists"
  exit 0
fi
echo "FAIL: image backstage:lab does not exist. Build it with: docker image build . -f packages/backend/Dockerfile --tag backstage:lab"
exit 1

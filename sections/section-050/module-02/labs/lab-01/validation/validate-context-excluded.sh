#!/usr/bin/env bash
# The build context sent to Docker holds neither recordings nor local configuration files.
set -u
cd /opt/portal || exit 1
probe="$(mktemp -d)"
trap 'docker image rm -f portal-lab-probe >/dev/null 2>&1 || true' EXIT
printf 'FROM node:22-bookworm-slim\nCOPY . /ctx\n' > "$probe/Dockerfile.probe"
if ! docker image build . -f "$probe/Dockerfile.probe" --tag portal-lab-probe >/dev/null 2>&1; then
  echo "FAIL: the probe build failed"
  exit 1
fi
if docker run --rm --entrypoint sh portal-lab-probe -c 'test -e /ctx/recordings'; then
  echo "FAIL: the recordings folder is still in the build context"
  exit 1
fi
if docker run --rm --entrypoint sh portal-lab-probe -c 'test -e /ctx/app-config.local.yaml'; then
  echo "FAIL: app-config.local.yaml is still in the build context"
  exit 1
fi
if ! docker run --rm --entrypoint sh portal-lab-probe -c 'test -e /ctx/packages/backend/dist/bundle.tar.gz'; then
  echo "FAIL: the bundle is missing from the build context"
  exit 1
fi
echo "PASS: the context excludes recordings and local files and keeps the bundle"
exit 0

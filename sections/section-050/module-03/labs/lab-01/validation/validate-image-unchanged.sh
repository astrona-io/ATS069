#!/usr/bin/env bash
# The image portal:run is the one built at the start of the lab.
set -u
expected="$(cat /etc/portal-lab/image.id 2>/dev/null || true)"
actual="$(docker image inspect --format '{{.Id}}' portal:run 2>/dev/null || true)"
if [ -n "$expected" ] && [ "$expected" = "$actual" ]; then
  echo "PASS: the image was not rebuilt"
  exit 0
fi
echo "FAIL: the image portal:run changed. Run the image with different options instead of rebuilding it."
exit 1

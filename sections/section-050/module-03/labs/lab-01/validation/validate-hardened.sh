#!/usr/bin/env bash
# The container runs as a non-root user with the restrictions from the task.
set -u
uid="$(docker exec portal id -u 2>/dev/null | tr -d '[:space:]')"
if [ -z "$uid" ] || [ "$uid" = "0" ]; then
  echo "FAIL: the process runs as root or the user could not be read (uid='$uid')"
  exit 1
fi
ro="$(docker inspect --format '{{.HostConfig.ReadonlyRootfs}}' portal)"
caps="$(docker inspect --format '{{.HostConfig.CapDrop}}' portal)"
opts="$(docker inspect --format '{{.HostConfig.SecurityOpt}}' portal)"
[ "$ro" = "true" ] || { echo "FAIL: the root filesystem is not read-only"; exit 1; }
echo "$caps" | grep -qi "ALL" || { echo "FAIL: capabilities are not all dropped (CapDrop=$caps)"; exit 1; }
echo "$opts" | grep -q "no-new-privileges" || { echo "FAIL: no-new-privileges is not set (SecurityOpt=$opts)"; exit 1; }
echo "PASS: uid $uid, read-only root filesystem, capabilities dropped, no new privileges"
exit 0

#!/usr/bin/env bash
set -u
cd /opt/portal || { echo "FAIL: /opt/portal is missing"; exit 1; }
[ -f yarn.lock ] || { echo "FAIL: yarn.lock is missing"; exit 1; }
versions=$(awk '/^"semver@/{f=1;next} f&&/^  version:/{print $2;f=0} /^$/{f=0}' yarn.lock | tr -d '"' | sort -u)
count=$(echo "$versions" | grep -c .)
if [ "$count" -ne 1 ]; then
  echo "FAIL: yarn.lock holds $count semver releases: $(echo $versions)"; exit 1
fi
lowest=$(printf '%s\n7.5.2\n' "$versions" | sort -V | head -n 1)
if [ "$lowest" != "7.5.2" ]; then
  echo "FAIL: the semver release $versions is older than 7.5.2"; exit 1
fi
echo "PASS: yarn.lock holds one semver release, $versions"

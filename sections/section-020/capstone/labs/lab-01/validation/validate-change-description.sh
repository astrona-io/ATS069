#!/usr/bin/env bash
set -u
cd /opt/portal || { echo "FAIL: /opt/portal is missing"; exit 1; }
if [ ! -s CHANGE.md ]; then
  echo "FAIL: CHANGE.md is missing or empty"
  exit 1
fi
for heading in "## Behavior" "## Boundaries" "## Evidence"; do
  if ! grep -q "^${heading}\$" CHANGE.md; then
    echo "FAIL: CHANGE.md has no heading '${heading}'"
    exit 1
  fi
done
boundaries=$(sed -n '/^## Boundaries$/,/^## /p' CHANGE.md)
changed=$(git status --porcelain | awk '{print $2}' | grep '^packages/' | cut -d/ -f2 | sort -u)
if [ -z "$changed" ]; then
  echo "FAIL: Git shows no changed package"
  exit 1
fi
for package in $changed; do
  if ! printf '%s\n' "$boundaries" | grep -q "$package"; then
    echo "FAIL: the Boundaries section does not name the changed package '$package'"
    exit 1
  fi
done
if ! sed -n '/^## Evidence$/,$p' CHANGE.md | grep -q "yarn tsc"; then
  echo "FAIL: the Evidence section does not mention yarn tsc"
  exit 1
fi
echo "PASS: CHANGE.md describes behavior, boundaries and evidence"

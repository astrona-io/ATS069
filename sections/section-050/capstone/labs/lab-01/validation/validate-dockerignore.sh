#!/usr/bin/env bash
# The ignore file keeps source in the context and keeps local configuration out of it.
set -u
file=/opt/portal/.dockerignore
[ -f "$file" ] || { echo "FAIL: $file is missing"; exit 1; }
if grep -Eq '^[[:space:]]*(\*\*/)?packages/(\*|backend)/src/?[[:space:]]*$' "$file"; then
  echo "FAIL: .dockerignore excludes packages/*/src, but the build stage compiles from it"
  exit 1
fi
if ! grep -Eq '^[[:space:]]*(\*\*/)?\*\.local\.yaml[[:space:]]*$' "$file"; then
  echo "FAIL: .dockerignore does not exclude *.local.yaml"
  exit 1
fi
echo "PASS: .dockerignore keeps the source and excludes *.local.yaml"
exit 0

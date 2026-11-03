#!/usr/bin/env bash
set -u
f=/opt/portal/ci/install.sh
[ -f "$f" ] || { echo "FAIL: $f is missing"; exit 1; }
[ -x "$f" ] || { echo "FAIL: $f is not executable"; exit 1; }
code=$(grep -v '^[[:space:]]*#' "$f")
echo "$code" | grep -Eq 'yarn install[^|;&]*--immutable' || { echo "FAIL: ci/install.sh does not run yarn install --immutable"; exit 1; }
if echo "$code" | grep -Eq '(^|[^-])yarn install([[:space:]]*$|[[:space:]]+[^-])|npm (install|i)( |$)'; then
  echo "FAIL: ci/install.sh still runs an install command that can change the lockfile"; exit 1
fi
echo "PASS: ci/install.sh runs yarn install --immutable"

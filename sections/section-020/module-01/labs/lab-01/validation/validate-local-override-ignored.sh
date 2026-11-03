#!/usr/bin/env bash
set -u
cd /opt/portal || { echo "FAIL: /opt/portal is missing"; exit 1; }
if ! git check-ignore -q app-config.local.yaml; then
  echo "FAIL: Git does not ignore app-config.local.yaml"
  exit 1
fi
if git ls-files --error-unmatch app-config.local.yaml >/dev/null 2>&1; then
  echo "FAIL: app-config.local.yaml is tracked by Git"
  exit 1
fi
echo "PASS: app-config.local.yaml is ignored and untracked"

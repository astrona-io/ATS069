#!/usr/bin/env bash
set -u
cd /opt/portal || { echo "FAIL: /opt/portal is missing"; exit 1; }
[ -s answers.txt ] || { echo "FAIL: /opt/portal/answers.txt is missing or empty"; exit 1; }
grep -q 'backend' answers.txt || { echo "FAIL: answers.txt does not name backend"; exit 1; }
grep -q '@internal/plugin' answers.txt || { echo "FAIL: answers.txt does not name @internal/plugin"; exit 1; }
echo "PASS: answers.txt names the workspaces that depend on @internal/shared"

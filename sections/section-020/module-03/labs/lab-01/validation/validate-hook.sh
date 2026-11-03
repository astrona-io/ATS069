#!/usr/bin/env bash
set -u
cd /opt/portal || { echo "FAIL: /opt/portal is missing"; exit 1; }
hooks=$(git config core.hooksPath || true)
if [ "$hooks" != ".githooks" ]; then
  echo "FAIL: core.hooksPath is '$hooks', expected .githooks"
  exit 1
fi
if [ ! -x .githooks/pre-commit ] || ! grep -q "yarn check" .githooks/pre-commit; then
  echo "FAIL: .githooks/pre-commit must be executable and call yarn check"
  exit 1
fi
# Prove that the hook blocks a bad commit, then restore the file.
printf 'export const broken: number = "text";\n' > packages/app/src/broken.ts
git add packages/app/src/broken.ts
if git -c user.name=grader -c user.email=grader@example.com commit -q -m "bad commit" >/dev/null 2>&1; then
  git reset -q --hard HEAD~1
  echo "FAIL: the hook did not stop a commit that fails the type check"
  exit 1
fi
git reset -q HEAD packages/app/src/broken.ts
rm -f packages/app/src/broken.ts
echo "PASS: the pre-commit hook stops a bad commit"

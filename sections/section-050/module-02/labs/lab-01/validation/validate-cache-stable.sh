#!/usr/bin/env bash
# After a change to an unrelated file, the step that unpacks the bundle is reused from the cache.
set -u
cd /opt/portal || exit 1
build() { docker image build . -f packages/backend/Dockerfile --tag backstage:cache --progress=plain 2>&1; }
build >/dev/null || { echo "FAIL: the first build failed"; exit 1; }
backup="$(mktemp)"
cp docs/notes.md "$backup"
trap 'cp "$backup" docs/notes.md' EXIT
echo "grader change $(date +%s)" >> docs/notes.md
out="$(build)" || { echo "FAIL: the second build failed"; exit 1; }
# BuildKit prints "#N [..] RUN tar ..." and later "#N CACHED". The older builder prints "Using cache".
step="$(echo "$out" | grep -E '^#[0-9]+ \[.*RUN .*tar xzf' | head -n 1 | sed -E 's/^#([0-9]+) .*/\1/')"
if [ -n "$step" ]; then
  if echo "$out" | grep -qE "^#$step CACHED"; then
    echo "PASS: the unpack step was reused from the cache"
    exit 0
  fi
  echo "FAIL: the unpack step ran again after a change to docs/notes.md"
  exit 1
fi
if echo "$out" | grep -A1 'RUN tar xzf' | grep -q 'Using cache'; then
  echo "PASS: the unpack step was reused from the cache"
  exit 0
fi
echo "FAIL: the unpack step ran again after a change to docs/notes.md"
exit 1

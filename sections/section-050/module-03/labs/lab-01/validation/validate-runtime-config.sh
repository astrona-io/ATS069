#!/usr/bin/env bash
# The runtime file is mounted read-only and loaded after the two files of the image.
set -u
rw="$(docker inspect --format '{{range .Mounts}}{{if eq .Destination "/config/app-config.runtime.yaml"}}{{.RW}}{{end}}{{end}}' portal 2>/dev/null || true)"
if [ "$rw" != "false" ]; then
  echo "FAIL: /config/app-config.runtime.yaml must be mounted from the host as read-only (found RW='$rw')"
  exit 1
fi
files="$(docker exec portal wget -qO- http://127.0.0.1:7100/config 2>/dev/null || docker exec portal node -e "require('http').get('http://127.0.0.1:7100/config',r=>r.pipe(process.stdout))" 2>/dev/null || true)"
if echo "$files" | grep -q '"files":\["app-config.yaml","app-config.production.yaml","/config/app-config.runtime.yaml"\]'; then
  echo "PASS: the three configuration files are loaded in order"
  exit 0
fi
echo "FAIL: the backend did not report the three files in order. Response: $files"
exit 1

#!/usr/bin/env bash
# Applies the reference solution. Run only by `astrona test`.
set -euo pipefail
cd /opt/portal
docker rm -f portal >/dev/null 2>&1 || true
docker run -d --name portal -p 7007:7100 \
  -v /opt/portal/runtime/app-config.runtime.yaml:/config/app-config.runtime.yaml:ro \
  --env-file /opt/portal/runtime/portal.env \
  --read-only --tmpfs /tmp --cap-drop ALL --security-opt no-new-privileges \
  --restart unless-stopped \
  --health-cmd "node -e \"require('http').get('http://127.0.0.1:7100/healthcheck',r=>process.exit(r.statusCode===200?0:1)).on('error',()=>process.exit(1))\"" \
  --health-interval 5s --health-timeout 3s --health-retries 3 \
  portal:run \
  node packages/backend --config app-config.yaml --config app-config.production.yaml --config /config/app-config.runtime.yaml

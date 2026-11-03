#!/usr/bin/env bash
# Reference solution for the lab: used only by astrona test.
set -eu
cd /opt/envcfg

sed -i 's|origin: http://localhost:3001|origin: http://localhost:3000|' app-config.yaml
sed -i 's|  providers: {}|  providers:\n    guest: {}|' app-config.yaml
sed -i 's|\.\./\.\./example/entities.yaml|../../examples/entities.yaml|' app-config.yaml
sed -i 's|password: changeme|password: ${POSTGRES_PASSWORD}|' app-config.production.yaml

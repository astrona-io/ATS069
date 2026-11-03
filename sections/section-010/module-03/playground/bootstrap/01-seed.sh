#!/usr/bin/env bash
# Creates the example configuration workspace in /opt/envcfg.
# The workspace holds configuration files shaped like those of a Backstage project, and a checker script. It is not a running Backstage application.
# Faults seeded: none
set -eu
export DEBIAN_FRONTEND=noninteractive

if ! python3 -c 'import yaml' >/dev/null 2>&1; then
  sudo apt-get update -y
  sudo apt-get install -y python3-yaml
fi

sudo mkdir -p /opt/envcfg
sudo chmod 777 /opt/envcfg
cd /opt/envcfg

cat > app-config.yaml <<'EOF_FILE'
app:
  title: Portal
  baseUrl: http://localhost:3000

organization:
  name: Platform

backend:
  baseUrl: http://localhost:7007
  listen:
    port: 7007
  cors:
    origin: http://localhost:3000
    methods: [GET, HEAD, PATCH, POST, PUT, DELETE]
    credentials: true
  database:
    client: better-sqlite3
    connection: ':memory:'

auth:
  environment: development
  providers:
    guest: {}

integrations:
  github:
    - host: github.com
      token: ${GITHUB_TOKEN}

proxy:
  endpoints:
    /status-api:
      target: http://localhost:9000
      changeOrigin: true

catalog:
  rules:
    - allow: [Component, System, API, Resource, Location]
  locations:
    - type: file
      target: ../../examples/entities.yaml
EOF_FILE

cat > app-config.production.yaml <<'EOF_FILE'
app:
  baseUrl: https://portal.example.com

backend:
  baseUrl: https://portal.example.com
  listen:
    port: 7007
    host: 0.0.0.0
  database:
    client: pg
    connection:
      host: ${POSTGRES_HOST}
      port: ${POSTGRES_PORT}
      user: ${POSTGRES_USER}
      password: ${POSTGRES_PASSWORD}
EOF_FILE

mkdir -p packages/backend examples tools
cat > examples/entities.yaml <<'EOF_FILE'
apiVersion: backstage.io/v1alpha1
kind: Component
metadata:
  name: example-website
spec:
  type: website
  lifecycle: experimental
  owner: guests
EOF_FILE

cat > tools/check-config.py <<'EOF_FILE'
#!/usr/bin/env python3
"""Checks one rule about the configuration files in /opt/envcfg.

Usage: python3 tools/check-config.py <cors|guest|catalog|password>
"""
import os
import sys
import yaml

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))


def load(name):
    with open(os.path.join(ROOT, name)) as handle:
        return yaml.safe_load(handle) or {}


def get(tree, path):
    for key in path.split("."):
        if not isinstance(tree, dict) or key not in tree:
            return None
        tree = tree[key]
    return tree


def check(rule):
    base = load("app-config.yaml")
    prod = load("app-config.production.yaml")
    if rule == "cors":
        origin = get(base, "backend.cors.origin")
        app_url = get(base, "app.baseUrl")
        if origin != app_url:
            return "backend.cors.origin is %r but app.baseUrl is %r" % (origin, app_url)
    elif rule == "guest":
        if get(base, "auth.providers.guest") is None:
            return "auth.providers.guest is not defined in app-config.yaml"
        if get(prod, "auth.providers.guest") is not None:
            return "auth.providers.guest must not be defined in app-config.production.yaml"
    elif rule == "catalog":
        backend_dir = os.path.join(ROOT, "packages", "backend")
        for loc in get(base, "catalog.locations") or []:
            if loc.get("type") == "file":
                target = os.path.normpath(os.path.join(backend_dir, loc["target"]))
                if not os.path.isfile(target):
                    return "catalog location %s resolves to %s, which does not exist" % (loc["target"], target)
    elif rule == "password":
        value = get(prod, "backend.database.connection.password")
        if value != "${POSTGRES_PASSWORD}":
            return "production database password is %r, expected ${POSTGRES_PASSWORD}" % (value,)
    else:
        return "unknown rule %s" % rule
    return None


if __name__ == "__main__":
    problem = check(sys.argv[1] if len(sys.argv) > 1 else "")
    if problem:
        print("PROBLEM: " + problem)
        sys.exit(1)
    print("OK: " + sys.argv[1])
EOF_FILE
chmod +x tools/check-config.py

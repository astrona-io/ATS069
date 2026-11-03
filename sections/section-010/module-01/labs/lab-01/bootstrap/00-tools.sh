#!/usr/bin/env bash
# Shared prelude: installs Node.js 22, Yarn (via Corepack) and, when NEED_DOCKER=1, Docker Engine.
# Needs internet access from the virtual machine. Safe to run twice.
set -eu
export DEBIAN_FRONTEND=noninteractive

if ! command -v node >/dev/null 2>&1 || [ "$(node -p 'process.versions.node.split(".")[0]')" != "22" ]; then
  sudo apt-get update -y
  sudo apt-get install -y ca-certificates curl gnupg git build-essential
  curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
  sudo apt-get install -y nodejs
fi

sudo corepack enable
sudo npm install -g typescript@5.8.3 >/dev/null 2>&1 || true

if [ "${NEED_DOCKER:-0}" = "1" ] && ! command -v docker >/dev/null 2>&1; then
  sudo apt-get install -y docker.io
  sudo systemctl enable --now docker
fi
if [ "${NEED_DOCKER:-0}" = "1" ]; then
  sudo chmod 666 /var/run/docker.sock
fi

sudo mkdir -p /opt/portal
sudo chmod 777 /opt/portal

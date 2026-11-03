#!/usr/bin/env bash
# Applies the reference solution. Run only by `astrona test`.
set -euo pipefail
cd /opt/portal

printf '%s\n' ".git" "node_modules" "packages/*/dist" "*.local.yaml" > .dockerignore

cat > Dockerfile <<'DF'
FROM node:22-bookworm-slim AS build
WORKDIR /app
COPY . .
RUN sh scripts/build-backend.sh

FROM node:22-bookworm-slim
WORKDIR /app
RUN chown node:node /app
USER node
ENV NODE_ENV=production
COPY --from=build --chown=node:node /app/packages/backend/dist/bundle.tar.gz ./
RUN tar xzf bundle.tar.gz && rm bundle.tar.gz
COPY --from=build --chown=node:node /app/app-config.yaml /app/app-config.production.yaml ./
EXPOSE 7007
CMD ["node", "packages/backend", "--config", "app-config.yaml", "--config", "app-config.production.yaml"]
DF

docker image build . --tag backstage:multistage
docker rm -f portal-backend >/dev/null 2>&1 || true
docker run -d --name portal-backend -p 7007:7007 -e PORTAL_TOKEN=capstone-token backstage:multistage
sleep 3

#!/usr/bin/env bash
# Applies the reference solution. Run only by `astrona test`.
set -euo pipefail
cd /opt/portal

# Keep the bundle in the context and keep developer-only files out of it.
printf '%s\n' ".git" "node_modules" "*.local.yaml" > .dockerignore

cat > packages/backend/Dockerfile <<'DF'
FROM node:22-bookworm-slim

WORKDIR /app
RUN chown node:node /app
USER node

ENV NODE_ENV=production

COPY --chown=node:node packages/backend/dist/bundle.tar.gz ./
RUN tar xzf bundle.tar.gz && rm bundle.tar.gz

COPY --chown=node:node app-config.yaml app-config.production.yaml ./

EXPOSE 7007
CMD ["node", "packages/backend", "--config", "app-config.yaml", "--config", "app-config.production.yaml"]
DF

npm run build:backend
docker image build . -f packages/backend/Dockerfile --tag backstage:lab

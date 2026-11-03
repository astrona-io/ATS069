# Solution

Work in `/opt/portal`. Run `astrona submit` after each step to see which checks pass.

## 1. Read the build error and fix the ignore file

Build the image:

```sh
cd /opt/portal
docker image build . --tag backstage:multistage
```

The `RUN sh scripts/build-backend.sh` step in the build stage fails because `packages/backend/src/index.cjs.js` does not exist inside the build stage. The ignore file removes `packages/*/src` from the build context, which is right for a host build and wrong for a build that compiles inside Docker. Save this as `.dockerignore`:

```
.git
node_modules
packages/*/dist
*.local.yaml
```

`packages/*/dist` keeps a stale host bundle out, because the build stage creates the bundle. `*.local.yaml` keeps the developer-only file out of the context.

## 2. Copy only what the runtime needs

The draft final stage has `COPY --from=build /app /app`. That copies the source, the build script and everything else from the build stage. It also has no `USER` instruction and its `CMD` loads only `app-config.yaml`, whose host is `127.0.0.1`. A server bound to the loopback address inside a container does not answer on a published port. The production file sets host `0.0.0.0`. Save this as `Dockerfile`:

```dockerfile
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
```

## 3. Build, run with the token and check

Build the image:

```sh
docker image build . --tag backstage:multistage
```

Start the container with the token as a run-time environment variable:

```sh
docker run -d --name portal-backend -p 7007:7007 -e PORTAL_TOKEN=capstone-token backstage:multistage
```

Check the container:

```sh
curl http://127.0.0.1:7007/healthcheck
curl http://127.0.0.1:7007/status
curl http://127.0.0.1:7007/build
docker image inspect --format '{{json .Config.Env}}' backstage:multistage
docker run --rm --entrypoint ls backstage:multistage /app
```

The health check returns `status` set to `ok`. The status call returns `tokenConfigured` set to `true`. The image environment lists `NODE_ENV` and no `PORTAL_TOKEN`. The listing of `/app` shows `packages` and the two config files, and no `scripts` directory. Then run `astrona submit`.

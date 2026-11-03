# Solution

Work in `/opt/portal`. Each step has a check you can run, and `astrona submit` shows which checks pass.

## 1. Read the first build error

Build the image:

```sh
cd /opt/portal
docker image build . -f packages/backend/Dockerfile --tag backstage:lab
```

The build stops at the `COPY packages/backend/dist/bundle.tar.gz ./` step and reports that the file is not found. The file exists on disk, so the build context must exclude it. Read the ignore file:

```sh
cat .dockerignore
```

The line `packages/*/dist` removes the bundle from the build context. A host-build Dockerfile needs the bundle, so remove that line. Save this as `.dockerignore`, which also keeps developer-only files out of the context:

```
.git
node_modules
*.local.yaml
```

## 2. Rebuild the bundle from the current source

The bundle was built from revision `r1` and the source is at `r2`. Compare them:

```sh
cat packages/backend/src/build-id
tar -xzOf packages/backend/dist/bundle.tar.gz ./packages/backend/dist/build-id
```

Build the bundle again:

```sh
npm run build:backend
```

## 3. Fix the Dockerfile

Two faults are in `packages/backend/Dockerfile`: it never switches to a non-root user, and `COPY app-config*.yaml ./` also copies `app-config.local.yaml`. Save this as `packages/backend/Dockerfile`:

```dockerfile
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
```

`RUN chown node:node /app` gives the `node` user write access to the working directory, which Docker creates as root. The `CMD` loads the production file after `app-config.yaml`. The production file sets `host: 0.0.0.0`, so the server accepts connections from outside the container.

## 4. Build and check

Build the image again and run it:

```sh
docker image build . -f packages/backend/Dockerfile --tag backstage:lab
docker run -d --name lab-check -p 7007:7007 backstage:lab
curl http://127.0.0.1:7007/healthcheck
curl http://127.0.0.1:7007/build
docker run --rm --entrypoint id backstage:lab -u
docker rm -f lab-check
```

The health check returns a JSON body with `status` set to `ok`. The build identifier matches `packages/backend/src/build-id`. The user id is not `0`. Then run `astrona submit`.

# Solution

Work in `/opt/portal`. Each step has a check you can run, and `astrona submit` shows which checks pass.

## 1. Look at the build context

Build the image once and read the context line of the output:

```sh
cd /opt/portal
docker image build . -f packages/backend/Dockerfile --tag backstage:cache --progress=plain 2>&1 | grep -i context
```

The reported size is large because the folder `recordings` holds a 40 MB file. Read the ignore file:

```sh
cat .dockerignore
```

It lists only `.git` and `node_modules`. Save this as `.dockerignore`. The pattern `**/*.local.yaml` covers every folder, and the bundle stays in the context because nothing excludes `packages/backend/dist`:

```
.git
node_modules
**/*.local.yaml
recordings
```

## 2. Copy only what the image needs

The line `COPY --chown=node:node . .` copies the whole context into the image, so it also copies files that the ignore file does not exclude and it makes the cache depend on every file. Replace it. Save this as `packages/backend/Dockerfile`:

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

The bundle is copied and unpacked first, and the two configuration files come last, so a change to a configuration file does not repeat the unpack step.

## 3. Build and check the cache

Build the bundle and the image, then change an unrelated file and build again:

```sh
npm run build:backend
docker image build . -f packages/backend/Dockerfile --tag backstage:cache
echo "one more note" >> docs/notes.md
docker image build . -f packages/backend/Dockerfile --tag backstage:cache --progress=plain 2>&1 | grep -E "CACHED|Using cache"
```

The steps that copy and unpack the bundle are marked as cached. To check the context and the image contents, build a probe image and look inside the image:

```sh
printf 'FROM node:22-bookworm-slim\nCOPY . /ctx\n' > /tmp/Dockerfile.probe
docker image build . -f /tmp/Dockerfile.probe --tag portal:probe
docker run --rm portal:probe ls -a /ctx
docker run --rm --entrypoint ls backstage:cache -a /app
```

The first listing shows no `recordings` folder and no `app-config.local.yaml`. The second listing shows the unpacked backend and the two configuration files. Then run the container and the check:

```sh
docker run -d --name lab-check -p 7007:7007 backstage:cache
curl http://127.0.0.1:7007/healthcheck
docker rm -f lab-check
```

The health check returns a JSON body with `status` set to `ok`. Then run `astrona submit`.

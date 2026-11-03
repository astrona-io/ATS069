# Overview: Container Image Build (Playground)

This is a playground, not a lab. It starts an Ubuntu virtual machine with Docker and a small portal workspace, then waits. There is no task, no `astrona submit` and no pass or fail. Build images, break the Dockerfiles, run `astrona destroy` and start again.

## What is in the box

- Node.js 22 and Docker Engine. Your user can run `docker` without `sudo`.
- `/opt/portal`, a simplified workspace with the packages `app` and `backend`, the files `app-config.yaml`, `app-config.production.yaml` and `app-config.local.yaml`, and the script `scripts/build-backend.sh`.
- `packages/backend/Dockerfile`, a host-build Dockerfile that unpacks `packages/backend/dist/bundle.tar.gz`. The bundle is already built.
- `Dockerfile.multistage`, a two-stage Dockerfile that builds the bundle inside Docker.
- `.dockerignore`, which excludes `.git`, `node_modules` and `*.local.yaml`.
- The base image `node:22-bookworm-slim`, already pulled.

The backend is a small Node.js server, not a real Backstage backend. It reads `--config` files, listens on the port and host they set, and answers `GET /healthcheck`, `GET /build` and `GET /status`.

## Practice tasks

- Run `npm run build:backend` in `/opt/portal`, then list the archive with `tar -tzf packages/backend/dist/bundle.tar.gz`.
- Build the host-build image with `docker image build . -f packages/backend/Dockerfile --tag portal:host` and read each step of the build output.
- Run it with `docker run -d --name portal -p 7007:7007 portal:host` and call `curl http://127.0.0.1:7007/healthcheck`. Remove it with `docker rm -f portal`.
- Add the line `packages/*/dist` to `.dockerignore` and build again. Read the error. Remove the line.
- Build `Dockerfile.multistage` with `-f Dockerfile.multistage --tag portal:multi` and compare `docker image ls` and `docker history` for both images.
- Start a container with `-e PORTAL_TOKEN=abc` and call `/status`. Then run `docker image inspect --format '{{.Config.Env}}' portal:host` and check that the token is not in the image.
- Remove `app-config.production.yaml` from the `CMD` of a copy of the Dockerfile, rebuild, and see why the published port no longer answers.

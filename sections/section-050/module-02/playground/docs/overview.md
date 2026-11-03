# Overview: Dockerfile Layers, Caching And Build Context (Playground)

This is a playground, not a lab. It starts an Ubuntu virtual machine with Docker and a small portal workspace, then waits. There is no task, no `astrona submit` and no pass or fail. Build images, break the files, run `astrona destroy` and start again.

## What is in the box

- Node.js 22 and Docker Engine. Your user can run `docker` without `sudo`. The `docker buildx` plugin is installed when the package is available.
- `/opt/portal`, a simplified workspace with `app-config` files, a host-build `packages/backend/Dockerfile` and the script `scripts/build-backend.sh`, which plays the role of `yarn build:backend`.
- `recordings/session.bin`, a 40 MB file that no image needs.
- `Dockerfile.cache`, which uses a BuildKit cache mount, and `Dockerfile.secret`, which uses a secret mount.
- The base image `node:22-bookworm-slim`, already pulled.

## Practice tasks

- Compare the transferred context size before and after you add `recordings` to `.dockerignore`.
- Build a probe image that copies the whole context and list `/ctx` to see which files arrived.
- Build twice and find the cached steps. Change `packages/backend/src/build-id`, rebuild the bundle, and see which steps run again.
- Build `Dockerfile.cache` twice with `--no-cache` and compare the line counts the step prints.
- Build `Dockerfile.secret` with `--secret id=demo,src=<file>` and confirm that `docker image history` does not show the value.
- Add `COPY . .` as the first copy of the host-build Dockerfile and see how many steps the cache loses after a change to an unrelated file.

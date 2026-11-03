# Overview: Running And Securing The Image (Playground)

This is a playground, not a lab. It starts an Ubuntu virtual machine with Docker and an image named `portal:run`, then waits. There is no task, no `astrona submit` and no pass or fail. Start containers, restrict them, remove them and try again.

## What is in the box

- Node.js 22 and Docker Engine. Your user can run `docker` without `sudo`.
- The image `portal:run`, built from `/opt/portal/Dockerfile`. It runs as the user `node` and starts with two `--config` files.
- `/opt/portal/runtime/app-config.runtime.yaml`, which sets the port to 7100, and `/opt/portal/runtime/portal.env`, which sets `PORTAL_TOKEN`.
- The images `node:22-bookworm-slim` and `postgres:16-bookworm`, already pulled.

The backend is a small Node.js server, not a real Backstage backend. It reads `--config` files and the variable `PORTAL_TOKEN`, and it answers `GET /healthcheck`, `GET /build`, `GET /config` and `GET /status`. It does not read `${NAME}` references, `APP_CONFIG_` variables or a database.

## Practice tasks

- Start a container with `-p 7007:7007`, read its log and call `/config`.
- Mount `runtime/app-config.runtime.yaml` read-only, pass it as a third `--config` option and publish the new port.
- Start a container with `--read-only`, `--cap-drop ALL` and `--security-opt no-new-privileges` and confirm it still answers.
- Add a health check and read the state with `docker inspect --format '{{.State.Health.Status}}'`.
- Start a PostgreSQL container on a user-defined network and check it with `pg_isready`.

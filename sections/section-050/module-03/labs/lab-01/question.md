# Question

Solve this question on: `terminal`

The image `portal:run` is already built from the workspace in `/opt/portal`. It is a simplified stand-in for a Backstage backend, not a real Backstage application. It runs as the user `node` and starts with two `--config` files from the image. Do not rebuild or change the image. No container is running.

The platform team of the `starfleet` fleet needs the backend started for the test environment. Start one container named `portal` from `portal:run` with these properties:

1. The file `/opt/portal/runtime/app-config.runtime.yaml` is mounted read-only at `/config/app-config.runtime.yaml` and loaded as the third `--config` option, after the two files the image already uses. The start command after the image name replaces the `CMD` of the image.
2. That file sets a different listen port. Publish the backend on host port 7007 so that `GET /healthcheck` on `127.0.0.1:7007` answers.
3. The token in `/opt/portal/runtime/portal.env` reaches the process as an environment variable. The token must not be stored in the image.
4. The container runs with a read-only root filesystem, all capabilities dropped and the option `no-new-privileges`. The process must not run as root. The backend needs no writable path, but you may add a `tmpfs` at `/tmp`.
5. The container has a health check that passes, and it restarts unless it is stopped by hand. The slim image has no `curl`, so use Node.js in the health command.

Docker is installed and your user can run `docker` without `sudo`.

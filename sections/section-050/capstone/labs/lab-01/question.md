# Question

Solve this question on: `terminal`

The `portal` workspace in `/opt/portal` has the shape of a Backstage project. It is a simplified fixture with no dependencies to install. The root script `sh scripts/build-backend.sh` (also `npm run build:backend`) writes `packages/backend/dist/bundle.tar.gz`. The platform team of the `starfleet` fleet wants one multi-stage `Dockerfile` at the root that builds the bundle inside Docker and ships only the bundle in the final image. The first draft does not work.

Deliver the following. Do not edit anything under `packages/backend/src`.

1. Build the image `backstage:multistage` from `/opt/portal/Dockerfile` with `/opt/portal` as the build context. The build fails today. Find out why and fix the cause in `.dockerignore`.
2. `.dockerignore` must also keep every `*.local.yaml` file out of the build context. `app-config.local.yaml` holds a developer-only secret.
3. The final stage must contain the unpacked bundle and the files `app-config.yaml` and `app-config.production.yaml` in `/app`. It must not contain the backend source, the `scripts` directory, the file `app-config.local.yaml` or its secret.
4. The final image must not run as root.
5. The image must start the backend with both config files so the server listens on all interfaces. A container published with `-p 7007:7007` must answer `GET /healthcheck`.
6. Start a container named `portal-backend` from the image. Publish port 7007 and pass the environment variable `PORTAL_TOKEN` with any value at run time. `GET /status` must report `tokenConfigured` as `true`. `PORTAL_TOKEN` must not appear in the image configuration or history.

Leave the container `portal-backend` running. Docker is installed and your user can run `docker` without `sudo`.

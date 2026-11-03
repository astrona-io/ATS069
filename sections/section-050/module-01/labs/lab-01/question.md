# Question

Solve this question on: `terminal`

The `portal` workspace in `/opt/portal` has the shape of a Backstage project: a root `package.json`, an `app` and a `backend` package, three `app-config` files and a host-build `Dockerfile` in `packages/backend`. It is a simplified fixture, not a real Backstage application, and it has no dependencies to install. The root script `npm run build:backend` plays the role of `yarn build:backend`: it writes `packages/backend/dist/bundle.tar.gz`.

The platform team of the `starfleet` fleet needs the backend packaged as the image `backstage:lab`. The first attempt does not work. Fix it. Do not edit anything under `packages/backend/src`.

1. Build the image `backstage:lab` with the Dockerfile `packages/backend/Dockerfile` and `/opt/portal` as the build context. The first build fails. Find out why and fix the cause.
2. The image must contain the backend built from the current source. The bundle in `packages/backend/dist` was built from an older revision.
3. The container must not run as root.
4. The file `app-config.local.yaml` holds a developer-only secret. Neither the file nor its secret may be inside the image.
5. A container started from the image with `-p 7007:7007` must answer `GET /healthcheck` on the published port.

Docker is installed and your user can run `docker` without `sudo`.

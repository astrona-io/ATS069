# Question

Solve this question on: `terminal`

The `portal` workspace in `/opt/portal` has the shape of a Backstage project: a root `package.json`, an `app` and a `backend` package, three `app-config` files and a host-build `Dockerfile` in `packages/backend`. It is a simplified fixture, not a real Backstage application. The root script `npm run build:backend` plays the role of `yarn build:backend`: it writes `packages/backend/dist/bundle.tar.gz`.

The image builds, but the platform team of the `starfleet` fleet is unhappy with it. Every build sends a very large build context, the image holds files that must never leave a developer machine, and every small change rebuilds every layer. Fix this. Do not edit anything under `packages/backend/src`.

1. The image must be built as `backstage:cache` with the Dockerfile `packages/backend/Dockerfile` and `/opt/portal` as the build context.
2. The build context must not include the `recordings` folder or any file that ends in `.local.yaml`. The bundle in `packages/backend/dist` must stay in the context.
3. The file `app-config.local.yaml` holds a developer-only secret. Neither the file nor its secret may be inside the image, and neither may the `recordings` folder.
4. Changing an unrelated file, such as `docs/notes.md`, must not make Docker run the step that unpacks the bundle again.
5. A container started from the image with `-p 7007:7007` must answer `GET /healthcheck`.

Docker is installed and your user can run `docker` without `sudo`.

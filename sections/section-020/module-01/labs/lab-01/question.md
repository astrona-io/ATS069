# Question

Solve this question on: `terminal`

The portal team in `/opt/portal` adds a warning for catalog entities that have no owner. The `scout` entity has an owner and the `probe` entity does not. The change works on one developer's machine and fails on every other checkout. The workspace is a Git repository with one commit. It is a simplified fixture with the shape of a Backstage project, not a generated application.

Make the change reviewable on a clean checkout. Do not edit any `*.test.ts` file, and keep `app-config.local.yaml` in place.

1. `yarn tsc` must finish without errors. Fix the source, not the shared type.

2. `yarn test` must pass. An entity with an owner is `owned`, an entity without an owner is `missing`, and only a failed catalog request (no entity at all) is `error`.

3. The key `catalog.ownerWarning.enabled: true` exists only in `app-config.local.yaml`. Every checkout needs it. Make it part of the shared `app-config.yaml`, remove it from the local file, and keep the local `backend.listen.port` override of `7008`.

4. `app-config.yaml` contains the database password as plain text. Read it from the environment variable `BACKEND_DB_PASSWORD` instead.

5. Git must ignore `app-config.local.yaml`, so that a personal override never reaches a review.

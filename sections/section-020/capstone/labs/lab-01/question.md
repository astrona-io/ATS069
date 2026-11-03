# Question

Solve this question on: `terminal`

The portal team in `/opt/portal` is adding a deployment status badge. The backend builds a `DeploymentStatus` for a service, the shared package `catalog-common` defines the types, and the app turns a status into a badge. A colleague left the change unfinished and it fails in every check. The workspace is a Git repository with one commit. It is a simplified fixture with the shape of a Backstage project, not a generated application.

Finish the change so that it is reviewable on a clean checkout. Do not edit any `*.test.ts` file, and keep `app-config.local.yaml` in place.

1. `yarn tsc` must finish without errors.

2. `yarn test` must pass. A missing raw status is `unknown`, not `degraded`. The `updatedAt` value must come from the clock argument of `buildStatus`. In the app, a status of `unknown` shows the badge `{ label: 'Unknown', tone: 'neutral' }`.

3. `yarn lint` must report no problems. Fix the code; do not edit `scripts/lint.mjs`.

4. Configuration:
   - The key `catalog.deploymentStatus.enabled: true` exists only in `app-config.local.yaml`. Make it part of `app-config.yaml` and remove it from the local file. The local `backend.listen.port` override of `7008` stays.
   - The database password in `app-config.yaml` is plain text. Read it from `BACKEND_DB_PASSWORD`.
   - Git must ignore `app-config.local.yaml`.

5. Write `/opt/portal/CHANGE.md`, the description a reviewer reads. It needs three headings: `## Behavior` (what the user sees), `## Boundaries` (the name of every package you changed, as Git reports them) and `## Evidence` (the commands you ran and what each one proved). Check the changed files with `git status`.

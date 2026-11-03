# Solution

Open a shell in the lab and change to the workspace with `cd /opt/portal`. Start by running all three checks to see the failures:

```sh
yarn tsc
yarn test
yarn lint
```

## 1. Type errors

`yarn tsc` reports two errors. In `packages/backend/src/statusRoute.ts` the returned object has a property `status`, but `DeploymentStatus` calls it `state`. In `packages/app/src/statusBadge.ts` the import `StatusBadge` does not exist, because `catalog-common` does not export it. Add the type to `packages/catalog-common/src/index.ts`:

```ts
export interface StatusBadge {
  label: string;
  tone: 'ok' | 'warn' | 'neutral';
}
```

## 2. Behavior

Rewrite `buildStatus` so that an undefined raw status is `unknown` and the clock argument sets `updatedAt`:

```ts
const state = raw === undefined ? 'unknown' : raw.ok ? 'healthy' : 'degraded';
return { service, state, updatedAt: now.toISOString() };
```

In `badgeFor`, add a branch for `degraded` and return `{ label: 'Unknown', tone: 'neutral' }` for every other state. Run `yarn test`.

## 3. Lint

Delete the `console.debug` line in `statusRoute.ts`. In `statusBadge.ts`, change the parameter type from `any` to `DeploymentStatus`. Run `yarn lint`; it prints `lint ok`.

## 4. Configuration

Add the `catalog.deploymentStatus.enabled: true` block to `app-config.yaml`, remove the `catalog` block from `app-config.local.yaml`, replace `password: hunter2` with `password: ${BACKEND_DB_PASSWORD}` and ignore the local file:

```sh
echo app-config.local.yaml >> .gitignore
git check-ignore app-config.local.yaml
```

## 5. Describe the change

List the changed files with `git status --short`. Three packages changed: `packages/app`, `packages/backend` and `packages/catalog-common`. Write `CHANGE.md` with the three headings, name the three packages under `## Boundaries`, and list `yarn tsc`, `yarn test` and `yarn lint` under `## Evidence` with what each proved. Then run `astrona submit`.

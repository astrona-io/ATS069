# Question

Solve this question on: `terminal`

The `portal` workspace in `/opt/portal` has an `app` package, a `deploy-backend` plugin and a `deploy-common` plugin. A developer says that `tsc` is green, yet the backend plugin crashed on a deployment record that has no owner. The workspace is a simplified fixture with the shape of a Backstage repository: it has no real Backstage packages. Open a shell with `astrona ssh ats-069-lab-030-01`. Fix the configuration and the code. Do not weaken the compiler.

1. Make the single type check, run as `tsc` in `/opt/portal`, cover the `app` package and both plugins. The check is configured in `/opt/portal/tsconfig.json`.

2. After the scope is right, the check reports an error in `deploy-backend`. Fix the function `describeOwner` so that the error disappears and a record without an `owner` gives the text `unassigned`. A record with an owner still gives the owner in upper case.

3. The check must not write any files. Configure that in `tsconfig.json`. If a run of `tsc` already wrote `.js` files in a `src` folder, delete them.

4. Keep `strict` turned on. Do not use a type assertion (`as`), the non-null operator (`!`) or a `@ts-ignore` comment.

`tsc` is on the `PATH`. Edit only `tsconfig.json` and `plugins/deploy-backend/src/index.ts`.

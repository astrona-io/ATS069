# Question

Solve this question on: `terminal`

The `portal` workspace in `/opt/portal` must build in one command, in dependency order, and must give the `app` package a safe way to read a deployment record from JSON. Today the build fails and the app trusts its input. The workspace is a simplified fixture with the shape of a Backstage repository: it has no real Backstage packages. Open a shell with `astrona ssh ats-069-capstone-030-01`. Do not weaken the compiler.

1. The root `tsconfig.json` is a solution file. Make it reference all three projects: `plugins/deploy-common`, `plugins/deploy-backend` and `packages/app`.

2. The `deploy-backend` plugin imports types from `deploy-common`, but its project does not declare that dependency. Declare it so that a build from a clean state works.

3. In `plugins/deploy-common/src/index.ts`, export a function `parseDeployment(input: unknown): DeploymentRecord`. It must return a record for an object with a string `id`, a `status` of `running` or `failed` and an optional string `owner`. It must throw an `Error` for any other input, including an unknown status such as `done`.

4. In `packages/app/src/index.ts`, make `renderRow` use `parseDeployment` instead of a type assertion. The constant `sample` currently has an invalid status: correct it with a valid one.

5. In `/opt/portal/package.json`, make the script `build:all` run `tsc --build`.

6. Build the whole workspace so that each of the three projects has JavaScript and declaration files in its `dist` folder. Keep `strict` turned on. Do not use `any`, an assertion to `DeploymentRecord`, or `@ts-ignore`, `@ts-nocheck` and `@ts-expect-error` comments.

`tsc` is on the `PATH`. The `paths` entry in `tsconfig.base.json` stays as it is.

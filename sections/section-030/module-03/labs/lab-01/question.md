# Question

Solve this question on: `terminal`

The `portal` workspace in `/opt/portal` has an `app` package, a `backend` package, a `deploy-common` library and a `deploy-backend` plugin. A developer says the build is green, but a release job fails: one package has no role, the root build builds only one package, a library would publish no build output, and the backend plugin has a type error that the build never reported. The workspace is a simplified fixture with the shape of a Backstage repository: it has no `backstage-cli`, and the `build` script of each package is a transpile-only stand-in. Open a shell with `astrona ssh ats-069-lab-030-03`. Run the scripts with `npm run`, because the workspace has no Yarn project.

1. Give `plugins/deploy-backend` the Backstage role that fits a backend plugin, in the `backstage.role` field of its `package.json`. Check all roles with `node scripts/list-roles.mjs`.

2. Make the root script `build:all` build every package of the workspace. Remove the `dist` folders and check that `npm run build:all` writes `dist/index.js` in all four packages.

3. Make `plugins/deploy-common` list its build output in the `files` field, so that a published package contains `dist`.

4. Run the root type check and fix the error that it reports in `plugins/deploy-backend/src/index.ts`. After the fix, `describeBackend('abc')` returns `abc (3)`. Do not use `any`, a type assertion or a ts comment directive, and do not change the `build` scripts.

Edit only the `package.json` files and `plugins/deploy-backend/src/index.ts`.

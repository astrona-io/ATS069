# Question

Solve this question on: `terminal`

The `portal` workspace in `/opt/portal` has an `app` package, a `deploy-backend` plugin and a `deploy-common` plugin. The file `tsconfig.base.json` holds the shared options of the repository. The root `tsconfig.json` ignores it, turns `strict` off and writes JavaScript files next to the sources. The workspace is a simplified fixture with the shape of a Backstage repository: it has no real Backstage packages. Open a shell with `astrona ssh ats-069-lab-030-02`. Run the scripts with `npm run`, because the workspace has no Yarn project.

1. Change the root `tsconfig.json` so that it extends `./tsconfig.base.json` and does not set `strict` itself. Keep the `include` list. Set `outDir` to `dist-types` and `rootDir` to `.`, and remove the options that the base already provides.

2. With `strict` active, the check reports an error in `deploy-backend`. Fix it by giving the parameter its type. Do not use `any`, a type assertion or a `@ts-ignore` comment.

3. Delete the `.js` files that earlier runs of `tsc` wrote in the `src` folders. After the change, `npm run tsc` must write declaration files into `dist-types` and nothing next to the sources.

4. Add a script `tsc:full` to the root `package.json`. It runs `tsc` with `skipLibCheck` turned off and incremental mode turned off.

5. Make `.gitignore` list `dist-types`.

`tsc` is on the `PATH`. Edit only `tsconfig.json`, `package.json`, `.gitignore` and `plugins/deploy-backend/src/index.ts`.

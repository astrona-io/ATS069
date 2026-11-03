# Overview: Backstage Build Pipelines And Package Roles (Playground)

This is a playground, not a lab. It starts an Ubuntu virtual machine and waits. There is no task, no `astrona submit` and no pass or fail. Edit files, break them, run `astrona destroy` and start again. Open a shell with `astrona ssh ats-069-playground-030-03`.

## What is in the box

- Node.js 22 and the TypeScript compiler `tsc` (version 5.8.3) on the `PATH`.
- The workspace `/opt/portal` with four packages: `packages/app` (role `frontend`), `packages/backend` (role `backend`), `plugins/deploy-common` (role `common-library`) and `plugins/deploy-backend` (role `backend-plugin`).
- A `build` script in each package that runs `tsc -p tsconfig.build.json --noCheck`. This stands in for `backstage-cli package build`: it removes the types and writes JavaScript into `dist`, and it does not report type errors.
- Root scripts `tsc`, `build:all` and `build:backend`. The workspace has no Yarn project, so run them with `npm run`.
- `scripts/list-roles.mjs`, which prints the name and role of every package.
- No registry packages: there is no `backstage-cli` here.

## Practice tasks

- Run `cd /opt/portal`, then `node scripts/list-roles.mjs`.
- Run `npm run build:all` and list the `dist` folder of each package.
- Run `npm run build:backend` after you delete `packages/backend/dist` and check that the other `dist` folders are not changed.
- Introduce a type error in `plugins/deploy-common/src/index.ts`. Run `npm run build:all` and read the result, then run `npm run tsc`.
- Run `node packages/backend/dist/index.js` and `node -e "console.log(require('/opt/portal/packages/backend').startBackend(7007))"`.
- Remove `"dist"` from the `files` field of one package and run `npm pack --dry-run` in that folder.
- Delete every `dist` folder and run `npm run build:all` again.

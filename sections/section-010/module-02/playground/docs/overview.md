# Overview: Backstage CLI, Scaffolding And Project Creation (Playground)

This is a playground, not a lab. It starts an Ubuntu virtual machine with an example workspace and waits. There is no task, no `astrona submit` and no pass or fail.

## What is in the box

- Node.js 22 and Yarn 4 (through Corepack).
- The workspace `/opt/scaffold`, laid out like a project made by `@backstage/create-app`: `packages/app`, `packages/backend`, `plugins/status`, `plugins/status-backend`, `app-config.yaml`, `backstage.json` and `catalog-info.yaml`.
- The script `tools/check-env.js`, which compares the Node.js version with the `engines` field.
- The `backstage-cli` package is not installed, because the workspace has no registry dependencies. Read its commands in the `scripts` fields.

## Practice tasks

- Run `yarn workspaces list` and read every `package.json`. Note the `backstage.role` of each package.
- Run `node tools/check-env.js`. Change `engines.node` to `18`, run it again and read the error. Restore it.
- Add `plugins/*` and remove it again in the `workspaces` field, and compare the output of `yarn workspaces list`.
- Read `backstage.json` and write down which Backstage release the project records.

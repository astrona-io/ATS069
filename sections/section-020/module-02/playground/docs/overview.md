# Overview: Developing Plugins Locally (Playground)

This is a playground, not a lab. It starts an Ubuntu virtual machine with a small portal workspace and waits. There is no task, no `astrona submit` and no pass or fail. Change files, break things, run `astrona destroy` and start again.

## What is in the box

- Node.js 22, Yarn 4 (through Corepack) and Git. Open a shell with `astrona ssh ats-069-playground-020-02`.
- `/opt/portal`, a Yarn workspace with `packages/app`, `packages/backend`, `plugins/hello` (a frontend plugin) and `plugins/hello-backend` (a backend plugin).
- `yarn start` starts the backend with the plugin added. `yarn start` inside a plugin folder runs only that plugin from its `dev/index.ts` file.
- `yarn new <id>` is a small stand-in for the Backstage `yarn new` command. It creates `plugins/<id>-backend`.
- `yarn tsc` and `yarn test` check the whole workspace.

## Practice tasks

- Run `yarn workspaces list` and find the two plugins.
- In `plugins/hello`, run `yarn start`. Edit `plugins/hello/src/plugin.ts` in a second shell and watch the output change.
- In `plugins/hello-backend`, run `yarn start`, then `curl http://127.0.0.1:7008/api/hello/greeting`. Change the greeting text and request it again.
- In the root, run `yarn start` and `curl http://127.0.0.1:7007/api/hello/greeting`. Remove the line `backend.add(helloBackendPlugin);` from `packages/backend/src/index.ts` and compare the answer.
- Change the plugin `id` to `hello-world` and see which route answers and which test fails.
- Run `yarn new orders`, add the plugin to the backend and request `/api/orders`.

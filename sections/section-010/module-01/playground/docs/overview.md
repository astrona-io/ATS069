# Overview: Local Projects, Development Servers And Production Builds (Playground)

This is a playground, not a lab. It starts an Ubuntu virtual machine with a working example workspace and waits. There is no task, no `astrona submit` and no pass or fail. Start processes, break the configuration, run `astrona destroy` and start again.

## What is in the box

- Node.js 22 and Yarn 4 (through Corepack).
- The workspace `/opt/portal`, with the workspaces `app` and `backend` under `packages/`. It has the shape of a Backstage project, but it is small and has no registry dependencies. Its scripts are simplified stand-ins for the commands of a real project.
- `app-config.yaml` (base configuration) and `app-config.production.yaml` (an override file).
- The root scripts `start`, `start:backend`, `build:backend` and `build:all`.
- Nothing is running and no `dist` folder exists yet. Open a shell with `astrona ssh ats-069-playground-010-01` and work in `/opt/portal`.

## Practice tasks

- Run `yarn workspaces list` and read the `package.json` of the root and of each package.
- Run `yarn start:backend` in one terminal and `curl http://localhost:7007/healthcheck` in another.
- Remove the `listen` block from `app-config.yaml` and read the error. Put it back.
- Run `yarn start` and request `http://localhost:3000/config.json` and `http://localhost:7007/api/deployment-status`. Stop with Ctrl+C.
- Run `yarn build:all`. List both `dist` folders. Start `node packages/backend/dist/index.js --config app-config.yaml --config app-config.production.yaml` and read the `environment` value in the health check.
- Delete `packages/backend/src` after a build and show that the build output still runs.

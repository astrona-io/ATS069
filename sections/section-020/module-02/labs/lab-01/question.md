# Question

Solve this question on: `terminal`

The portal team in `/opt/portal` wrote a backend plugin in `plugins/hello-backend`. The browser code calls the route `/api/hello/greeting`, but the backend answers 404. The workspace is a Git repository with one commit. It is a simplified fixture with the shape of a Backstage project, not a generated application.

Wire the plugin into the portal. Do not edit any `*.test.ts` file.

1. Yarn must know the plugin as a workspace. `yarn workspaces list` must show `plugins/hello-backend`.

2. The plugin must serve its routes under `/api/hello`. The tests in `plugins/hello-backend` describe the id the plugin must have.

3. The backend must load the plugin. Add the plugin to the backend in `packages/backend/src/index.ts`.

4. `packages/backend/package.json` must declare the plugin package `@internal/plugin-hello-backend` as a dependency, using the workspace protocol.

5. Start the backend with `yarn start` and check that `curl http://127.0.0.1:7007/api/hello/greeting` answers with status 200.

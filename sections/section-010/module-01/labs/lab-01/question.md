# Question

Solve this question on: `terminal`

The `portal` workspace in `/opt/portal` is the example project of the `starfleet` platform team. A new developer cannot start the backend, and nobody has produced a build that can be deployed. Fix the workspace so that both work. The workspace is a small stand-in with the shape of a Backstage project. It is not a real Backstage application, and its scripts are simplified.

1. The backend refuses to start because a required configuration value is missing. Read the error that the backend prints, then add the value to `app-config.yaml`. The backend must listen on port `7007`.

2. `yarn workspace backend start` must start the backend from the source files and answer `http://localhost:7007/healthcheck`. Today the start script cannot find the configuration file. Fix the script in `packages/backend/package.json`.

3. `yarn build:backend` must produce a `packages/backend/dist` folder that contains every file the backend needs to run. Fix the build script `scripts/build.js` so that the folder is complete, then run the build.

4. The built backend must run alone, without the `src` folder, from `/opt/portal`:

   ```sh
   node packages/backend/dist/index.js --config app-config.yaml --config app-config.production.yaml
   ```

   It must report `"environment":"production"` in its health check.

Do not delete or move any source file. Stop any process you start before you submit: the grader starts its own backend on port `7007`.

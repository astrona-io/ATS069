# Question

Solve this question on: `terminal`

The `starfleet` platform team hands the `portal` workspace in `/opt/portal` to a new maintainer. The team needs four things: a backend that starts from source, an app development server on port `3000`, a browser configuration without secrets, and one command that builds both packages into artifacts that run alone. The workspace is a small stand-in with the shape of a Backstage project. It is not a real Backstage application, and its scripts are simplified.

1. `yarn workspace backend start` must start the backend and answer `http://localhost:7007/healthcheck`. Today it cannot find its configuration file.

2. `yarn workspace app start` must serve the app on `http://localhost:3000`. The app takes its port from `app.baseUrl`.

3. The app sends everything under the `app` block of the configuration to the browser through `/config.json`. The GitHub token `ghp_example_token` must not be browser-visible. Keep the token available to the backend under `backend.githubToken`.

4. `yarn build:all` must build every workspace. After it runs, `packages/app/dist` and `packages/backend/dist` must both exist. The file `packages/app/dist/config.json` must not contain the token.

5. Both artifacts must run alone, without the `src` folders:

   ```sh
   node packages/backend/dist/index.js --config app-config.yaml --config app-config.production.yaml
   node packages/app/dist/server.js
   ```

   The backend must report `"environment":"production"` in its health check, and the app must serve `/config.json` for `http://localhost:3000`.

Do not delete or move any source file. Stop any process you start before you submit: the grader starts its own processes on ports `3000` and `7007`.

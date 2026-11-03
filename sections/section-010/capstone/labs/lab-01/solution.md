# Solution

Work in `/opt/portal`. Use `astrona submit` after each step.

## 1. Fix the backend start script

Run the backend and read the error:

```sh
yarn workspace backend start
```

Yarn runs a package script with the package directory as the working directory, so `--config app-config.yaml` points inside `packages/backend`. In `packages/backend/package.json`, use the file at the repository root:

```json
"start": "node src/index.js --config ../../app-config.yaml",
```

Run it again and check `curl http://localhost:7007/healthcheck` from a second terminal. Stop the backend with Ctrl+C.

## 2. Fix the app port

Start the app with `yarn workspace app start` and read the line it prints. The app server takes its port from `app.baseUrl`, and the file sets `http://localhost:3001`. Change it to `http://localhost:3000` in `app-config.yaml`.

## 3. Move the secret to the backend

Request the browser configuration while the app runs:

```sh
curl http://localhost:3000/config.json
```

The response contains `githubToken`, because the key sits under `app`. Move it to the backend block, which the browser never receives:

```yaml
app:
  baseUrl: http://localhost:3000
backend:
  baseUrl: http://localhost:7007
  listen:
    port: 7007
  githubToken: ghp_example_token
```

Request `/config.json` again. The token is gone. Stop the app.

## 4. Build every workspace

The root script `build:all` runs `yarn workspace backend build`, so the app is never built. Change it to run the `build` script of every workspace:

```json
"build:all": "yarn workspaces foreach --all run build"
```

Run `yarn build:all`. Both `packages/app/dist` and `packages/backend/dist` now exist. The app build writes `dist/config.json` from the configuration files, so the token is not in it because step 3 came first.

## 5. Run the artifacts alone

```sh
node packages/backend/dist/index.js --config app-config.yaml --config app-config.production.yaml
node packages/app/dist/server.js
```

Run each in its own terminal and request `/healthcheck` on port `7007` and `/config.json` on port `3000`. The first answer contains `"environment":"production"`.

## Why the order matters

The browser configuration is generated at build time. A build made before the secret was moved still contains it, so the secret fix must come before the final build. A running development server hid this problem because it reads the configuration on every start, while the artifact keeps the values it was built with.

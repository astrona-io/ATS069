# Solution

Work in `/opt/portal`. Use `astrona submit` after each step to see which check passes.

## 1. Fix the configuration path

Start the backend the way the project does:

```sh
cd /opt/portal
yarn workspace backend start
```

The process exits at once. It prints that it failed to read a configuration file, so look at the script it runs:

```sh
grep '"start"' packages/backend/package.json
```

Yarn runs a workspace script with the package directory as the working directory. The value `app-config.yaml` therefore points at `packages/backend/app-config.yaml`, which does not exist. Change the script to use the file two directories up:

```json
"start": "node src/index.js --config ../../app-config.yaml",
```

## 2. Add the missing value

Run the start command again. The backend now reads the file and prints `Error: Missing required config value at 'backend.listen.port'`. Open `app-config.yaml` and add a `listen` block under `backend`:

```yaml
backend:
  baseUrl: http://localhost:7007
  listen:
    port: 7007
```

Start the backend again and, in a second terminal, check it:

```sh
curl http://localhost:7007/healthcheck
```

The health check returns `status` `ok`. Stop the backend with Ctrl+C.

## 3. Fix the build script

Build the backend and list the output:

```sh
yarn build:backend
ls packages/backend/dist
```

Only `index.js` was copied. The backend needs `config.js` as well, so a built copy cannot start. In `scripts/build.js`, replace the loop that copies one file with a copy of the whole `src` directory:

```js
fs.cpSync(src, dist, { recursive: true });
```

Build again with `yarn build:backend` and list `packages/backend/dist`. It now holds `index.js` and `config.js`.

## 4. Run the build alone

Run the artifact with both configuration files. The second file is loaded last, so its `environment` value wins:

```sh
node packages/backend/dist/index.js --config app-config.yaml --config app-config.production.yaml
```

In a second terminal run `curl http://localhost:7007/healthcheck`. The response contains `"environment":"production"`. Stop the process with Ctrl+C.

## Why each fix works

The first fault was a path that was right from one directory and wrong from another. The second was a missing value that the backend checks before it listens. The third was a build that left out a runtime file, which a development server hides because it reads the source folder. Each problem belongs to a different startup contract, and each one showed up only after the earlier one was fixed.

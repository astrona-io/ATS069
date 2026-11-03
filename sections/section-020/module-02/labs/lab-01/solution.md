# Solution

Open a shell in the lab and change to the workspace with `cd /opt/portal`. `astrona submit` grades the whole task.

## 1. Make the plugin a workspace

```sh
yarn workspaces list
```

The list shows the root, `packages/app` and `packages/backend`, but not the plugins. Open the root `package.json` and change the `workspaces` field to `["packages/*", "plugins/*"]`. Install again so that Yarn links the packages:

```sh
yarn install
yarn workspaces list
```

## 2. Fix the plugin id

The route prefix is `/api/` followed by the plugin id. Run the tests and read the failure:

```sh
yarn test
```

The first test expects the id `hello`. Open `plugins/hello-backend/src/plugin.ts` and change `id: 'hello-backend'` to `id: 'hello'`.

## 3. Add the plugin to the backend

Open `packages/backend/src/index.ts`. The file imports `helloBackendPlugin` but never uses it. Add this line before `backend.start(...)`:

```ts
backend.add(helloBackendPlugin);
```

## 4. Declare the dependency

Open `packages/backend/package.json` and add:

```json
"dependencies": {
  "@internal/plugin-hello-backend": "workspace:^"
}
```

Run `yarn install` so that the lockfile records the link.

## 5. Check the route

```sh
yarn start
```

In a second shell, run `curl -i http://127.0.0.1:7007/api/hello/greeting`. The status line shows 200 and the body holds the greeting. Stop the backend with `Ctrl+C`, then run `astrona submit`.

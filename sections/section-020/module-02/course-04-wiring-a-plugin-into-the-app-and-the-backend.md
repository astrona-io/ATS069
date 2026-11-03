---
draft: true
exam_objectives:
- Understand local development workflows
---
# Wiring A Plugin Into The App And The Backend

A plugin that runs alone is not yet part of the portal. The app and the backend are separate packages, and neither one loads a plugin it has not been told about. This part lists the steps that connect a plugin, and the symptom of each missing step.

## Step one: the package must be in the workspace

Yarn must know the plugin package. The folder has to match a pattern in the `workspaces` field of the root `package.json`. Without a match, the next steps cannot find the package. Check it with:

```sh
cd /opt/portal
yarn workspaces list
```

## Step two: declare the dependency

A package may import only packages that it declares in its own `package.json`. The backend must declare the backend plugin, and the app must declare the frontend plugin. In a generated project you run `yarn --cwd packages/backend add @internal/plugin-hello-backend`. For a package that is inside the same workspace, Yarn writes the version as `workspace:^`, which means "use the package from this repository". Open the file and look:

```sh
cat packages/backend/package.json
```

After you change a `package.json`, run `yarn install`. Yarn then records the link in the lockfile. If the declaration is missing, the import works only by luck of the folder layout, and a clean install or a build in a container fails.

## Step three: load the plugin in the backend

In the new backend system, the file `packages/backend/src/index.ts` creates the backend and adds each plugin with `backend.add`. A typical line is `backend.add(import('@internal/plugin-hello-backend'));`. The playground file uses a plain function call, with the same meaning:

```sh
cat packages/backend/src/index.ts
```

The file calls `backend.add(helloBackendPlugin)` before `backend.start`. Remove that line, start the backend with `yarn start`, and request `/api/hello/greeting`. The answer is 404, although the plugin code is correct and the tests pass. Add the line again and the route answers.

## Step four: load the plugin in the app

A frontend plugin must be loaded by the app too. In the older frontend system, the developer imports the plugin page in `packages/app/src/App.tsx` and adds a `Route` element, for example `<Route path="/hello" element={<HelloPage />} />`, and often a sidebar item. In the newer frontend system, the app can discover installed plugin packages from its dependencies when the configuration key `app.packages` is set to `all`. In both cases the app package must declare the plugin as a dependency.

The playground app keeps the list in `packages/app/src/plugins.ts`. It lists `helloPlugin`, and the app requests the backend route of each listed plugin. A plugin that is not in the list never renders and never calls its route.

## Step five: configuration and permissions

Some plugins read their own keys from `app-config.yaml`, for example the URL of an outside system. The plugin shows an error at start or at first request when a required key is missing. Plugins that need a secret read it from an environment reference such as `${NAME}` in the file, and the value comes from the environment of the process.

## Checking the whole chain

Check the chain from the outside, not from the plugin folder. Start the backend from the root and request the route that the app calls. A status 200 proves that the workspace, the dependency and the `backend.add` call are all correct. A 404 means one of them is not. The type check and the tests give no answer here, because they never start the backend.

## What this part showed

You saw the steps that connect a plugin: the workspace, the declared dependency, the load call in the backend, the load step in the app and the configuration. Each missing step has a different symptom, and only a request through the real backend checks them together.

## Common pitfalls

> [!WARNING]
> Do not add a plugin to the backend and skip the `package.json` dependency: it can work on your machine and fail in a clean build. Do not run `yarn install` only in a plugin folder and expect the root to change. A plugin that is added to the backend but not to the app, or the other way round, gives a half-working feature, so test both sides.

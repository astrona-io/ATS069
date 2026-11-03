---
draft: true
exam_objectives:
- Understand local development workflows
---
# Backend Plugins And Their Routes

The browser cannot read the software catalog or a database directly. It sends a request to the backend, and a backend plugin answers. This part explains how one backend plugin owns a group of routes, and why its id matters more than its folder or package name.

## One plugin, one route prefix

The Backstage backend is one Node.js process that loads many backend plugins. Each plugin has an id. The backend mounts the router of a plugin under the path `/api/<plugin id>`. A plugin with the id `catalog` answers under `/api/catalog`, and a plugin with the id `hello` answers under `/api/hello`. Two plugins cannot share one id in one backend.

A real backend plugin is created with `createBackendPlugin`, which takes the `pluginId` and a `register` function. Inside `register`, the plugin declares which services it needs, such as the HTTP router, and in an `init` function it adds its routes. The playground uses a simpler object with an `id` and a `handle` function, so you can read the whole mechanism in a few lines.

## Reading the playground backend plugin

```sh
cd /opt/portal
cat plugins/hello-backend/src/plugin.ts
```

The plugin has the id `hello`. Its `handle` function receives the part of the path that comes after the prefix. It answers `/greeting` with status 200 and a JSON body, and it returns nothing for any other path. When a plugin returns nothing, the backend continues and finally answers 404.

Start the backend and request the route:

```sh
yarn start
```

In a second shell:

```sh
curl -i http://127.0.0.1:7007/api/hello/greeting
curl -i http://127.0.0.1:7007/api/hello/other
```

The first request answers with the status line `HTTP/1.1 200 OK` and a JSON body with the greeting. The second answers with 404, because the plugin does not handle `/other`. Stop the backend with `Ctrl+C`.

## Running only one backend plugin

A generated backend plugin has a `dev/index.ts` file that uses a test backend. It loads only the plugin and a few mock services, so the plugin can start without a database server or other plugins. The `start` script of the plugin package runs it. In the playground it listens on port 7008:

```sh
cd plugins/hello-backend
yarn start
```

From a second shell, `curl http://127.0.0.1:7008/api/hello/greeting` gives the same answer as before. The prefix is the same, because the prefix comes from the plugin id and not from the port. Stop the process with `Ctrl+C`.

## The id is the contract

The frontend code calls `/api/hello/greeting`. That path is a contract between the browser code and the backend plugin. If a developer changes the plugin id to `hello-world`, the plugin moves to `/api/hello-world`, and the old path answers 404. Nothing else changes: the tests of the route still pass, because they call the plugin directly. Only a request through the backend reveals the problem.

Try it. Change the id, start the backend, and request the old path:

```sh
cd /opt/portal
sed -i "s/id: 'hello'/id: 'hello-world'/" plugins/hello-backend/src/plugin.ts
```

The test `the plugin id is hello` now fails when you run `yarn test`, which shows why a test that pins the id is useful. Restore the file with `git checkout plugins/hello-backend/src/plugin.ts`.

## What this part showed

You saw that a backend plugin answers under `/api/<plugin id>`, that a path the plugin does not handle ends in 404, that a plugin can run alone from its `dev/` entry point, and that the id is a contract with the code that calls it. The remaining question is how the app and the backend find a new plugin at all.

## Common pitfalls

> [!WARNING]
> Do not rename a plugin id without searching for the old path in the frontend code and the configuration. Do not use the port to tell plugins apart: all plugins in the backend share one port. A 404 from the backend can mean a wrong id, a plugin that was never added, or a path the plugin does not handle, and the three need different fixes.

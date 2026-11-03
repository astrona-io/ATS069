---
draft: true
exam_objectives:
- Understand local development workflows
---
# Creating A Plugin With yarn new

A team that adds a feature to a Backstage portal usually adds it as a plugin: a package that holds the code of one feature. Writing the package files by hand is slow and easy to get wrong, so Backstage provides a generator. This part shows what the generator creates and where the new package lives in the repository.

## Plugins are packages in the workspace

A Backstage plugin is an npm package. A frontend plugin adds pages or cards to the browser interface. A backend plugin adds routes and background work to the server. In a generated Backstage project, plugin packages live in the `plugins/` folder. The root `package.json` lists `packages/*` and `plugins/*` in its `workspaces` field, so Yarn treats each plugin as a workspace and links it to the other packages.

<!-- astrona:playground:renew -->

Open the playground and look at the workspace:

```sh
cd /opt/portal
yarn workspaces list
```

The list names the root, the two packages `packages/app` and `packages/backend`, and the two plugins `plugins/hello` and `plugins/hello-backend`. The names of the plugins start with `@internal/plugin-`. The scope `@internal` is the default prefix that `yarn new` gives to plugins that belong to one organization and are not published.

## What yarn new does

In a Backstage project, `yarn new` is a script in the root `package.json` that runs `backstage-cli new`. The command is interactive. It asks what you want to create, and the choices include a frontend plugin, a backend plugin, a backend plugin module, and several kinds of library package. It then asks for the plugin id, which is a short lowercase name such as `orders`.

For a frontend plugin the command creates `plugins/<id>`. For a backend plugin it creates `plugins/<id>-backend`. It writes a `package.json`, a `src/` folder with the plugin definition and an example component or router, a test, and a `dev/` folder with a development entry point. It also installs the new package into the workspace, so it is ready to run.

The playground has a small script with the same name. It creates only a backend plugin and only three files. Run it:

```sh
yarn new orders
git status --short
```

The script prints `created plugins/orders-backend`, and `git status` shows the new folder. The folder holds a `package.json` with the name `@internal/plugin-orders-backend`, a `src/plugin.ts` file with the plugin id `orders`, and nothing else. The real generator writes more files, but the names follow the same pattern.

## The generated package.json

Open the file of an existing plugin:

```sh
cat plugins/hello-backend/package.json
```

The `name` field is the identity of the package. Other packages use it to import the plugin and to declare a dependency on it. The `version` is `0.1.0` and `private` is `true`, which stops anyone from publishing the package by accident. The `scripts` field has a `start` script. That script runs the plugin alone, which the next part explains.

A package is only a workspace when its folder matches a pattern in the `workspaces` field. If the root file listed only `packages/*`, the folder `plugins/orders-backend` would exist but Yarn would not know it, and `yarn workspaces list` would not show it.

## The plugin id

Every plugin has an id. The frontend and the backend use the id to name the plugin in routes, in configuration and in logs. The backend plugin in the playground has the id `hello`, set in `plugins/hello-backend/src/plugin.ts`. The package name contains the id, and the folder name contains the id, but only the value in the source file decides the route. A mismatch between the three is allowed, and it is a common source of confusion.

## What this part showed

You saw that a plugin is a workspace package in the `plugins/` folder, that `yarn new` creates the package with a name, a source folder and a development entry point, and that the plugin id lives in the source. The open question is how to see the plugin run while you write it, before the app and the backend know about it. The next part answers that.

## Common pitfalls

> [!WARNING]
> Do not create a plugin folder by hand and forget the `workspaces` pattern: Yarn ignores a folder that no pattern matches. Do not assume the package name and the plugin id are the same value. If `yarn new` is not defined in a project, the root `package.json` does not have the script, and the project may use another generator.

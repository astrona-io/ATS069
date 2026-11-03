---
draft: true
exam_objectives:
- Build and run Backstage projects locally
---
# Package Roles And The Workspace Layout

The same command, `backstage-cli package build`, must compile a browser application, a Node.js backend and a shared library differently. The tool cannot guess which one a package is. This part explains the field that tells it, the roles that exist, and how the workspaces field decides which folders belong to the project.

A package declares its role in its own `package.json`, in a `backstage` object with a `role` field. The role is a fixed name. It tells `backstage-cli` how to build, start and publish the package. It also lets the tool check that dependencies point in an allowed direction, for example that a frontend package does not depend on a backend package.

<!-- astrona:playground:renew -->

Print the role of every package in the playground workspace:

```sh
cd /opt/scaffold
for f in packages/*/package.json plugins/*/package.json; do
  node -p "const p = require('./' + process.argv[1]); p.name + ' -> ' + p.backstage.role" "$f"
done
```

The loop prints one line per package, with the package name and its role. The roles in this workspace are `frontend`, `backend`, `frontend-plugin` and `backend-plugin`.

## The roles

Backstage defines a small set of roles. Each belongs to one of three groups.

- Applications: `frontend` is a browser application, and `backend` is a backend process. Both are leaves, and nothing depends on them.
- Plugins: `frontend-plugin` and `backend-plugin` are features that an application loads. `frontend-plugin-module` and `backend-plugin-module` extend a plugin from another package.
- Libraries: `web-library` runs in the browser only, `node-library` runs in Node.js only, and `common-library` runs in both. The role `cli` is for command-line tools.

A role is not a name that a team picks. A missing or misspelled role makes the CLI refuse to build the package, because it cannot choose a build method.

## The workspaces field

The workspaces field in the root `package.json` lists glob patterns. A glob pattern is a path with a wildcard, such as `plugins/*`, that matches many folders. Yarn treats each matched folder that has a `package.json` as a workspace. Packages in different workspaces can depend on each other by name, and Yarn links them instead of downloading them from the registry.

```sh
yarn workspaces list
```

The output lists the root and each workspace with its folder. A package folder that no pattern matches is invisible to Yarn and to `repo` commands. That is the usual reason a new plugin "does not build": it was created in a folder that the field does not list. The generated project lists `packages/*` and `plugins/*`.

## How the tool uses the layout

`backstage-cli repo build --all` reads the workspaces, reads the role of every package, and builds each one with the method of its role. `backstage-cli new` places a new package in `plugins` for a plugin and in `packages` for other packages, and sets the role from the template. A developer who creates a package by hand must set both the role and a matching workspace pattern.

## Common pitfalls

> [!WARNING]
> A package with the wrong role builds the wrong way or fails to build. Do not put a backend dependency into a `frontend-plugin` package, because the build tool checks dependency directions. When a plugin folder is missing from `yarn workspaces list`, check the patterns in the `workspaces` field before you check the plugin code.

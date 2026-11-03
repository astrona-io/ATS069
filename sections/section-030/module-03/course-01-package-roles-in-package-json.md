---
draft: true
exam_objectives:
- Compile a Backstage project with TypeScript
---
# Package Roles In package.json

A Backstage repository holds very different packages: a React app that runs in the browser, a backend that runs on a server, plugins for both, and libraries that other packages import. A browser bundle and a Node.js server process need different builds, different start commands and different lint rules. The tooling has to know what each package is. A package tells it with one field in `package.json`, the role. This part explains the field, the values it takes and what the tooling does with it.

A package manifest is the `package.json` file of one package. It names the package, its version, its dependencies, its scripts and its entry points. Backstage adds a `backstage` field to it. The field `backstage.role` names the role of the package, and the command-line tool `backstage-cli` reads it to choose how to build, start, lint and test that package.

## The roles

A role says two things: where the code runs, and whether the package is an application or a part that others use. The common values are these.

- `frontend` is the app that runs in the browser and is bundled into static files.
- `backend` is the backend process that runs on Node.js and is bundled for deployment.
- `cli` is a command-line tool.
- `web-library` is a library for code that runs in the browser.
- `node-library` is a library for code that runs on Node.js.
- `common-library` is a library that can run in both places, such as shared types and helper functions.
- `frontend-plugin` and `frontend-plugin-module` are a browser plugin and an extension of one.
- `backend-plugin` and `backend-plugin-module` are a backend plugin and an extension of one.

The names follow the place where the code runs. This matters in practice. A `common-library` must not import a Node.js-only module, because the browser cannot load it. A `backend-plugin` must not import a React component. The role records the intent, and the tooling checks and builds according to it.

## Seeing the roles of a workspace

The playground has four packages with roles. A short script reads every manifest and prints the name and the role.

<!-- astrona:playground:renew -->

```sh
cd /opt/portal
node scripts/list-roles.mjs
```

The output has one line per package: the package name, a tab and the role. The `app` package is `frontend`, the `backend` package is `backend`, `@portal/deploy-common` is `common-library` and `@portal/deploy-backend` is `backend-plugin`. Look at one manifest to see the field in place:

```sh
cat plugins/deploy-backend/package.json
```

The `backstage` field holds `"role": "backend-plugin"`. Next to it are `main`, which names the entry file of the package, `files`, which lists what a published package contains, and a `scripts` object with a `build` script. The playground has no `backstage-cli`, so its build script is a stand-in for that command. In a real repository the script is `backstage-cli package build`, and that command reads the role.

## What the tooling does with a role

The role selects behavior in several commands. `backstage-cli package build` picks the build: a bundle for the frontend, a bundled server for the backend and a library build for the libraries. `backstage-cli package start` picks how to run the package for development. Lint and test commands pick the right rules and environment. A repository command, `backstage-cli repo build`, loops over the packages and uses each role to decide what to build.

A package without a role breaks this chain. The tooling cannot tell which build to run, so it reports an error or skips the package. Remove the role from a copy to see what is missing. Run the script after removing the `backstage` field from the `app` manifest:

```sh
cp packages/app/package.json /tmp/app-package.json
node -e "const f='packages/app/package.json';const m=JSON.parse(require('fs').readFileSync(f));delete m.backstage;require('fs').writeFileSync(f,JSON.stringify(m,null,2))"
node scripts/list-roles.mjs
cp /tmp/app-package.json packages/app/package.json
```

The line for `app` now shows `(no role)`, and the last command restores the file. In a real repository the same gap shows up as a failed build or a missing entry in a build report.

## Roles and the package layout

The role also fits a convention for where a package lives. The app and the backend sit in `packages/`. Plugins sit in `plugins/`, and a plugin is often split into several packages, for example a frontend plugin, a backend plugin and a common library that holds their shared types. The playground uses the same layout, with `deploy-common` shared by the others. Each package has its own role, so each one gets the build that suits it.

This part showed that one field tells the tooling what a package is and that a package without it cannot be built correctly. The open question is what the build of a package actually does to the TypeScript source, and whether it checks the types.

## Common pitfalls

> [!WARNING]
> Do not leave a role out or guess it: a wrong role gives the package the wrong build or the wrong rules. A library that both sides import is a `common-library` only if it uses no Node.js-only and no browser-only API. The role does not install anything and does not check imports by itself, so it records intent for the tools.

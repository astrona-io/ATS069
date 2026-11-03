---
draft: true
exam_objectives:
- Understand local development workflows
---
# Tracing A Change Through The Workspace

A developer opens a ticket that says: "Show a warning on the catalog page when a service has no owner." The user sees one new warning. The change behind it can touch a shared type, a function in the browser code and a configuration key. This part shows how to find every package a change touches, before any check runs, so the right checks run later.

## One repository, several packages

A Backstage project is a monorepo: one Git repository that holds many packages. Yarn manages them as a workspace. A workspace is a set of packages in one repository that share one dependency installation and one lockfile. The root `package.json` lists the packages in its `workspaces` field, for example `"workspaces": ["packages/*"]`. Yarn is the package manager, the tool that downloads dependencies and links the packages to each other.

The practice workspace in `/opt/portal` has three packages. The package `app` holds code that runs in the browser. The package `backend` holds a small HTTP server that runs on the machine. The package `catalog-common` holds types that both of them use. A generated Backstage project has the same split, and it adds plugin packages under `plugins/`.

<!-- astrona:playground:renew -->

Yarn can list the packages it manages. Run this in the workspace:

```sh
cd /opt/portal
yarn workspaces list
```

The output names the root and the three packages with their directories. If a package is missing from the list, the `workspaces` field does not match its directory, and no check or build that uses the workspace will include it.

## A contract is a promise between two files

Counting edited files does not tell you how large a change is. A better measure is how many contracts the change touches. A contract is something one piece of code promises and another piece of code depends on. A TypeScript type is a contract between the code that produces a value and the code that reads it. An HTTP route is a contract between the backend and the browser. A configuration key is a contract between the person who deploys the software and the code that reads the key.

In the owner warning example the contract is the `Entity` type in `catalog-common`. It says that an owner, when it exists, lives at `spec.owner`. The `app` package reads it. If the app reads `entity.owner` instead, the code disagrees with the contract. The disagreement is not in the file that was edited last. It is between two files that were never opened together.

Run this to see which packages import the shared type:

```sh
grep -rn "catalog-common" packages/*/src
```

Each match is a place where the contract is used. A change to the type must be checked in every one of them.

## Three states, not two

The warning must tell two situations apart. In the first, the catalog answered and the entity has no owner. This is a normal condition. The warning says "this service has no owner". In the second, the catalog request failed, so no entity arrived. The warning should say that the data could not be loaded.

The function `ownerState` in `packages/app/src/ownerWarning.ts` makes that decision. It returns one of three values: `owned`, `missing` or `error`. A function that returned only "ok" or "error" would show the user a wrong message for every service without an owner. The three results are a contract with the user interface, and a test later pins them.

Open the function and read it:

```sh
cat packages/app/src/ownerWarning.ts
```

The function returns `error` only when there is no entity. It returns `missing` when the entity exists but has no `spec.owner`.

## Follow the data across the process boundary

The browser code and the backend run as separate processes. In development, `yarn start` starts the backend (and in a generated Backstage project, also the frontend development server on port 3000, with the backend on port 7007). A request from the browser to the backend crosses a network boundary. A type error in the browser code does not stop the backend, and a crash in the backend does not stop the browser from rendering.

This has a practical effect on diagnosis. If the card shows "request failed", look at the backend route, its status code and its log. If the card does not render at all, look at the browser code and its compile error. Rebuilding the frontend will not fix a backend route that returns an error.

In the playground, start the backend and call its health route from a second shell:

```sh
yarn start
```

Leave it running. In a second shell on the same machine, run `curl http://127.0.0.1:7007/api/health`. The backend answers with a JSON body that holds the status `ok`. Press `Ctrl+C` in the first shell to stop it.

## Decide which checks the change needs

Write down the contracts the change touches, then pick the checks. A change to a shared type needs the type check in every package that imports it. A change to the logic of `ownerState` needs a behavior test. A change to a configuration key needs a look at the files that define it. A change that adds an import needs a look at the package that declares the dependency.

A short table helps:

| Change | Contract | Check that answers it |
| --- | --- | --- |
| Rename a field in `catalog-common` | Shared type | `yarn tsc` for the whole workspace |
| Change when `missing` is returned | Behavior of `ownerState` | A test that names each of the three results |
| Add the key `catalog.ownerWarning.enabled` | Configuration | Check that the key is in the shared file |
| Add an import from a new package | Declared dependency | Review of `package.json` and the lockfile |

The next part explains what each of these checks proves and what it cannot prove.

## Use Git to see the real size of a change

Git records what changed against the last commit. `git status` lists the files. `git diff` shows the lines. The practice workspace has one commit, so every edit you make shows up. The package name in each path (`packages/app`, `packages/backend`, `packages/catalog-common`) tells you which workspaces the change reaches.

```sh
git status --short
git diff --stat
```

A reviewer reads the same list. If it contains a package you did not mean to touch, such as a generated file or an unrelated package, you find out before the review does. A change that is easy to describe in one sentence usually touches few contracts. A change that needs a long list of packages deserves a short explanation of why each one is there.

## What this part showed

You saw that a Backstage project is a workspace of packages, that a change is measured by the contracts it touches, and that the browser code and the backend are separate processes. You also saw how `git status` shows the packages a change reaches. The open question is how to get fast, trustworthy feedback on those contracts while you work, which the next part answers.

## Common pitfalls

> [!WARNING]
> Do not judge a change by the number of files. A one-line edit to a shared type can break every package that imports it. Do not assume that a rendering page means the backend works, or that a working backend means the page renders: they are separate processes with a network boundary between them. If a package is missing from `yarn workspaces list`, no workspace-wide command will include it.

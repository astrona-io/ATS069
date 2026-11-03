---
draft: true
exam_objectives:
- Build and run Backstage projects locally
---
# The Backstage CLI Commands

A generated project contains almost no build logic of its own. The scripts in each `package.json` call a command-line tool, and that tool decides how to compile, serve, lint and test. This part lists the commands a developer meets most often and says what each one does, so that a script name in a project is never a mystery.

The tool is the package `@backstage/cli`, and its executable is `backstage-cli`. A command-line interface (CLI) is a program that a user controls by typing commands. Yarn runs the executables of installed packages, so a developer calls the tool as `yarn backstage-cli <command>`. The commands fall into two groups. The `package` commands work on one package, and the `repo` commands work on all packages in the repository.

<!-- astrona:playground:renew -->

In the playground, read how the scripts name the commands:

```sh
cd /opt/scaffold
grep -n "backstage-cli" package.json packages/backend/package.json
```

The output lists the root scripts `build:all`, `lint`, `test` and `new` and the four package scripts of the backend. The tool itself is not installed in the playground, so these lines are only read.

## Package commands

A package command runs inside one package folder, and the package script that calls it runs from that folder.

- `backstage-cli package start` starts the package for development. For a frontend package it starts a development server. For a backend package it runs the entry point and restarts the process when a file changes.
- `backstage-cli package build` builds the package for the role the package declares. A backend build creates a `dist` folder with the compiled code. A frontend build creates the static files for the browser.
- `backstage-cli package lint` runs the linter, which reports code style and likely mistakes.
- `backstage-cli package test` runs the unit tests with the Jest test runner.
- `backstage-cli package clean` removes the build output of the package.
- `backstage-cli package prepack` and `postpack` prepare a package for publishing to a registry.

## Repository commands

A repository command works on every package in the workspace, so it is run once from the root.

- `backstage-cli repo build --all` builds all packages. Without `--all` it builds only the packages that a package depends on.
- `backstage-cli repo lint` and `backstage-cli repo test` run the linter and the tests for all packages. The option `--since <branch>` limits the run to packages that changed against a branch.
- `backstage-cli repo clean` removes the build output of every package.

The root script `build:all` in the playground calls `backstage-cli repo build --all`. A developer who reads the script knows that it builds the whole repository, not one package.

## Commands for the project itself

Some commands change the repository, not a build result.

- `backstage-cli new` creates a new package, such as a plugin, from a template, and adds it to the workspaces.
- `backstage-cli versions:bump` upgrades the Backstage packages in the project to a release. The next parts explain the version record that it updates.
- `backstage-cli config:print` prints the merged configuration, and `backstage-cli config:check` checks it against the schemas of the installed packages. Both take `--config` options like the processes do.

```sh
yarn backstage-cli config:print --config app-config.yaml
```

This command needs the installed tool. In a real project it prints the configuration after merging all files that the options name. It is the fastest way to see which value a process will read.

## Choosing the right command

When a script fails, a developer can read it, name the command and decide the scope. A failing `package build` points at one package. A failing `repo build --all` can point at any package, so the output names the package that failed first. A configuration error is better checked with `config:check` than with a full start.

## Common pitfalls

> [!WARNING]
> A script name such as `dev` or `build:all` is defined by the project, not by Backstage in general, so read it before you rely on it. Do not run `repo clean` and then expect a development server to start without a build of its dependencies. Always run the commands from the repository root unless a script says otherwise, because Yarn resolves the workspaces from there.

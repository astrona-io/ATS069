# Overview: Yarn Workflows (Playground)

This is a playground, not a lab. It starts an Ubuntu virtual machine and waits. There is no task, no `astrona submit` and no pass or fail. Edit files, break the install, run `astrona destroy` and start again.

## What is in the box

- Node.js 22 and Yarn 4.4.1.
- `/opt/portal`, a Yarn workspace with the packages `app`, `backend` and `@internal/shared`. Each package has `lint` and `build` scripts that print one line. The root has the scripts `lint:all` and `build:all`.
- `backstage.json` with the version `1.30.0`. The project has no Backstage packages.

## Practice tasks

- Run `yarn --version`, `yarn config get nodeLinker` and `yarn config get cacheFolder`.
- Run `yarn workspace backend add semver`, then read the changes in `packages/backend/package.json` and `yarn.lock`.
- Add a development dependency to `app` with `yarn workspace app add --dev semver` and compare the field with the one in `backend`.
- Run `yarn workspaces foreach -A run lint`, then add `--topological` and `--verbose` to a build run and compare the output.
- Run `yarn workspaces foreach -A --include 'packages/b*' run lint` and say which workspace ran.
- Remove `semver` again with `yarn workspace backend remove semver` and run `yarn install --immutable`.

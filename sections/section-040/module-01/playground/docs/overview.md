# Overview: Package Managers And Lockfiles (Playground)

This is a playground, not a lab. It starts an Ubuntu virtual machine and waits. There is no task, no `astrona submit` and no pass or fail. Edit manifests, break the install, run `astrona destroy` and start again.

## What is in the box

- Node.js 22, npm and Yarn 4.4.1.
- `/opt/portal`, a Yarn workspace with the packages `app`, `backend` and `@internal/shared`. Its `yarn.lock` is committed state and its `.yarnrc.yml` uses `nodeLinker: node-modules`. The `backend` package imports `semver` but does not declare it.
- `/opt/npm-demo`, a small npm project with a `package-lock.json`.

## Practice tasks

- Run `yarn install --immutable` in `/opt/portal`, then add a dependency range to a manifest by hand and run it again. Read the first error line.
- Run `yarn why semver` and `yarn workspaces list`. Find every package that causes `semver` to be installed.
- Declare `semver` in the backend with `yarn workspace backend add semver` and read the diff of the manifest and of `yarn.lock`.
- Add a `resolutions` entry to the root manifest and find out how the number of `semver` releases in `yarn.lock` changes.
- Run `npm ci` in `/opt/npm-demo`, change a range in its `package.json` and run `npm ci` again.
- Change `@internal/shared` in `packages/app/package.json` to `^2.0.0` and read what `yarn install` reports.

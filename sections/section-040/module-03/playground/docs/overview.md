# Overview: Upgrades, Audits And Registries (Playground)

This is a playground, not a lab. It starts an Ubuntu virtual machine and waits. There is no task, no `astrona submit` and no pass or fail. Edit files, break the install, run `astrona destroy` and start again.

## What is in the box

- Node.js 22 and Yarn 4.4.1.
- `/opt/portal`, a Yarn workspace with `app`, `backend`, `@internal/shared` and `@internal/plugin`. The plugin declares `@internal/shared` as a peer dependency. The backend depends on `semver`.
- `.yarnrc.yml` routes the scope `internal` to `https://npm.internal.example.com` and reads the token from `NPM_TOKEN`. That server does not exist, and no package needs it, because the internal packages are local.
- `backstage.json` with the version `1.30.0`. The project has no Backstage packages, so the bump command is only read about.

## Practice tasks

- Run `yarn why semver` and `yarn why -R semver`.
- Run `yarn dedupe --check` and read the exit code.
- Add a `resolutions` entry for `semver` to the root manifest, run `yarn install` and read the diff of `yarn.lock`.
- Run `yarn explain peer-requirements`, then remove the `peerDependencies` entry of the plugin and run it again.
- Run `yarn config get npmScopes` and `yarn config get npmRegistryServer`.
- Remove `@internal/shared` from `packages/app/package.json`, run `yarn install` and read the peer warning.

# Question

Solve this question on: `terminal`

The portal team keeps its workspace in `/opt/portal`. The backend imports the `semver` library, but only the root `package.json` declares it. The team also wants one command that runs the `lint` script of every workspace.

The workspace has three packages: `app`, `backend` and `@internal/shared`. Each one has a `lint` script.

1. Remove `semver` from the root `package.json`. A dependency of the backend belongs in the backend manifest.

2. Declare `semver` under `dependencies` in the manifest of the `backend` workspace. Use a Yarn command that targets the workspace by name.

3. Add a script named `lint:all` to the root `package.json`. It must use `yarn workspaces foreach` to run the `lint` script in all workspaces, and `yarn run lint:all` must exit with code 0.

4. Make sure that `yarn.lock` records the change, and confirm with `yarn install --immutable`.

Keep Yarn as the package manager. Do not change `backstage.json`, do not add a `package-lock.json` file and do not remove `nodeLinker: node-modules` from `.yarnrc.yml`.

Use `astrona ssh` to open a shell in the lab. The project is in `/opt/portal`.

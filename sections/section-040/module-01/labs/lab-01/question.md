# Question

Solve this question on: `terminal`

The portal team keeps its workspace in `/opt/portal`. Its build server runs `yarn install --immutable` and the build fails. Make the install reproducible without changing the package manager.

The workspace has three packages: `app`, `backend` and `@internal/shared`. The shared package is local and has version `1.0.0`.

1. The `app` package must depend on the local `@internal/shared` package. Fix its range so that the local package satisfies it. Do not change the version of `@internal/shared`.

2. The `backend` source imports `@internal/shared`, but the backend manifest does not declare it. Declare it in the backend manifest, under `dependencies`.

3. Update `yarn.lock` with a plain `yarn install` so that it records both changes. Then confirm with `yarn install --immutable` that the lockfile and the manifests agree.

Keep Yarn as the package manager. Do not add a `package-lock.json` file, and do not remove `nodeLinker: node-modules` from `.yarnrc.yml`.

Use `astrona ssh` to open a shell in the lab. The project is in `/opt/portal`.

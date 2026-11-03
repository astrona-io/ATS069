# Question

Solve this question on: `terminal`

The portal team's continuous integration (CI) job must install the workspace in `/opt/portal` exactly as reviewed. A security review found that the workspace resolves two releases of the `semver` package, and that one of them is older than `7.5.2`. Make the install reproducible and bring the dependency graph in line.

1. The CI install step is the script `ci/install.sh`. It must run `yarn install --immutable` and must not run a plain install. Keep the file executable.

2. The `backend` package imports `semver` but does not declare it. Declare it in the backend manifest, under `dependencies`.

3. The package `legacy-tool` asks for `semver` `^5.7.2`. Do not change its range. Force one release of `semver` for the whole workspace with an entry in the `resolutions` field of the root `package.json`. After a new install, `yarn.lock` must hold exactly one `semver` release, and it must be `7.5.2` or later.

4. A `package-lock.json` file from an earlier mistake sits next to `yarn.lock`. Remove it. Yarn stays the package manager.

5. Update `yarn.lock` with a plain `yarn install`, then confirm with `yarn install --immutable` that the files agree.

Use `astrona ssh` to open a shell in the lab. The project is in `/opt/portal`.

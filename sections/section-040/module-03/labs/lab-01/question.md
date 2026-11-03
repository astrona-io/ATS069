# Question

Solve this question on: `terminal`

The portal team keeps its workspace in `/opt/portal`. The `@internal/plugin` package uses `@internal/shared` but does not say that the application must provide it. The file `.yarnrc.yml` also holds a literal registry token, and the `internal` scope has no registry of its own.

1. In `packages/plugin/package.json`, declare `@internal/shared` as a peer dependency with the range `^1.0.0`. Also list it under `devDependencies` with the range `workspace:^`, so the plugin can be built alone.

2. In `.yarnrc.yml`, remove the line that holds the literal token, the value that starts with `npm_FAKE`.

3. In `.yarnrc.yml`, route the scope `internal` to `https://npm.internal.example.com`. Under that scope, set `npmAlwaysAuth` to `true` and read the token from the environment variable `NPM_TOKEN`, with an empty value as the default.

4. Use `yarn why @internal/shared` and write the names of the workspaces that ask for it, one per line, to `/opt/portal/answers.txt`.

5. Run `yarn install`, then confirm with `yarn install --immutable`.

Keep Yarn as the package manager. Do not change the version of `@internal/shared`, do not add a `package-lock.json` file and do not remove `nodeLinker: node-modules` from `.yarnrc.yml`.

Use `astrona ssh` to open a shell in the lab. The project is in `/opt/portal`.

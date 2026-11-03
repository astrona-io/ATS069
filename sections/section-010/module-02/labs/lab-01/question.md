# Question

Solve this question on: `terminal`

The workspace `/opt/scaffold` is a small stand-in with the layout of a project made by `@backstage/create-app`. A developer copied it from an old template and added a backend plugin by hand. Four fields in its `package.json` files do not match what the project needs. The `backstage-cli` package is not installed, so do not run its commands. Fix the fields.

1. The root `package.json` lists only `packages/*` as workspaces, so Yarn does not see the two plugins in `plugins/`. The project must list both `packages/*` and `plugins/*`. After the fix, `yarn workspaces list` must show `@internal/plugin-status-backend`.

2. `node tools/check-env.js` must succeed on this machine. The `engines.node` field must allow Node.js 20 and 22.

3. The project uses Yarn 4, but the `packageManager` field names another major version. Set it to `yarn@4.4.1`.

4. The package `plugins/status-backend` is a backend plugin, but it does not declare its package role. Add the `backstage` field with the role `backend-plugin`.

Do not delete any package, `backstage.json` or `tools/check-env.js`, and do not change the role of `plugins/status`.

# Solution

Work in `/opt/scaffold`. Use `astrona submit` after each step to see which check passes.

## 1. Add the plugin folder to the workspaces

List the workspaces that Yarn knows:

```sh
cd /opt/scaffold
yarn workspaces list
```

The two plugins are missing, because the `workspaces` field only matches `packages/*`. Open `package.json` and change the field:

```json
"workspaces": {
  "packages": ["packages/*", "plugins/*"]
},
```

Run `yarn workspaces list` again. Both plugin packages now appear.

## 2. Allow the installed Node.js version

Run the environment check:

```sh
node tools/check-env.js
```

It prints the installed major version and the allowed majors, then stops with an error that names the version. Change the field in the root `package.json`:

```json
"engines": {
  "node": "20 || 22"
},
```

Run the check again. It ends without an error.

## 3. Set the package manager

Change the `packageManager` field in the root `package.json` to `yarn@4.4.1`. Corepack reads this field to choose the Yarn version for the project, so the old value would select Yarn 1.

## 4. Declare the plugin role

Open `plugins/status-backend/package.json` and add the field next to `version`:

```json
"backstage": { "role": "backend-plugin" },
```

Compare with `plugins/status/package.json`, which declares `frontend-plugin`. Run `astrona submit` to confirm that all five checks pass.

# Solution

Solve this lab on `terminal`. Each step ends with `astrona submit`. The `--keep` flag keeps the lab running so you can continue after a failed check. This lab was built without running it, so the text describes what you should see instead of printing output.

Start the lab if it is not running, then open a shell in the virtual machine:

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS069.git -c sections/section-030/module-03/labs/lab-01
astrona ssh ats-069-lab-030-03
```

## Step 1: Give the plugin a role

List the roles:

```sh
cd /opt/portal
node scripts/list-roles.mjs
```

Three packages show a role. The package `@portal/deploy-backend` shows `(no role)`. Open `plugins/deploy-backend/package.json` and add this field next to `main`:

```json
"backstage": { "role": "backend-plugin" },
```

Run the list again and confirm the role. Run `astrona submit`: the check `every-package-has-role` should pass.

## Step 2: Build every package

Read the root script:

```sh
grep build:all package.json
```

The script runs the build of `plugins/deploy-common` only. Replace its value with a command that runs the `build` script of every workspace that has one:

```json
"build:all": "npm run build --workspaces --if-present"
```

Remove all build output and run the script:

```sh
rm -rf packages/*/dist plugins/*/dist
npm run build:all
ls packages/app/dist packages/backend/dist plugins/deploy-common/dist plugins/deploy-backend/dist
```

Each folder has an `index.js` file. The build succeeds even though the backend plugin has a type error, because the build removes the types and does not check them. Run `astrona submit`: `build-all-builds-every-package` should pass.

## Step 3: Publish the build output

Open `plugins/deploy-common/package.json`. The `files` field lists `src`, so a published package would have no `dist` folder, and the `main` field would point at a file that is not there. Change it to:

```json
"files": ["dist"]
```

Check what a package would contain:

```sh
cd plugins/deploy-common
npm pack --dry-run
cd /opt/portal
```

The list includes `dist/index.js`. Run `astrona submit`: `published-files-include-dist` should pass.

## Step 4: Find and fix the hidden type error

Run the type check, which is a separate piece of evidence from the build:

```sh
npm run tsc
```

The compiler reports an error in `plugins/deploy-backend/src/index.ts`: a string is not assignable to type `number`. The line `const length: number = name;` stores the name where a number is expected. Replace it with the length of the name:

```ts
const length: number = name.length;
```

Run `npm run tsc` again; it ends with exit code `0`. Build the plugin and call it:

```sh
npm run build --workspace plugins/deploy-backend
node -e "console.log(require('/opt/portal/plugins/deploy-backend').describeBackend('abc'))"
```

The output is `abc (3)`. Run `astrona submit`. All six checks should pass.

## Why this works

A role tells the build tooling what kind of package it has, so it can choose the right build for it. The root script must reach every package, or part of the repository is never built. The `files` field decides what a published package contains, so it must name the build output. The build transpiles and does not check types, so a green build says nothing about type errors: only the type check finds them.

When you are done, remove the environment:

```sh
astrona destroy ats-069-lab-030-03
```

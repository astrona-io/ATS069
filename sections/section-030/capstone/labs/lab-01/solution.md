# Solution

Solve this lab on `terminal`. Each step ends with `astrona submit`. The `--keep` flag keeps the lab running so you can continue after a failed check. This lab was built without running it, so the text describes what you should see instead of printing output.

Start the lab if it is not running, then open a shell in the virtual machine:

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS069.git -c sections/section-030/capstone/labs/lab-01
astrona ssh ats-069-capstone-030-01
```

## Step 1: Read the build before changing it

Run a build from a clean state and read the first error:

```sh
cd /opt/portal
tsc --build --force
```

In build mode `tsc` orders the projects from the `references` it finds and builds each one after the projects it references. The root file lists only `deploy-common` and `deploy-backend`, so `app` is never part of this build. The `deploy-backend` project fails because its source imports a file of `deploy-common` and its configuration does not declare that dependency.

## Step 2: Fix the references

Add the missing reference to `plugins/deploy-backend/tsconfig.json`:

```json
"references": [{ "path": "../deploy-common" }]
```

Add the `app` project to the root `tsconfig.json`, so that the list has three entries: `./plugins/deploy-common`, `./plugins/deploy-backend` and `./packages/app`. Print the merged root configuration and check that all three paths appear:

```sh
tsc -p tsconfig.json --showConfig | grep path
```

## Step 3: Fix the app and add the runtime parser

Run `tsc --build --force` again. The build now reaches the `app` project and stops there. The constant `sample` has the status `done`, which is not part of the type `DeploymentStatus`. That is a real type error: change the value to `running`.

The function `renderRow` still uses `JSON.parse(body) as DeploymentRecord`. The compiler accepts it, but nothing checks the data when the program runs. Add the function `parseDeployment` to `plugins/deploy-common/src/index.ts`. It receives `unknown` and checks each field before it returns a record:

```ts
export function parseDeployment(input: unknown): DeploymentRecord {
  if (typeof input !== 'object' || input === null) {
    throw new Error('deployment must be an object');
  }
  const { id, status, owner } = input as Record<string, unknown>;
  if (typeof id !== 'string') {
    throw new Error('id must be a string');
  }
  if (!isDeploymentStatus(status)) {
    throw new Error('status must be running or failed');
  }
  if (owner !== undefined && typeof owner !== 'string') {
    throw new Error('owner must be a string');
  }
  return { id, status, owner };
}
```

The one assertion in this function is to `Record<string, unknown>` after the check that the value is an object. It does not claim the type `DeploymentRecord`. Then change `renderRow` in `packages/app/src/index.ts` to import `parseDeployment` from `@portal/deploy-common` and use `const record = parseDeployment(JSON.parse(body));`.

## Step 4: Set the build script and build

Open `/opt/portal/package.json` and change the script `build:all` from `tsc` to `tsc --build`. Then run a build from a clean state and look at the output of each project:

```sh
tsc --build --force
ls plugins/deploy-common/dist plugins/deploy-backend/dist packages/app/dist
```

Each `dist` folder should hold an `index.js` and an `index.d.ts`. Run `astrona submit`: all seven checks should pass.

## Why this works

Project references give `tsc --build` the order and the declaration files that each project needs, so a clean machine builds the same way as a machine with old output. The parser guards the one place where untyped data enters, and the compiler checks everything behind it. The script `build:all` records the working command in the repository, so a pipeline runs the same operation.

When you are done, remove the environment:

```sh
astrona destroy ats-069-capstone-030-01
```

# Solution

Solve this lab on `terminal`. Each step ends with `astrona submit`. This lab was built without running it, so the text describes what you should see instead of printing output.

Open a shell and go to the project:

```sh
cd /opt/portal
```

`astrona submit` right after the start shows that the project setup check passes and that the others fail.

## Step 1: See the failure

Run the immutable install and read the first error line:

```sh
yarn install --immutable
```

The command exits with a non-zero code. The range `^2.0.0` for `@internal/shared` in `packages/app/package.json` matches no local workspace, because the local version is `1.0.0`, so Yarn must look for the package in the public registry. This is the first fault.

## Step 2: Fix the range in the app package

Read the version of the shared package and the range the app uses:

```sh
node -p "require('./packages/shared/package.json').version"
cat packages/app/package.json
```

Change the range in `packages/app/package.json` to `workspace:^`. Yarn then links the local package and never asks the registry. The range `^1.0.0` also works, because the local version satisfies it. Submit again:

```sh
astrona submit
```

The check `app-range-matches-shared` now passes.

## Step 3: Declare the dependency in the backend

The backend source imports `@internal/shared`, and the code only works today because Yarn placed the package in the root `node_modules` folder. Declare it where it is used:

```sh
yarn workspace backend add @internal/shared@workspace:^
```

If this form is rejected by your Yarn release, write the entry by hand in `packages/backend/package.json` under `dependencies`: `"@internal/shared": "workspace:^"`. Submit:

```sh
astrona submit
```

The check `backend-declares-shared` passes.

## Step 4: Update the lockfile and confirm

A plain install rewrites `yarn.lock` to match the manifests. The immutable install then confirms that nothing else needs to change:

```sh
yarn install
yarn install --immutable
echo "exit code: $?"
astrona submit
```

The exit code of the last install is `0`, and all checks pass. In a real repository, you commit the manifest changes and `yarn.lock` together.

# Solution

Solve this lab on `terminal`. Each step ends with `astrona submit`. This lab was built without running it, so the text describes what you should see instead of printing output.

Open a shell and go to the project:

```sh
cd /opt/portal
```

`astrona submit` right after the start shows that the project setup check and the immutable install check pass and that the others fail.

## Step 1: See where semver is declared

Print the root manifest and the backend manifest:

```sh
cat package.json
cat packages/backend/package.json
yarn why semver
```

The root manifest lists `semver` under `dependencies`. The backend manifest does not list it. The backend works only because the install hoists `semver` to the root `node_modules` folder.

## Step 2: Move the dependency to the backend

Remove it from the root and add it to the backend:

```sh
yarn remove semver
yarn workspace backend add semver
```

If `yarn remove semver` reports that the root workspace does not list the package, edit `package.json` by hand and delete the `dependencies` block. Submit:

```sh
astrona submit
```

The checks `semver-not-at-root`, `backend-declares-semver` and `lockfile-lists-backend-semver` pass.

## Step 3: Add the lint:all script

Edit the root `package.json` and add a `scripts` field:

```json
"scripts": {
  "lint:all": "yarn workspaces foreach -A run lint"
}
```

Run it and read the exit code:

```sh
yarn run lint:all
echo "exit code: $?"
astrona submit
```

The exit code is `0` and the check `lint-all-script` passes.

## Step 4: Confirm the install

```sh
yarn install
yarn install --immutable
echo "exit code: $?"
astrona submit
```

The last install exits with code `0`, and all checks pass. In a real repository, you commit the manifests and `yarn.lock` together.

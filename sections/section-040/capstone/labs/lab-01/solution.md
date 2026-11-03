# Solution

Solve this lab on `terminal`. Each step ends with `astrona submit`. This lab was built without running it, so the text describes what you should see instead of printing output.

```sh
cd /opt/portal
```

`astrona submit` right after the start shows the failing checks. Work through the steps in order.

## Step 1: Make the CI step immutable

Read the script. The last command is a plain `yarn install`, which is allowed to rewrite the lockfile:

```sh
cat ci/install.sh
```

Change that line to `yarn install --immutable`. The script stays executable when you edit it in place. Submit:

```sh
astrona submit
```

The check `ci-install-is-immutable` passes.

## Step 2: Declare semver in the backend

The backend imports `semver`, and the code works today because another package declared it and Yarn placed it in the root `node_modules`. Declare it where it is used:

```sh
yarn workspace backend add semver@^7.6.0
```

This writes the entry into `packages/backend/package.json` and updates `yarn.lock`. Submit and the check `backend-declares-semver` passes.

## Step 3: Force one semver release

Find out which packages cause each release to be installed:

```sh
yarn why semver
```

The output names `legacy-tool` as the package that asks for `^5.7.2`. Add this field to the root `package.json`:

```json
"resolutions": {
  "semver@^5.7.2": "^7.6.0"
}
```

Then run a plain install, which is allowed to change the lockfile:

```sh
yarn install
grep -A2 '^"semver@' yarn.lock
```

The lockfile now has one `version:` line for `semver`. The `legacy-tool` code only calls `semver.valid`, which exists in both major versions, so the override is safe for this project. Submit. The checks `single-semver-release` and `legacy-tool-range-kept` pass.

## Step 4: Remove the second lockfile

```sh
rm package-lock.json
```

The check `no-second-lockfile` passes.

## Step 5: Confirm

```sh
yarn install --immutable
echo "exit code: $?"
astrona submit
```

The exit code is `0` and all checks pass. In a real repository, the manifest changes, `yarn.lock` and `ci/install.sh` go into one commit with the reason for the `resolutions` entry in the message.

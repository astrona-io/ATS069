# Solution

Open a shell in the lab and change to the workspace with `cd /opt/portal`. `astrona submit` grades the whole task.

## 1. Fix the lint problem

```sh
yarn lint
```

The linter prints the file, the line and the rule name `no-console-debug`. Open `packages/backend/src/health.ts` and delete the `console.debug` line. Run `yarn lint` again. It prints `lint ok`.

## 2. Format the file

```sh
yarn format:check
yarn format
git diff
```

The check names the file that is not formatted. `yarn format` rewrites it: tabs become two spaces and trailing spaces disappear. `git diff` shows only whitespace changes.

## 3. Add the check script

In the root `package.json`, add this line to `scripts`:

```json
"check": "yarn tsc && yarn lint && yarn format:check && yarn test"
```

The `&&` operator runs the next command only when the previous one exited with code 0. Run `yarn check`.

## 4. Install the hook

The hook file is `.githooks/pre-commit`. Replace its last line with `yarn check`, make it executable and tell Git where hooks live:

```sh
chmod +x .githooks/pre-commit
git config core.hooksPath .githooks
```

Try a bad commit, for example a file with `export const broken: number = "text";`. Git refuses the commit and prints the type error. Remove the file, then run `astrona submit`.

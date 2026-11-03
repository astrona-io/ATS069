# Solution

Solve this lab on `terminal`. Each step ends with `astrona submit`. The `--keep` flag keeps the lab running so you can continue after a failed check. This lab was built without running it, so the text describes what you should see instead of printing output.

Start the lab if it is not running, then open a shell in the virtual machine:

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS069.git -c sections/section-030/module-01/labs/lab-01
astrona ssh ats-069-lab-030-01
```

## Step 1: Find what the check covers

Run the check and print the exit code:

```sh
cd /opt/portal
tsc; echo "exit code: $?"
```

The result is green, but that is not enough evidence. Print the files that the compiler treats as part of the project:

```sh
tsc --listFilesOnly | grep '^/opt/portal' | grep -v node_modules
```

The list has `packages/app/src/index.ts`. It also has `plugins/deploy-common/src/index.ts`, because the app imports it. The file `plugins/deploy-backend/src/index.ts` is missing: no `include` pattern matches it and no included file imports it. Without this file in scope, a type error in the backend plugin cannot fail the check.

Open `tsconfig.json` and change the `include` list to:

```json
"include": ["packages/*/src", "plugins/*/src"]
```

Run `tsc --listFilesOnly` again and confirm that all three `index.ts` files are listed.

## Step 2: Fix the optional value

Run `tsc`. The compiler now reports an error in `plugins/deploy-backend/src/index.ts` on `record.owner`. The property `owner` is optional, so its type is `string | undefined`, and `toUpperCase` is not available on `undefined`. A record without an owner would throw a `TypeError` at runtime.

Do not add `as string` or an exclamation mark: they silence the compiler and leave the crash path. Replace the body of `describeOwner` with a check:

```ts
return record.owner === undefined ? 'unassigned' : record.owner.toUpperCase();
```

Run `tsc` again. The exit code is `0`. Run `astrona submit`: the checks `scope-covers-all-packages`, `type-check-passes`, `absence-handled-at-runtime` and `strict-kept-no-escapes` should pass.

## Step 3: Stop the check from writing files

The `tsconfig.json` does not set `noEmit` or `outDir`, so each plain `tsc` run writes a `.js` file next to every `.ts` file in the project. Check for them:

```sh
find packages plugins -path '*/src/*.js'
```

If the command lists files, delete them with `rm` and the listed paths. Then add `"noEmit": true` to `compilerOptions` in `tsconfig.json` and confirm the setting:

```sh
tsc --showConfig | grep noEmit
```

Run `tsc` once more, run the `find` command again to confirm that it prints nothing, and run `astrona submit`. All five checks should pass.

## Why this works

The compiler checks only the files in its project, so the first fix changes what the claim covers. The error in the second step is a real crash path that the compiler found, and handling `undefined` in code removes it. The option `noEmit` makes a check produce a result and no files, which keeps generated JavaScript out of the source folders.

When you are done, remove the environment:

```sh
astrona destroy ats-069-lab-030-01
```

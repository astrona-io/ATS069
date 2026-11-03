# Solution

Solve this lab on `terminal`. Each step ends with `astrona submit`. The `--keep` flag keeps the lab running so you can continue after a failed check. This lab was built without running it, so the text describes what you should see instead of printing output.

Start the lab if it is not running, then open a shell in the virtual machine:

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS069.git -c sections/section-030/module-02/labs/lab-01
astrona ssh ats-069-lab-030-02
```

## Step 1: Extend the shared base

Print the merged configuration and look at `strict` and `outDir`:

```sh
cd /opt/portal
tsc --showConfig
```

`strict` is `false` and there is no `outDir`, because the root file does not extend the base. Save this as `tsconfig.json`, replacing the old content:

```json
{
  "extends": "./tsconfig.base.json",
  "include": ["packages/*/src", "plugins/*/src"],
  "exclude": ["node_modules"],
  "compilerOptions": {
    "outDir": "dist-types",
    "rootDir": "."
  }
}
```

Run `tsc --showConfig` again. `strict` is now `true`, and `declaration` and `emitDeclarationOnly` come from the base.

## Step 2: Fix the parameter

Run `tsc`. The compiler reports an error in `plugins/deploy-backend/src/index.ts`: the parameter `record` has an implicit `any` type. Under `strict`, the option `noImplicitAny` makes this an error. Give the function its types:

```ts
export function summarize(record: DeploymentRecord): string {
```

Run `tsc` again. The exit code is `0`. Run `astrona submit`: the checks `extends-shared-base`, `strict-in-effect` and `type-check-passes` should pass.

## Step 3: Clean up the output

Earlier runs of `tsc` wrote `.js` files next to the sources. List them and delete them with the listed paths:

```sh
find packages plugins -path '*/src/*' -name '*.js'
```

Run `npm run tsc`, then list the output folder:

```sh
find dist-types -name '*.d.ts'
```

The declaration files are in `dist-types` in the same folder layout as the sources. Run the first `find` command again to confirm that it prints nothing, and run `astrona submit`.

## Step 4: Add the full check script and ignore the output

Add `tsc:full` to the `scripts` object of `package.json`:

```json
"tsc:full": "tsc --skipLibCheck false --incremental false"
```

Run `npm run tsc:full`; it ends with exit code `0`. Then append `dist-types` as a line to `.gitignore`:

```sh
echo dist-types >> .gitignore
```

Run `astrona submit`. All six checks should pass.

## Why this works

A repository keeps its shared options in one base file, so every package is checked under the same rules and one change reaches all of them. The root file adds only what is local: the file scope and the output folder. The full check removes the two shortcuts, `skipLibCheck` and incremental mode, so it can run in a pipeline as a slower and stricter second opinion.

When you are done, remove the environment:

```sh
astrona destroy ats-069-lab-030-02
```

# Overview: TypeScript Checking And Workspace Builds (Playground)

This is a playground, not a lab. It starts an Ubuntu virtual machine and waits. There is no task, no `astrona submit` and no pass or fail. Edit files, break them, run `astrona destroy` and start again. Open a shell with `astrona ssh ats-069-playground-030-01`.

## What is in the box

- Node.js 22 and the TypeScript compiler `tsc` (version 5.8.3) on the `PATH`.
- The workspace `/opt/portal`, owned by every user, with three packages: `plugins/deploy-common` (shared types and a `parseDeployment` function), `plugins/deploy-backend` (uses the shared types) and `packages/app` (parses a JSON body).
- `tsconfig.base.json` with shared options, `tsconfig.check.json` that checks every `src` folder in one run and writes nothing, and `tsconfig.json` that lists the three projects as references for `tsc --build`.
- No registry packages: nothing is installed with Yarn, and no Backstage package is present.

## Practice tasks

- Run `cd /opt/portal`, then `tsc -p tsconfig.check.json` and read the exit code with `echo $?`. Add `--listFilesOnly` and count the files in the check.
- Remove `"plugins/*/src"` from `include` in `tsconfig.check.json`, then introduce a type error in `plugins/deploy-backend/src/index.ts`. Confirm that the check no longer reports it.
- Change `describeOwner` to `record.owner.toUpperCase()` and read the error. Fix it with a check for `undefined`.
- Run `tsc --showConfig -p tsconfig.check.json` to see the merged options.
- Run `tsc --build`, then list `plugins/deploy-common/dist`. Look at the `.d.ts` and `.js` files and at the `.tsbuildinfo` file.
- Run `tsc --build` again and compare how long it takes. Edit one file and run it a third time.
- Run `tsc --build --clean`, then remove the `references` entry from `plugins/deploy-backend/tsconfig.json` and build again.
- Run `node -e "console.log(require('/opt/portal/plugins/deploy-common/dist').parseDeployment({id: 'a', status: 'done'}))"` after a build and read the error. Explain why the compiler did not stop this input.

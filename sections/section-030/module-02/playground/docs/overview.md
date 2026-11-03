# Overview: Shared tsconfig, Strictness And Type Check Scripts (Playground)

This is a playground, not a lab. It starts an Ubuntu virtual machine and waits. There is no task, no `astrona submit` and no pass or fail. Edit files, break them, run `astrona destroy` and start again. Open a shell with `astrona ssh ats-069-playground-030-02`.

## What is in the box

- Node.js 22 and the TypeScript compiler `tsc` (version 5.8.3) on the `PATH`.
- The workspace `/opt/portal` with three packages: `plugins/deploy-common`, `plugins/deploy-backend` and `packages/app`.
- `tsconfig.base.json`, a stand-in for the shared base that a Backstage repository extends, and a root `tsconfig.json` that extends it and sets `outDir` to `dist-types`.
- The scripts `tsc` and `tsc:full` in the root `package.json`. The playground has no Yarn project, so run them with `npm run tsc` and `npm run tsc:full`.
- A declaration file `plugins/deploy-backend/src/legacy.d.ts` that refers to a type that does not exist.
- No registry packages: no Backstage package is present.

## Practice tasks

- Run `cd /opt/portal`, then `tsc --showConfig` and find `strict`, `skipLibCheck`, `incremental` and `outDir` in the merged result.
- Run `npm run tsc`, then list `dist-types` and find the `.d.ts` files and the `.tsbuildinfo` file.
- Run `npm run tsc:full` and read the error in `legacy.d.ts`. Explain why `npm run tsc` did not report it.
- Change `strict` to `false` in a copy of the root configuration, write `function f(x) { return x; }` in a new source file and compare the result with and without `strict`.
- Run `npm run tsc` twice and compare the time. Edit one file and run it a third time.
- Delete `dist-types` and run `npm run tsc` again.

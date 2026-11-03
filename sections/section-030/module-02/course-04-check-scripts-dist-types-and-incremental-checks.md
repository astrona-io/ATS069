---
draft: true
exam_objectives:
- Compile a Backstage project with TypeScript
---
# Check Scripts, dist-types And Incremental Checks

A developer runs the type check ten times in an hour. If each run starts from nothing and writes files next to the sources, the check is slow and it fills the working tree with generated files. The root of a Backstage repository avoids both problems. It sends the output to one folder, keeps a record of the last run so unchanged work is skipped, and exposes the check as a script. This part explains each piece and where it matters for the build.

## The two root scripts

The root `package.json` of a Backstage app defines the type check as scripts. The script `tsc` runs the compiler with the root `tsconfig.json`. The script `tsc:full` runs it with `--skipLibCheck false --incremental false`. In a Yarn project a developer runs them as `yarn tsc` and `yarn tsc:full`. The playground has no Yarn project, so it runs the same scripts with `npm run`.

The scripts matter because they give the repository one agreed way to run the check. A pipeline calls the script and not a hand-typed compiler command. When the team changes how the check works, it changes the script once.

## Declaration output goes to dist-types

The shared base sets `declaration` to `true` and `emitDeclarationOnly` to `true`. The option `declaration` makes the compiler write a `.d.ts` file for every source file. The option `emitDeclarationOnly` makes it write only those files and no JavaScript. The root file sets `outDir` to `dist-types`, and `rootDir` to the repository root, so the output keeps the folder layout of the repository.

<!-- astrona:playground:renew -->

Run the check and look at the result:

```sh
cd /opt/portal
npm run tsc
find dist-types -name '*.d.ts'
```

The list has one `.d.ts` file for each source file, in paths such as `dist-types/plugins/deploy-backend/src/index.d.ts`. Nothing is written next to the sources. Check that with a search for generated files in the source folders:

```sh
find packages plugins -path '*/src/*' -name '*.js'
```

The command prints nothing. The check produced declarations in one ignored folder, and the working tree stays clean. That is why `.gitignore` lists `dist-types`: it is generated output, and it is rebuilt by the script.

The folder has a purpose beyond keeping the check tidy. In a Backstage repository, the build of a library package reads the declaration files from `dist-types` to produce the type file that the package publishes. A pipeline therefore runs `yarn tsc` before `yarn build:all`. If `dist-types` is missing or stale, the library build can fail or ship wrong types, even though the JavaScript build itself does not check types.

## Incremental checks

The option `incremental` makes the compiler save information about the last run in a build information file, with the extension `.tsbuildinfo`. On the next run, the compiler compares the files with that record and rechecks only what changed and what depends on it. When no file changed, the run is very short.

```sh
find dist-types -name '*.tsbuildinfo'
time npm run tsc
```

The first command finds the file in `dist-types`, next to the declaration output. The second command takes a short time, because nothing changed since the last run. Edit `packages/app/src/index.ts` by adding a blank line inside a function, then run `time npm run tsc` again. The time grows a little, because the compiler has to recheck that file and the files that depend on it.

Incremental mode is fast because it trusts the record. The record can be wrong when the compiler version changes, when options change, or when files are edited by a tool outside the compiler's view. That is why the full script turns it off with `--incremental false`: it starts from nothing and produces a result that does not depend on earlier runs. Delete `dist-types` and run `npm run tsc` to see a run from nothing; it is slower than the incremental run and produces the same result.

## Reading a failing script

When a check script fails in a pipeline, the order of questions is short. First read the exact script in `package.json`, because the flags change the claim. Then run `tsc --showConfig` for the root project to see the options. Then compare the file scope with `--listFilesOnly`. Most surprises come from one of these three: a flag in the script, an option from the base that nobody remembered, or a folder that is not in `include`.

This part showed where the check writes its output, why that folder matters for the library build, and how incremental mode makes repeated runs short. The module's practice is to apply these ideas to a workspace that has them wrong.

## Common pitfalls

> [!WARNING]
> Do not commit `dist-types`: it is generated and belongs in `.gitignore`. Do not run the library build before the type check script has written fresh declarations. Do not trust an incremental result after a change of compiler version or options; run the full script to get a result from nothing.

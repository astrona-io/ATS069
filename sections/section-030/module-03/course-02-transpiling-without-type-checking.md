---
draft: true
exam_objectives:
- Compile a Backstage project with TypeScript
---
# Transpiling Without Type Checking

A developer runs the build of the `portal` repository and it finishes in seconds with no errors. The release job then fails on a type error in the same package. Both are correct, because the build and the type check are separate steps that answer different questions. This part explains what transpiling is, why the Backstage build does it without checking types, and what that means for a pipeline.

To transpile is to convert source code from one form of a language to another form of a language. Here, it means converting TypeScript to JavaScript by removing the type annotations and rewriting newer syntax where the target requires it. A transpiler works on one file at a time. It does not need to know the types of the files that the file imports, so it is fast and it can run in parallel. A type check is the opposite: it needs the whole program, because the type of a value in one file can depend on declarations in many others.

## Why the build does not check types

The Backstage build is designed so that the build does not do the slow work. The package build uses a bundler, a tool that joins many modules into the files that a runtime loads, together with a fast transpiler that strips the types and does not report type errors. The type check is done once for the whole repository by `tsc` from the root script. The repository thereby avoids checking the same types in every package build and keeps the build fast.

The trade is that a build can succeed on code that does not type check. Each of the two results is true about something different. The build result says that the files could be converted and packaged. The type check result says that the program is consistent with its declarations.

## The same split in the playground

The playground has a build script in each package that runs `tsc -p tsconfig.build.json --noCheck`. The option `--noCheck` makes `tsc` skip type checking and still write output. It plays the role of the Backstage build here, because the playground has no `backstage-cli`. Open the shell and add a type error.

<!-- astrona:playground:renew -->

Save this as `plugins/deploy-common/src/index.ts`, replacing its content:

```ts
export type DeploymentStatus = 'running' | 'failed';

export function isDeploymentStatus(value: unknown): value is DeploymentStatus {
  const result: number = value;
  return value === 'running' || value === 'failed';
}
```

The line with `const result: number = value;` stores a value of type `unknown` where a number is expected. Run the build and then the type check:

```sh
cd /opt/portal
npm run build:all
echo "build exit code: $?"
npm run tsc
echo "tsc exit code: $?"
```

The build ends with exit code `0` and writes `dist` folders. The type check reports an error on the `result` line, the message says that `unknown` is not assignable to type `number`, and its exit code is not `0`. Both commands read the same source. The build converted the file, and the type check found the inconsistency.

Run the built code to see that the output exists and works for the valid case:

```sh
node -e "console.log(require('/opt/portal/plugins/deploy-common').isDeploymentStatus('running'))"
```

The output is `true`. The function runs, because the types are gone and the invalid line is only an assignment that JavaScript accepts. This is the danger of trusting a green build: the faulty line is shipped. Restore the original function body by removing the `result` line, and run `npm run tsc` again to see exit code `0`.

## What each step is responsible for

The build owns the output: it must produce files that the runtime can load. The type check owns the correctness of types. A third kind of check, tests, owns behavior. A pipeline for a Backstage repository runs the type check, the tests and the build as separate steps, and a change merges only when the steps that matter pass. If a team reads the build result alone, type errors reach the main branch.

The order in a pipeline follows the dependencies between the steps. The type check comes before the library build because the library build reads the declaration files that the type check writes into `dist-types`. The tests can run in parallel with them. The build of the app and the backend comes last, because it produces what is deployed.

## When the build does fail

The build still has its own failures. It fails when it cannot resolve an import, when a file has a syntax error that the transpiler cannot parse, or when a role is missing or unsupported. These are failures of conversion and packaging. A useful rule for reading a failing pipeline is to name the step first: a type error belongs to the type check, a missing module belongs to resolution, a syntax error belongs to the build.

This part showed that the build converts and packages while the type check judges, and that a build can succeed on code that fails the type check. The next question is what the build writes for each kind of package.

## Common pitfalls

> [!WARNING]
> Do not read a green build as proof that the types are correct. A pipeline that runs only the build lets type errors reach the output. Do not run the type check only on the package you changed: a change to a shared type breaks callers in other packages, and only the root check sees them.

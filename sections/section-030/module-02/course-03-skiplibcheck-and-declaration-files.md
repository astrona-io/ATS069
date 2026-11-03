---
draft: true
exam_objectives:
- Compile a Backstage project with TypeScript
---
# skipLibCheck And Declaration Files

A team upgrades one dependency in the `portal` repository. The everyday type check stays green, but a month later a pipeline job that runs a stricter check fails with an error inside a file of that dependency. Nobody changed their own code. The difference between the two checks is one option, `skipLibCheck`. This part explains what a declaration file is, what the option skips, and why a repository runs two checks.

A declaration file is a file with the extension `.d.ts` that contains only types: the names, parameters and return types of functions and the shape of objects, with no function bodies. A package written in JavaScript ships declaration files so that TypeScript code can use it with types. A package written in TypeScript ships declaration files that the compiler generated. When your code imports a package, the compiler reads its declaration files to learn the types.

## What the option skips

The option `skipLibCheck` tells the compiler not to type check declaration files. The compiler still reads them to learn the types of what you import, but it does not report errors that sit inside them. The option applies to every `.d.ts` file in the project, including declaration files that you wrote yourself. It does not skip your `.ts` source files.

Why would a repository skip those checks? Declaration files from many packages can conflict with each other or with the compiler version. For example, two packages may declare the same global type in different ways. The error is real, but it is not in your code and you usually cannot fix it. Skipping the check makes the everyday result faster and keeps it about the code that the team owns. The shared base of a Backstage repository sets `skipLibCheck` for this reason.

The cost is the reverse of the benefit. A mistake in a declaration file stays hidden, even when the file is yours. A repository therefore needs a way to run the check without the shortcut.

## The playground has a declaration file with an error

The workspace has a file `plugins/deploy-backend/src/legacy.d.ts` that declares a module and refers to a type named `LegacyOptions`. No such type exists. Run the everyday check first.

<!-- astrona:playground:renew -->

```sh
cd /opt/portal
npm run tsc
echo "exit code: $?"
```

The exit code is `0`, because `skipLibCheck` is `true` in the merged configuration and the broken file is a declaration file. Now run the full check:

```sh
npm run tsc:full
echo "exit code: $?"
```

The compiler reports error `TS2304` in `legacy.d.ts`: it cannot find the name `LegacyOptions`. The exit code is not `0`. Both commands checked the same files. The second command passed `--skipLibCheck false`, which overrides the value from the base file for this one run. A command-line option wins over the configuration file.

Print the script to see exactly what it runs:

```sh
grep tsc:full package.json
```

The script is `tsc --skipLibCheck false --incremental false`. The second flag turns off incremental mode, which keeps a record of the last run to make repeated checks faster. In a Backstage app the root `package.json` has a script with the same name and the same flags, and the command `yarn tsc:full` runs it.

## Fixing the declaration

Repair the file so that the full check passes. Save this as `plugins/deploy-backend/src/legacy.d.ts`, replacing its content:

```ts
declare module 'legacy-lib' {
  export interface LegacyOptions {
    name: string;
  }
  export function run(options: LegacyOptions): void;
}
```

Run `npm run tsc:full` again. The exit code is now `0`. The error was in how the file declared the module, and the fix gave the missing name a definition.

## When to run which check

The everyday check, `yarn tsc` in a Backstage repository, runs on a developer machine and in a pull request. It is quick because of `skipLibCheck` and incremental mode. The full check, `yarn tsc:full`, is slower and runs where time matters less, for example in a nightly job or before a release. A failure only in the full check points at a declaration file: either one that the repository owns, or one from a dependency whose version changed.

When the failing file belongs to a dependency, the usual options are to update or pin that dependency, or to keep the shortcut in the everyday check and leave the full check as a report. Turning the check off for good removes the report but not the problem.

This part separated source checks from declaration checks and showed one workspace passing under one option and failing under the other. The open question is where the compiler writes the declarations it generates, and how repeated checks stay fast.

## Common pitfalls

> [!WARNING]
> A green check with `skipLibCheck` on says nothing about declaration files, including your own `.d.ts` files. Do not copy a declaration file into the repository and assume it is correct because the check passes. A command-line flag overrides the configuration file, so read the script as well as the `tsconfig.json` when you compare two results.

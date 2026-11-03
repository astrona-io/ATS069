---
draft: true
exam_objectives:
- Understand local development workflows
---
# Formatting With Prettier And Checking Types With tsc

Two more checks complete the set. Formatting makes every file look the same, so reviews show real changes and not spaces. The type check finds code that breaks the types before the code runs. This part covers both.

## Formatting with Prettier

Prettier is a code formatter. It reads a file and writes it back with fixed rules for indentation, line length, quotes and trailing commas. Backstage projects use it, and the generated project has a `.prettierrc.js` file that uses the shared setup from `@backstage/cli`. The generated root scripts include `yarn prettier:check`, which runs `prettier --check .`, and the command `prettier --write .` rewrites files.

The two modes have different jobs. `--check` changes nothing and exits with a non-zero code if any file differs from its formatted form. That is the mode for a pipeline. `--write` rewrites the files, and it is the mode for a developer.

<!-- astrona:playground:renew -->

The playground has a small formatter with the rules "two spaces, no trailing spaces, one newline at the end". Check, break and repair a file:

```sh
cd /opt/portal
yarn format:check
printf 'export const answer = 42;   \n' >> packages/app/src/label.ts
yarn format:check
```

The second check prints the name of the file and exits with code 1. Repair it and read the change:

```sh
yarn format
git diff
git checkout packages/app/src/label.ts
```

The diff shows only whitespace. A formatting change should never change behavior, so a reviewer can skip it. Keep formatting commits separate from logic changes so that this stays true.

## Why format automatically

Without a formatter, reviewers comment on style and developers argue about it. With a formatter, there is one style and the check decides. The pipeline fails a change that is not formatted, and the developer runs one command to fix it.

## The type check with tsc

`tsc` is the TypeScript compiler. With the option `--noEmit` it checks the types and writes no files. A generated Backstage project has the root script `yarn tsc`, which runs `tsc` with the root `tsconfig.json`, and a stricter script `yarn tsc:full`, which runs `tsc --skipLibCheck false --incremental false`. The first is faster because it reuses earlier results and skips the checking of library declaration files. The second is the form for a pipeline.

Run the type check in the playground:

```sh
yarn tsc
```

The command prints nothing when it succeeds. Introduce an error and run it again:

```sh
echo "export const broken: number = 'text';" >> packages/app/src/label.ts
yarn tsc
git checkout packages/app/src/label.ts
```

The compiler prints the file, the line and the message that a string cannot be assigned to a number, and exits with code 2.

## Four checks, four jobs

Each check finds a different kind of mistake:

- The type check finds code that breaks the declared types.
- The tests find behavior that differs from the expected behavior.
- The linter finds forbidden or risky patterns in the source text.
- The format check finds files that do not follow the shared style.

A change that passes one check can fail another. A project that runs only some of them leaves a kind of mistake unchecked.

## What this part showed

You saw that Prettier has a check mode for pipelines and a write mode for developers, that `tsc --noEmit` checks the types without writing files, and that each check finds a different kind of mistake. The next question is how to run all of them together, the same way as the pipeline.

## Common pitfalls

> [!WARNING]
> Do not run `prettier --write .` on a large repository in the same commit as a logic change: the diff becomes unreadable. Do not treat a silent `tsc` as proof that the tests pass. The fast `yarn tsc` can pass while `yarn tsc:full` fails on a library declaration file.

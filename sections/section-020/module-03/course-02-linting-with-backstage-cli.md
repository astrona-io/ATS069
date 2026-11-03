---
draft: true
exam_objectives:
- Understand local development workflows
---
# Linting With backstage-cli

Some mistakes do not need a test to be found. An unused variable, a forbidden import or a debugging statement is visible in the source text. A linter reads the source without running it and reports such problems. This part explains how a Backstage project lints its code.

## What a linter checks

A linter is a program that applies a list of rules to source files. Each rule has a name, such as `no-console`, and a severity: an error fails the check, and a warning is only printed. Backstage projects use ESLint. The shared rules come from the package `@backstage/cli`, and a package extends them in a small file named `.eslintrc.js` or `eslint.config.js`, depending on the ESLint version. The shared rules include checks that are specific to Backstage, for example a rule that stops a package from importing another package that it does not declare in its `package.json`.

## The commands

`backstage-cli package lint` lints the package in the current folder. `backstage-cli repo lint` lints every package in the repository. A generated project exposes them as the root scripts `yarn lint` and `yarn lint:all`. The option `--fix` lets ESLint repair the problems that have a safe automatic fix, such as import order. The option `--max-warnings 0` turns every warning into a failure, which a pipeline often needs.

<!-- astrona:playground:renew -->

The playground has a small linter script with three rules. Run it:

```sh
cd /opt/portal
yarn lint
```

The script prints `lint ok` and the number of files it read. Add a problem and run it again:

```sh
echo "console.debug('state');" >> packages/backend/src/health.ts
yarn lint
```

The output names the file, the line number and the rule `no-console-debug`, and the command exits with code 1. Remove the line with `git checkout packages/backend/src/health.ts`.

## Lint only what changed

On a large repository a full lint takes minutes. The real command accepts `--since <ref>`: `backstage-cli repo lint --since origin/master` lints only the packages that changed compared with that Git ref. The playground has the same idea in `yarn lint:changed`, which lints the files that differ from the last commit. Try it after a change:

```sh
echo "debugger;" >> packages/app/src/label.ts
yarn lint:changed
git checkout packages/app/src/label.ts
```

Only the changed file is read, and the problem is reported. Use the full lint before a merge, because a change in one package can break a rule in a package that depends on it.

## Fix the code, not the rule

When a rule reports a problem, change the code. A rule can be switched off for one line with a comment such as `// eslint-disable-next-line no-console`. Do this only when the rule is wrong for that line, and write the reason in the comment. Switching a rule off for a whole file or package hides the problem for every later change, so a reviewer should question it.

## Lint is not a type check

The linter works on the text and on a model of the syntax. It does not prove that the types agree across packages. Some lint rules use type information, but the full type check is a separate command, and it needs its own run. A file can pass lint and fail the type check, and the other way round.

## What this part showed

You saw that Backstage uses ESLint through `backstage-cli`, that `package lint` covers one package and `repo lint` covers all of them, that `--fix` repairs safe problems and `--since` limits the run to changed packages. You also saw that lint complements the tests and the type check. Formatting and the type check are next.

## Common pitfalls

> [!WARNING]
> Do not disable a rule for a whole file to make a check pass. Do not use `--fix` and commit without reading `git diff`: an automatic fix still changes code. A lint run limited to changed packages can miss a problem in a package that depends on them.

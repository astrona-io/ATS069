---
draft: true
exam_objectives:
- Understand local development workflows
---
# Running Tests With backstage-cli

A test is a small program that calls your code and compares the result with the result you expect. Tests find a broken behavior before a user does. This part explains how a Backstage project runs its tests, and how to run only the tests that a change needs.

## The test runner

Backstage projects use Jest, a JavaScript test runner. The Backstage command line tool `backstage-cli` wraps Jest and supplies a shared configuration, so a package does not need its own. A test file ends in `.test.ts` or `.test.tsx` and sits next to the source file it tests. The files use the functions `describe`, `it` (or `test`) and `expect`.

There are two commands. `backstage-cli package test` runs the tests of the package in the current folder. `backstage-cli repo test` runs the tests of every package in the repository. A generated project exposes the second one as the root script `yarn test`, and it commonly adds a script such as `yarn test:all` that also collects coverage with the option `--coverage`.

<!-- astrona:playground:renew -->

The playground uses Node.js's built-in test runner instead of Jest, with the same idea. Run all tests:

```sh
cd /opt/portal
yarn test
```

The output lists each test with a pass mark and ends with a count of passed and failed tests. The tests of `packages/app` and `packages/backend` run in one command.

## Watch mode and single runs

`backstage-cli package test` starts in watch mode when it runs in a terminal inside a Git repository. In watch mode, Jest stays open, runs only the tests related to changed files and waits for the next change. That is the fast loop for development. When the environment variable `CI` is set, or you pass `--watch=false`, the command runs once and exits with a code that says whether the tests passed. A pipeline needs that exit code.

```sh
CI=1 yarn backstage-cli package test
```

The line above shows the real form for a Backstage package. Use it in a package folder of a real project. The playground script `yarn test` always runs once.

## Running a subset

A developer rarely needs every test after one change. Jest accepts a path or a name pattern: `yarn backstage-cli package test ownerWarning` runs the test files whose path contains that text, and the option `-t "missing"` runs the tests whose name contains it. The root command `backstage-cli repo test --since origin/master` runs the tests of packages that changed compared with that Git ref, plus the packages that depend on them.

Run one file in the playground:

```sh
node --experimental-strip-types --test packages/backend/src/health.test.ts
```

Only the two tests of that file run. A subset is faster, but it can miss a break in another package. The full run before a merge covers that.

## Reading a failure

A failed test prints the test name, the expected value, the actual value and the line of the assertion. Read the name first: it states the behavior that broke. Then compare the two values. Change the code that is wrong. Do not change the expectation unless the behavior was meant to change, because then the test no longer guards the old behavior.

Break a test on purpose and read the output:

```sh
sed -i "s/'ok' : 'degraded'/'degraded' : 'ok'/" packages/backend/src/health.ts
yarn test
git checkout packages/backend/src/health.ts
```

Both tests fail, and each failure names the compared values. The last command restores the file.

## What tests prove

A passing test proves the behavior that the test checks, and nothing more. It does not prove that the types are right, that the code style is followed, or that a behavior without a test works. This is why a project runs several different checks.

## What this part showed

You saw that `backstage-cli` runs Jest for one package or for the whole repository, that watch mode is the development loop and a single run is the pipeline form, and that you can run a subset by path, by name or by changed packages. The next question is what checks the code without running it, which is the job of the linter.

## Common pitfalls

> [!WARNING]
> Do not edit a failing test to make it pass unless the behavior was meant to change. Do not rely on watch mode in a pipeline: it never exits. A subset run that passes does not prove that packages that depend on the change still pass.

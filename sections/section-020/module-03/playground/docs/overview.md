# Overview: Testing, Linting And Formatting Workflow (Playground)

This is a playground, not a lab. It starts an Ubuntu virtual machine with a small portal workspace and waits. There is no task, no `astrona submit` and no pass or fail. Change files, break the checks, run `astrona destroy` and start again.

## What is in the box

- Node.js 22, Yarn 4 (through Corepack) and Git. Open a shell with `astrona ssh ats-069-playground-020-03`.
- `/opt/portal` with `packages/app`, `packages/backend` and `packages/catalog-common`.
- `yarn tsc`, `yarn lint`, `yarn format:check`, `yarn test` and `yarn check`, which runs the four in order and stops at the first failure.
- `yarn lint:changed`, which lints only the files that differ from the last commit, and `yarn format`, which rewrites files to the format rules.
- `.githooks/pre-commit`, a Git hook that runs `yarn check`. `git config core.hooksPath` points to `.githooks`.

## Practice tasks

- Run `yarn check` and read the output of each step.
- Add `console.debug('x');` to `packages/backend/src/health.ts`. Run `yarn lint`, then `yarn tsc`, and compare.
- Indent a line with a tab. Run `yarn format:check`, then `yarn format`, then `git diff`.
- Change `packages/backend/src/health.ts` so a test fails. Run `git commit -am test` and read why the hook stops the commit.
- Run `git commit --no-verify` with a broken file and see that the hook is skipped.
- Edit one file and compare `yarn lint` with `yarn lint:changed`.

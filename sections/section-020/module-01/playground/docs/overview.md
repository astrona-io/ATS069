# Overview: Change And Feedback Workflow (Playground)

This is a playground, not a lab. It starts an Ubuntu virtual machine with a small portal workspace and waits. There is no task, no `astrona submit` and no pass or fail. Change files, break the checks, run `astrona destroy` and start again.

## What is in the box

- Node.js 22, Yarn 4 (through Corepack) and Git. Open a shell with `astrona ssh ats-069-playground-020-01`.
- `/opt/portal`, a Yarn workspace with three packages: `packages/app` (browser-side logic), `packages/backend` (a small HTTP server) and `packages/catalog-common` (shared types).
- The scripts `yarn tsc`, `yarn lint`, `yarn test` and `yarn start`. The helper `portal-check` runs the first three and prints one line for each.
- `app-config.yaml` (shared), `app-config.local.yaml` (a local override that Git ignores) and `app-config.production.yaml`. The script `scripts/show-config.py` prints the merge of the files you name.
- A Git repository with one commit, so `git status` and `git diff` show every change you make.

## Practice tasks

- Run `portal-check`, then change `packages/catalog-common/src/index.ts` (for example rename `owner` to `ownedBy`) and run `yarn tsc`. Read which package reports the error.
- Break one test on purpose in `packages/app/src/ownerWarning.ts` and run `yarn test`. Compare what `yarn tsc` says with what the test says.
- Add a line with `: any` to a source file and run `yarn lint`.
- Start the backend with `yarn start`, change the file `packages/backend/src/index.ts` in a second shell and watch the process restart.
- Run `python3 scripts/show-config.py app-config.yaml app-config.local.yaml` and compare it with the same command without the local file.
- Run `git status` after editing `app-config.local.yaml`, then remove the line `app-config.local.yaml` from `.gitignore` and run `git status` again.

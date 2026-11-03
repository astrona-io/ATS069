---
draft: true
exam_objectives:
- Understand local development workflows
---
# One Check Command, CI And Git Hooks

A developer who must remember four commands will sometimes forget one, and the pipeline then fails after the push. This part shows how to combine the checks into one command, how a CI pipeline repeats them, and how a Git hook runs them before a commit leaves the machine.

## One command that matches the pipeline

A continuous integration (CI) pipeline is a job on a server that runs the checks for every pull request. A generated Backstage project includes a GitHub Actions workflow that installs the dependencies with `yarn install --immutable`, and then runs the type check, the build, the lint, the format check and the tests. The exact list differs by project, so read the workflow file in `.github/workflows` to see it.

A developer should run the same commands before pushing. The simplest way is a root script that joins them with `&&`. The operator `&&` runs the next command only if the previous one exited with code 0, so the chain stops at the first failure.

<!-- astrona:playground:renew -->

The playground already has such a script. Read it and run it:

```sh
cd /opt/portal
grep '"check"' package.json
yarn check
```

The script runs `yarn tsc`, `yarn lint`, `yarn format:check` and `yarn test` in this order. When all pass, the final exit code is 0. Order the fast checks first, so that a failure shows up in seconds and not after the slow tests.

## Same commands, same result

The local check is useful only if it matches the pipeline. If the pipeline runs `tsc:full` and a developer runs only `tsc`, the pipeline can fail on something that passed locally. Also match the versions: the pipeline uses the versions in the lockfile, and so does a developer who runs `yarn install --immutable`. A different Node.js version can change results, so a project often pins it in a `.nvmrc` file or in the `engines` field.

## Git hooks

A Git hook is an executable file that Git runs at a fixed moment. The `pre-commit` hook runs before Git records a commit. If it exits with a non-zero code, Git cancels the commit. Hooks live in the folder `.git/hooks` by default. That folder is not part of the repository, so other developers do not receive it.

The setting `core.hooksPath` tells Git to read hooks from another folder. If the folder is inside the repository, such as `.githooks`, everyone who sets the option gets the same hooks. Look at the playground setup:

```sh
git config core.hooksPath
cat .githooks/pre-commit
```

The hook changes to the repository root and runs `yarn check`. Try a commit that fails a check:

```sh
echo "export const broken: number = 'text';" >> packages/app/src/label.ts
git commit -am "broken change"
git checkout packages/app/src/label.ts
```

Git runs the hook, the type check fails, and Git prints that the commit was not made. The file is restored by the last command.

## Hook tools and limits

Projects often use a tool such as Husky to install hooks with `yarn install`, and lint-staged to run checks only on the files in the commit. Both are optional and are not part of a default generated Backstage project. A slow hook annoys developers, so many projects run only format and lint in the hook and leave the tests to the pipeline.

A hook is a convenience, not a guarantee. The command `git commit --no-verify` skips it, and a developer who never set `core.hooksPath` does not run it. The pipeline is the check that cannot be skipped, so it must run the full set of checks regardless of the hooks.

## What this part showed

You saw how one `check` script joins the four checks in a fixed order, why it must match the pipeline, how a `pre-commit` hook runs it, and why the hook cannot replace the pipeline. This completes the local workflow: change, get fast feedback, run every check, and let the pipeline confirm.

## Common pitfalls

> [!WARNING]
> Do not rely on a hook alone: `--no-verify` skips it and a fresh clone does not have it. Do not make a hook so slow that people bypass it. If the pipeline and the local command run different checks, a green local run proves little.

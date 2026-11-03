---
draft: true
exam_objectives:
- Understand local development workflows
---
# Summary

A Backstage project checks its code in four ways. Tests, run by Jest through `backstage-cli`, check behavior. The linter, ESLint through `backstage-cli`, checks source patterns. Prettier checks formatting. The compiler `tsc` checks types. Each check finds a mistake that the others cannot see, so a change must pass all four.

The `package` commands work on one package and the `repo` commands work on all packages. Watch mode gives a fast development loop, while a single run with an exit code is the form that a pipeline needs. The option `--since` limits a run to the packages that changed, which saves time but can miss a break in a package that depends on them. Prettier has a check mode that changes nothing and a write mode that rewrites files, and formatting changes should stay apart from logic changes.

One root script that joins the checks with `&&` stops at the first failure and gives the developer the same result as the pipeline. The pipeline installs from the lockfile and runs the checks for every pull request. A `pre-commit` hook can run the script before each commit, and `core.hooksPath` lets a repository share its hooks. A hook can be skipped, so only the pipeline guarantees that the checks ran.

Key facts:

- `backstage-cli package test` runs one package and `backstage-cli repo test` runs all of them.
- A pipeline needs a run that exits, so watch mode is for developers only.
- `prettier --check` never changes files and `prettier --write` does.
- A passing test, lint, format check or type check proves only what that check covers.
- `git commit --no-verify` skips a hook, and `.git/hooks` is not shared through the repository.

<!-- astrona:playground:destroy -->

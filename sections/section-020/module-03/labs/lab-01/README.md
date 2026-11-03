---
estimated_duration: 25m
---

# Lab: Add A Check Script And A Pre-Commit Hook

Graded lab for the testing, linting and formatting module. **Status: UNTESTED.** It was built without booting the lab; run `astrona test -c .` before relying on it.

The virtual machine starts with a portal workspace in `/opt/portal` that has a lint problem, badly formatted code, no `check` script and a pre-commit hook that checks nothing. The workspace is a simplified fixture, not a Backstage application. The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS069.git -c sections/section-020/module-03/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS069.git -c sections/section-020/module-03/labs/lab-01
astrona destroy ats-069-lab-020-03
```

## Checks

| Script | What it proves |
| --- | --- |
| `validate-lint.sh` | `scripts/lint.mjs` exits 0 |
| `validate-format.sh` | `scripts/format.mjs --check` exits 0 |
| `validate-tests.sh` | The test files match their recorded checksum and `node --test` passes |
| `validate-check-script.sh` | The `check` script names all four steps and `yarn check` passes |
| `validate-hook.sh` | `core.hooksPath` is `.githooks`, the hook is executable, calls `yarn check` and stops a commit with a type error |

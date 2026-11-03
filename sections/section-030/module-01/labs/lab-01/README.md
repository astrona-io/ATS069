---
estimated_duration: 20m
---

# Lab: Fix The Check Scope And An Optional Value

Graded lab for the TypeScript checking module. **Status: UNTESTED.** It was built without booting the virtual machine; run `astrona test -c .` before relying on it.

The workspace in `/opt/portal` is a simplified fixture with the shape of a Backstage repository. It uses only the TypeScript compiler, not real Backstage packages. The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS069.git -c sections/section-030/module-01/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS069.git -c sections/section-030/module-01/labs/lab-01
astrona destroy ats-069-lab-030-01
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-scope-covers-all-packages.sh` | `tsc --listFilesOnly` lists the `index.ts` of the app package and of both plugins |
| `validate-type-check-passes.sh` | `tsc --noEmit` over the project exits with `0` |
| `validate-absence-handled-at-runtime.sh` | The compiled `describeOwner` returns `unassigned` without an owner and `ADA` for `ada` |
| `validate-strict-kept-no-escapes.sh` | `strict` is `true` and the plugin source has no `as`, `!` or `@ts-ignore` escape |
| `validate-check-writes-no-files.sh` | `noEmit` is `true` and no `.js` file sits in a `src` folder |

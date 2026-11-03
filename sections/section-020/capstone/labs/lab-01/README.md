---
estimated_duration: 40m
---

# Capstone Lab: Finish A Cross-Package Change

Graded capstone for the local development workflows section. **Status: UNTESTED.** It was built without booting the lab; run `astrona test -c .` before relying on it.

The portal workspace in `/opt/portal` has an unfinished deployment status feature across `catalog-common`, `backend` and `app`: type errors, failing tests, lint problems, a shared key that exists only in a local override, a plain-text secret and no change description. It is a simplified fixture, not a Backstage application. The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS069.git -c sections/section-020/capstone/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS069.git -c sections/section-020/capstone/labs/lab-01
astrona destroy ats-069-capstone-020-01
```

## Checks

| Script | What it proves |
| --- | --- |
| `validate-typecheck.sh` | `tsc --noEmit` exits 0 |
| `validate-tests.sh` | Test files match their checksum and `node --test` passes |
| `validate-lint.sh` | `node scripts/lint.mjs` exits 0 and the lint script is unchanged in Git |
| `validate-config.sh` | Shared key, environment password, local override kept and ignored |
| `validate-change-description.sh` | `CHANGE.md` has the three headings and names every changed package |

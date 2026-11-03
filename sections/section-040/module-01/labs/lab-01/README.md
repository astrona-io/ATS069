---
estimated_duration: 25m
---

# Lab: Make The Install Reproducible

Graded lab for the package manager module. **Status: UNTESTED.** It was built without booting the lab; run `astrona test -c .` before relying on it.

An Ubuntu 24.04 VM with Node.js 22 and a simplified Yarn 4 workspace in `/opt/portal` (not a generated Backstage app). One package asks for a range that no local workspace satisfies, one imports a package it does not declare, and `yarn.lock` is out of date. The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS069.git -c sections/section-040/module-01/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS069.git -c sections/section-040/module-01/labs/lab-01
astrona destroy ats-069-lab-040-01
```

## Checks

| Script | What it proves |
| --- | --- |
| `validate-app-range-matches-shared.sh` | The range of `@internal/shared` in `app` is `workspace:` or a range that version 1.0.0 satisfies |
| `validate-backend-declares-shared.sh` | The backend declares `@internal/shared` under `dependencies` |
| `validate-lockfile-lists-backend-dependency.sh` | The `backend` entry in `yarn.lock` lists `@internal/shared` |
| `validate-immutable-install-passes.sh` | `yarn install --immutable` exits with code 0 |
| `validate-project-setup-unchanged.sh` | `packageManager` is `yarn@4.4.1`, the shared version is 1.0.0, `nodeLinker: node-modules` stays and no `package-lock.json` exists |

`validate-project-setup-unchanged.sh` passes before any change and guards against fixing the install by replacing the tool.

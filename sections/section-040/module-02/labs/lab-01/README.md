---
estimated_duration: 25m
---

# Lab: Add Dependencies And Run Scripts In Every Workspace

Graded lab for the Yarn workflow module. **Status: UNTESTED.** It was built without booting the lab; run `astrona test -c .` before relying on it.

An Ubuntu 24.04 VM with Node.js 22 and a simplified Yarn 4 workspace in `/opt/portal` (not a generated Backstage app). The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS069.git -c sections/section-040/module-02/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS069.git -c sections/section-040/module-02/labs/lab-01
astrona destroy ats-069-lab-040-02
```

## Checks

| Script | What it proves |
| --- | --- |
| `validate-semver-not-at-root.sh` | The root manifest declares no `semver` |
| `validate-backend-declares-semver.sh` | The backend declares `semver` under `dependencies` |
| `validate-lint-all-script.sh` | The root script `lint:all` uses `yarn workspaces foreach` and exits with code 0 |
| `validate-lockfile-lists-backend-semver.sh` | The `backend` entry in `yarn.lock` lists `semver` |
| `validate-immutable-install-passes.sh` | `yarn install --immutable` exits with code 0 |
| `validate-project-setup-unchanged.sh` | `packageManager` is `yarn@4.4.1`, `backstage.json` is 1.30.0, `nodeLinker: node-modules` stays and no `package-lock.json` exists |

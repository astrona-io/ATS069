---
estimated_duration: 40m
---

# Capstone: Reproducible Dependencies For A CI Install

Graded capstone for the package manager section. **Status: UNTESTED.** It was built without booting the lab; run `astrona test -c .` before relying on it.

An Ubuntu 24.04 VM with Node.js 22 and a simplified Yarn 4 workspace in `/opt/portal` (not a generated Backstage app). The CI install script uses a plain install, the backend imports `semver` without declaring it, `legacy-tool` pulls in `semver` 5.x next to 7.x and a stray `package-lock.json` exists. The task is in `question.md`; the walkthrough is in `solution.md`. The bootstrap and the learner need internet access for the `semver` packages.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS069.git -c sections/section-040/capstone/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS069.git -c sections/section-040/capstone/labs/lab-01
astrona destroy ats-069-capstone-040-01
```

## Checks

| Script | What it proves |
| --- | --- |
| `validate-ci-install-is-immutable.sh` | `ci/install.sh` is executable, runs `yarn install --immutable` and runs no plain install |
| `validate-backend-declares-semver.sh` | The backend declares `semver` under `dependencies` |
| `validate-single-semver-release.sh` | `yarn.lock` holds exactly one `semver` release, 7.5.2 or later |
| `validate-legacy-tool-range-kept.sh` | `legacy-tool` keeps `^5.7.2` and the root manifest has a `resolutions` entry for `semver` |
| `validate-no-second-lockfile.sh` | `package-lock.json` is removed and `packageManager` is `yarn@4.4.1` |
| `validate-immutable-install-passes.sh` | `yarn install --immutable` exits with code 0 |

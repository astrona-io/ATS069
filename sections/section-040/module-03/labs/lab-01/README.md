---
estimated_duration: 25m
---

# Lab: Declare A Peer Dependency And Route A Scope To A Private Registry

Graded lab for the upgrade, audit and registry module. **Status: UNTESTED.** It was built without booting the lab; run `astrona test -c .` before relying on it.

An Ubuntu 24.04 VM with Node.js 22 and a simplified Yarn 4 workspace in `/opt/portal` (not a generated Backstage app). The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS069.git -c sections/section-040/module-03/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS069.git -c sections/section-040/module-03/labs/lab-01
astrona destroy ats-069-lab-040-03
```

## Checks

| Script | What it proves |
| --- | --- |
| `validate-plugin-peer-declared.sh` | The plugin lists `@internal/shared` in `peerDependencies` (not with `workspace:`) and in `devDependencies` |
| `validate-token-not-in-file.sh` | No `npm_FAKE` token remains in `.yarnrc.yml` |
| `validate-scope-routed.sh` | `npmScopes` routes `internal` to the private server and reads `NPM_TOKEN` |
| `validate-why-answer.sh` | `answers.txt` names `backend` and `@internal/plugin` |
| `validate-immutable-install-passes.sh` | `yarn install --immutable` exits with code 0 |
| `validate-project-setup-unchanged.sh` | `packageManager` is `yarn@4.4.1`, the shared version is 1.0.0, `nodeLinker: node-modules` stays and no `package-lock.json` exists |

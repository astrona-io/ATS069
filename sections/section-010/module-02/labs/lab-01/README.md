---
estimated_duration: 20m
---

# Lab: Repair A Scaffolded Project

Graded lab for the project creation module. **Status: UNTESTED.** It was built without booting the lab; run `astrona test -c .` before relying on it.

The workspace `/opt/scaffold` is a small stand-in with the layout of a project made by `@backstage/create-app`, with four faults in its `package.json` files. The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS069.git -c sections/section-010/module-02/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS069.git -c sections/section-010/module-02/labs/lab-01
astrona destroy ats-069-lab-010-02
```

## Checks

| Script | What it proves |
| --- | --- |
| `validate-workspaces-include-plugins.sh` | The workspaces field lists `packages/*` and `plugins/*` and Yarn sees the backend plugin |
| `validate-engines-allow-node-22.sh` | `tools/check-env.js` accepts the installed Node.js |
| `validate-package-manager-is-yarn-4.sh` | `packageManager` is `yarn@4.x` |
| `validate-backend-plugin-has-role.sh` | `plugins/status-backend` has `backstage.role` set to `backend-plugin` |
| `validate-packages-kept.sh` | No package or record was deleted |

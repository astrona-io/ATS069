---
estimated_duration: 25m
---

# Lab: Start The Backend And Build A Runnable Artifact

Graded lab for the local projects module. **Status: UNTESTED.** It was built without booting the lab; run `astrona test -c .` before relying on it.

The workspace `/opt/portal` is a small stand-in with the shape of a Backstage project, with three faults: a start script with the wrong configuration path, a missing `backend.listen.port` and a build script that copies one file. The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS069.git -c sections/section-010/module-01/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS069.git -c sections/section-010/module-01/labs/lab-01
astrona destroy ats-069-lab-010-01
```

## Checks

| Script | What it proves |
| --- | --- |
| `validate-backend-config-complete.sh` | `app-config.yaml` has the three required keys and port 7007 |
| `validate-backend-starts-from-source.sh` | `yarn workspace backend start` answers `/healthcheck` |
| `validate-backend-build-complete.sh` | `dist` holds `index.js` and `config.js` |
| `validate-production-artifact-runs.sh` | The built backend runs with both configuration files and reports `production` |
| `validate-sources-kept.sh` | The source files and build script still exist |

The validation scripts start their own backend on port 7007. A process left running by the learner can hide a failure.

---
estimated_duration: 40m
---

# Capstone: Start, Configure And Build A Portal Workspace

Graded capstone for the section on building and running Backstage projects locally. **Status: UNTESTED.** It was built without booting the lab; run `astrona test -c .` before relying on it.

The workspace `/opt/portal` is a small stand-in with the shape of a Backstage project. It starts with four faults: a start script with the wrong configuration path, an app port that does not match `app.baseUrl`, a token under `app`, and a `build:all` script that builds only the backend. The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS069.git -c sections/section-010/capstone/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS069.git -c sections/section-010/capstone/labs/lab-01
astrona destroy ats-069-capstone-010-01
```

## Checks

| Script | What it proves |
| --- | --- |
| `validate-backend-starts-from-source.sh` | The backend answers `/healthcheck` on 7007 |
| `validate-app-starts-on-3000.sh` | The app server answers on 3000 |
| `validate-secret-not-browser-visible.sh` | The token is not in `/config.json` and `backend.githubToken` still holds it |
| `validate-build-all-builds-both.sh` | `yarn build:all` creates both `dist` folders with their files |
| `validate-artifacts-run-alone.sh` | Both artifacts run alone and the built `config.json` holds no token |

The validation scripts start their own processes on ports 3000 and 7007. `validate-build-all-builds-both.sh` deletes both `dist` folders and builds again.

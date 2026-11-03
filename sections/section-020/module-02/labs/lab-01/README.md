---
estimated_duration: 25m
---

# Lab: Wire A New Plugin Into The Backend

Graded lab for the plugin development module. **Status: UNTESTED.** It was built without booting the lab; run `astrona test -c .` before relying on it.

The virtual machine starts with a portal workspace in `/opt/portal` where a backend plugin exists but is not part of the workspace, uses a wrong id, is not added to the backend and is not declared as a dependency. The workspace is a simplified fixture, not a Backstage application. The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS069.git -c sections/section-020/module-02/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS069.git -c sections/section-020/module-02/labs/lab-01
astrona destroy ats-069-lab-020-02
```

## Checks

| Script | What it proves |
| --- | --- |
| `validate-plugin-in-workspace.sh` | `yarn workspaces list` shows `plugins/hello-backend` |
| `validate-plugin-id.sh` | The test files match their recorded checksum and the plugin tests pass |
| `validate-backend-adds-plugin.sh` | The backend source calls `backend.add(helloBackendPlugin)` |
| `validate-backend-dependency.sh` | The backend declares the plugin with a `workspace:` version |
| `validate-route-answers.sh` | The started backend answers `/api/hello/greeting` with status 200 |

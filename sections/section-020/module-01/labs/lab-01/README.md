---
estimated_duration: 25m
---

# Lab: Make A Change Reviewable

Graded lab for the change and feedback module. **Status: UNTESTED.** It was built without booting the lab; run `astrona test -c .` before relying on it.

The virtual machine starts with a portal workspace in `/opt/portal` that has a type error, a wrong test result, a shared configuration key that exists only in a local override, a plain-text secret and an unignored local file. The workspace is a simplified fixture, not a Backstage application. The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS069.git -c sections/section-020/module-01/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS069.git -c sections/section-020/module-01/labs/lab-01
astrona destroy ats-069-lab-020-01
```

## Checks

| Script | What it proves |
| --- | --- |
| `validate-typecheck.sh` | `tsc --noEmit` exits 0 |
| `validate-owner-states.sh` | The test files match their recorded checksum and `node --test` passes |
| `validate-shared-config.sh` | `app-config.yaml` has `catalog.ownerWarning.enabled: true`; the local file has no `catalog` key and keeps port 7008 |
| `validate-no-plaintext-secret.sh` | The password is `${BACKEND_DB_PASSWORD}` and `hunter2` appears in no config file |
| `validate-local-override-ignored.sh` | `git check-ignore` matches the local file and Git does not track it |

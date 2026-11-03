---
estimated_duration: 20m
---

# Lab: Repair The Local Configuration

Graded lab for the database, ports and integrations module. **Status: UNTESTED.** It was built without booting the lab; run `astrona test -c .` before relying on it.

The folder `/opt/envcfg` holds configuration files shaped like those of a Backstage project, with four wrong values. The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS069.git -c sections/section-010/module-03/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS069.git -c sections/section-010/module-03/labs/lab-01
astrona destroy ats-069-lab-010-03
```

## Checks

| Script | What it proves |
| --- | --- |
| `validate-cors-origin-matches-app.sh` | `backend.cors.origin` equals `app.baseUrl` |
| `validate-guest-sign-in-development-only.sh` | Guest sign-in is in the base file and not in the production file |
| `validate-catalog-location-resolves.sh` | The `file` location resolves to an existing file |
| `validate-production-password-from-environment.sh` | The production password is `${POSTGRES_PASSWORD}` |
| `validate-files-kept.sh` | No file was deleted and the database clients are unchanged |

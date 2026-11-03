# Lab: Run The Image With Runtime Configuration

Graded lab for the module on running and securing the image. **Status: UNTESTED.** It was built without booting the lab; run `astrona test -c .` before relying on it.

The virtual machine starts with a built image `portal:run`, a runtime configuration file and an environment file. Nothing runs. The task is to start the container with a mounted configuration file, a published port, a run-time token, hardened options, a health check and a restart policy. The workspace is a fixture, not a real Backstage application. The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS069.git -c sections/section-050/module-03/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS069.git -c sections/section-050/module-03/labs/lab-01
astrona destroy ats-069-lab-050-03
```

## Checks

| Script | What it proves |
| --- | --- |
| `validate-container-running.sh` | A container named `portal` runs from `portal:run` |
| `validate-runtime-config.sh` | The runtime file is a read-only mount and the three files load in order |
| `validate-published-port.sh` | Host port 7007 answers `/healthcheck` |
| `validate-token-at-runtime.sh` | `PORTAL_TOKEN` reaches the process and is absent from the image |
| `validate-hardened.sh` | Non-root user, read-only root filesystem, all capabilities dropped, `no-new-privileges` |
| `validate-health.sh` | The health status is `healthy` and the restart policy is `unless-stopped` |
| `validate-image-unchanged.sh` | The image id still matches `/etc/portal-lab/image.id` |

The reference solution is `solution/apply.sh`, run by `astrona test`.

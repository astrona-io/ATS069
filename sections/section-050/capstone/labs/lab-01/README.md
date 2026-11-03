# Capstone Lab: Multi-Stage Image And Runtime Configuration

Graded capstone for the Docker image section. **Status: UNTESTED.** It was built without booting the lab; run `astrona test -c .` before relying on it.

The virtual machine starts with a simplified portal workspace (a fixture, not a real Backstage application) and a multi-stage `Dockerfile` with four faults: the `.dockerignore` removes the source the build stage needs, the final stage copies the whole build tree, the final stage runs as root, and the `CMD` loads only the base config file, so the server binds to the loopback address. The learner also starts a container and passes a token at run time.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS069.git -c sections/section-050/capstone/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS069.git -c sections/section-050/capstone/labs/lab-01
astrona destroy ats-069-capstone-050-01
```

## Checks

| Script | What it proves |
| --- | --- |
| `validate-image-built.sh` | `backstage:multistage` exists and the root `Dockerfile` has at least two `FROM` lines |
| `validate-dockerignore.sh` | `.dockerignore` does not exclude `packages/*/src` and does exclude `*.local.yaml` |
| `validate-final-stage-contents.sh` | No source, `scripts` directory, local config file or secret in the image |
| `validate-runs-as-non-root.sh` | `id -u` in the image is not 0 |
| `validate-bundle-matches-source.sh` | `build-id` in the image equals the source `build-id` |
| `validate-container-running.sh` | `portal-backend` runs the current image and answers `/healthcheck` on 7007 |
| `validate-token-at-runtime.sh` | `/status` reports the token, and `PORTAL_TOKEN` is not in the image environment or history |
| `validate-source-unchanged.sh` | The backend source matches `/etc/portal-lab/source.sha256` |

The reference solution is `solution/apply.sh`, run by `astrona test`.

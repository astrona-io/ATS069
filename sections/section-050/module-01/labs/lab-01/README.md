# Lab: Package The Backend As A Container Image

Graded lab for the Docker image module. **Status: UNTESTED.** It was built without booting the lab; run `astrona test -c .` before relying on it.

The virtual machine starts with a simplified portal workspace and a host-build Dockerfile that has four faults: the `.dockerignore` removes the bundle, the bundle is stale, the container runs as root and the local configuration file is copied into the image. The workspace is a fixture, not a real Backstage application. The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS069.git -c sections/section-050/module-01/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS069.git -c sections/section-050/module-01/labs/lab-01
astrona destroy ats-069-lab-050-01
```

## Checks

| Script | What it proves |
| --- | --- |
| `validate-image-built.sh` | The image `backstage:lab` exists |
| `validate-runs-as-non-root.sh` | `id -u` inside the image is not 0 |
| `validate-no-local-config-in-image.sh` | `/app/app-config.local.yaml` and the secret string are not in the image |
| `validate-bundle-matches-source.sh` | `build-id` inside the image equals the source `build-id` |
| `validate-serves-on-7007.sh` | A container answers `/healthcheck` on a published port (host port 17007) |
| `validate-source-unchanged.sh` | `packages/backend/src` still matches the seed checksums in `/etc/portal-lab/source.sha256` |

The reference solution is `solution/apply.sh`, run by `astrona test`.

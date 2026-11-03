# Lab: Make The Image Build Small And Cacheable

Graded lab for the Dockerfile layers module. **Status: UNTESTED.** It was built without booting the lab; run `astrona test -c .` before relying on it.

The virtual machine starts with a simplified portal workspace and a host-build Dockerfile with three faults: the `.dockerignore` does not exclude a large `recordings` folder or local configuration files, the Dockerfile copies the whole context with `COPY . .`, and the cache is invalidated by any file change. The workspace is a fixture, not a real Backstage application. The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS069.git -c sections/section-050/module-02/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS069.git -c sections/section-050/module-02/labs/lab-01
astrona destroy ats-069-lab-050-02
```

## Checks

| Script | What it proves |
| --- | --- |
| `validate-image-built.sh` | The image `backstage:cache` exists and a container answers `/healthcheck` on host port 17007 |
| `validate-context-excluded.sh` | A probe image shows no `recordings` and no local file in the context, and the bundle is present |
| `validate-no-local-config-in-image.sh` | The image holds no `app-config.local.yaml`, no secret and no `recordings` |
| `validate-cache-stable.sh` | After a change to `docs/notes.md`, the bundle unpack step is cached |
| `validate-source-unchanged.sh` | `packages/backend/src` still matches the seed checksums |

The reference solution is `solution/apply.sh`, run by `astrona test`.

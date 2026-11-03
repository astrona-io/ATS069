---
estimated_duration: 25m
---

# Lab: Package Roles, Build Scripts And A Hidden Type Error

Graded lab for the build pipeline module. **Status: UNTESTED.** It was built without booting the virtual machine; run `astrona test -c .` before relying on it.

The workspace in `/opt/portal` is a simplified fixture with the shape of a Backstage repository. It has no `backstage-cli`; a transpile-only `tsc --noCheck` build stands in for the Backstage build. The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS069.git -c sections/section-030/module-03/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS069.git -c sections/section-030/module-03/labs/lab-01
astrona destroy ats-069-lab-030-03
```

## Checks

| Script | What it proves |
| --- | --- |
| `validate-every-package-has-role.sh` | The four packages have the roles `frontend`, `backend`, `common-library` and `backend-plugin` |
| `validate-build-all-builds-every-package.sh` | After the `dist` folders are removed, `npm run build:all` writes `dist/index.js` in all four packages |
| `validate-published-files-include-dist.sh` | Every `files` field lists `dist` |
| `validate-type-check-passes.sh` | `npm run tsc` exits with `0` |
| `validate-built-backend-plugin-behaves.sh` | The built `describeBackend('abc')` returns `abc (3)` |
| `validate-no-escapes-and-build-kept.sh` | The source has no `any`, `as` or ts comment directive and the build script still has `--noCheck` |

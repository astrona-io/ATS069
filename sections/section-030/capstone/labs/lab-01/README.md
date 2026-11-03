---
estimated_duration: 35m
---

# Capstone: Build A TypeScript Workspace In Dependency Order

Graded capstone for the TypeScript section. **Status: UNTESTED.** It was built without booting the virtual machine; run `astrona test -c .` before relying on it.

The workspace in `/opt/portal` is a simplified fixture with the shape of a Backstage repository. It uses only the TypeScript compiler, not real Backstage packages. The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS069.git -c sections/section-030/capstone/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS069.git -c sections/section-030/capstone/labs/lab-01
astrona destroy ats-069-capstone-030-01
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-root-references-all-projects.sh` | The merged root configuration lists the three projects in `references` |
| `validate-backend-references-common.sh` | The merged `deploy-backend` configuration references `deploy-common` |
| `validate-clean-build-passes.sh` | `tsc --build --force` exits with `0` |
| `validate-declarations-emitted.sh` | `dist/index.js` and `dist/index.d.ts` exist in all three projects |
| `validate-parser-rejects-invalid-status.sh` | The compiled `parseDeployment` accepts a valid record and throws for status `done` |
| `validate-app-validates-input.sh` | The app calls `parseDeployment` and has no assertion, `any` or ts directive; `strict` is on |
| `validate-build-all-script.sh` | `scripts["build:all"]` runs `tsc --build` or `tsc -b` |

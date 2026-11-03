---
estimated_duration: 25m
---

# Lab: Extend The Shared Base And Add The Check Scripts

Graded lab for the shared configuration module. **Status: UNTESTED.** It was built without booting the virtual machine; run `astrona test -c .` before relying on it.

The workspace in `/opt/portal` is a simplified fixture with the shape of a Backstage repository. It uses only the TypeScript compiler. The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS069.git -c sections/section-030/module-02/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS069.git -c sections/section-030/module-02/labs/lab-01
astrona destroy ats-069-lab-030-02
```

## Checks

| Script | What it proves |
| --- | --- |
| `validate-extends-shared-base.sh` | `tsconfig.json` extends `./tsconfig.base.json` and does not set `strict` to `false` |
| `validate-strict-in-effect.sh` | The merged `strict` is `true` and the source has no `any`, `@ts-ignore` or similar escape |
| `validate-type-check-passes.sh` | `tsc -p tsconfig.json` exits with `0` |
| `validate-declarations-in-dist-types.sh` | The check writes `dist-types/.../index.d.ts` and no `.js` or `.d.ts` file next to a source |
| `validate-full-check-script.sh` | `tsc:full` has both flags and `npm run tsc:full` passes |
| `validate-build-output-ignored.sh` | `.gitignore` has a `dist-types` line |

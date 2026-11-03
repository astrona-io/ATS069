# Shared tsconfig, Strictness And Type Check Scripts - Playground

- **Slug:** ats-069-playground-030-02
- **Type:** Astrona playground, a clean environment with no task and no grading
- **Status:** UNTESTED. Built from static checks only (`astrona validate`).

An Ubuntu 24.04 virtual machine with Node.js 22 and TypeScript 5.8.3. The workspace `/opt/portal` has a shared `tsconfig.base.json`, a root `tsconfig.json` that extends it, the `tsc` and `tsc:full` scripts and a declaration file with an error that only the full check reports. It is not a real Backstage application.

## Run it

```sh
astrona run -c .
astrona ssh ats-069-playground-030-02
astrona destroy ats-069-playground-030-02
```

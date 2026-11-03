# Backstage Build Pipelines And Package Roles - Playground

- **Slug:** ats-069-playground-030-03
- **Type:** Astrona playground, a clean environment with no task and no grading
- **Status:** UNTESTED. Built from static checks only (`astrona validate`).

An Ubuntu 24.04 virtual machine with Node.js 22 and TypeScript 5.8.3. The workspace `/opt/portal` has four packages with Backstage roles, a root type check and a build script that transpiles without checking types. It is not a real Backstage application and has no `backstage-cli`.

## Run it

```sh
astrona run -c .
astrona ssh ats-069-playground-030-03
astrona destroy ats-069-playground-030-03
```

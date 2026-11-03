# TypeScript Checking And Workspace Builds - Playground

- **Slug:** ats-069-playground-030-01
- **Type:** Astrona playground, a clean environment with no task and no grading
- **Status:** UNTESTED. Built from static checks only (`astrona validate`, `bash -n`).

An Ubuntu 24.04 virtual machine with Node.js 22 and TypeScript 5.8.3. The folder `/opt/portal` holds a small workspace with three packages (`plugins/deploy-common`, `plugins/deploy-backend`, `packages/app`). It has the shape of a Backstage repository but it is a simplified fixture, not a real Backstage app.

## Run it

```sh
astrona run -c .
astrona ssh ats-069-playground-030-01
astrona destroy ats-069-playground-030-01
```

`astrona destroy` takes the environment name, not the config path.

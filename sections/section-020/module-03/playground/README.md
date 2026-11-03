# Testing, Linting And Formatting Workflow - Playground

- **Slug:** ats-069-playground-020-03
- **Type:** Astrona playground, a clean environment with no task and no grading
- **Status:** UNTESTED. Built from static checks only (`astrona validate`).

An Ubuntu 24.04 virtual machine with Node.js 22, Yarn and Git. The directory `/opt/portal` holds a small Yarn workspace with the packages `app`, `backend` and `catalog-common`. The root `package.json` has the scripts `tsc`, `lint`, `lint:changed`, `format:check`, `format`, `test` and `check`. Git runs the hook `.githooks/pre-commit` before every commit. It is a simplified fixture: the scripts are small stand-ins for `backstage-cli`, Jest and Prettier. All checks pass at the start.

## Run it

```sh
astrona run -c .
astrona ssh ats-069-playground-020-03
astrona destroy ats-069-playground-020-03
```

`astrona destroy` takes the environment name, not the config path. The virtual machine needs internet access when it starts.

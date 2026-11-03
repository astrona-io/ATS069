# Package Managers And Lockfiles - Playground

- **Slug:** ats-069-playground-040-01
- **Type:** Astrona playground, a clean environment with no task and no grading
- **Status:** UNTESTED. Built from static checks only (`astrona validate`).

An Ubuntu 24.04 virtual machine with Node.js 22 and Yarn 4.4.1 (a release file committed under `/opt/portal/.yarn/releases`). `/opt/portal` is a Yarn workspace with the packages `app`, `backend` and `@internal/shared`. It has the shape of a Backstage workspace but is a simplified fixture, not a generated Backstage app. `/opt/npm-demo` is a small npm project with a `package-lock.json`. The bootstrap needs internet access.

## Run it

```sh
astrona run -c .
astrona ssh ats-069-playground-040-01
astrona destroy ats-069-playground-040-01
```

`astrona destroy` takes the environment name, not the config path.

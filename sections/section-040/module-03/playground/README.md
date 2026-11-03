# Upgrading, Auditing And Private Registries - Playground

- **Slug:** ats-069-playground-040-03
- **Type:** Astrona playground, a clean environment with no task and no grading
- **Status:** UNTESTED. Built from static checks only (`astrona validate`).

An Ubuntu 24.04 virtual machine with Node.js 22 and Yarn 4.4.1 (a release file committed under `/opt/portal/.yarn/releases`). `/opt/portal` is a simplified Yarn workspace with the shape of a Backstage workspace, not a generated Backstage app. The bootstrap needs internet access.

## Run it

```sh
astrona run -c .
astrona ssh ats-069-playground-040-03
astrona destroy ats-069-playground-040-03
```

`astrona destroy` takes the environment name, not the config path.

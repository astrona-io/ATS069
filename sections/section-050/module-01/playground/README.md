# Container Image Build - Playground

- **Slug:** ats-069-playground-050-01
- **Type:** Astrona playground, a clean environment with no task and no grading
- **Status:** UNTESTED. Built from static checks only (`astrona validate`).

An Ubuntu 24.04 virtual machine with Node.js 22 and Docker Engine. The directory `/opt/portal` holds a simplified portal workspace: an `app` and a `backend` package, three `app-config` files, a build script that writes `packages/backend/dist/bundle.tar.gz`, a host-build `Dockerfile` in `packages/backend`, a multi-stage `Dockerfile.multistage` at the root and a `.dockerignore`. The workspace has the shape of a Backstage project but is not a real Backstage application.

## Run it

```sh
astrona run -c .
astrona ssh ats-069-playground-050-01
astrona destroy ats-069-playground-050-01
```

`astrona destroy` takes the environment name, not the config path.

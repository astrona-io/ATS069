# Local Projects, Development Servers And Production Builds - Playground

- **Slug:** ats-069-playground-010-01
- **Type:** Astrona playground, a clean environment with no task and no grading
- **Status:** UNTESTED. Built from static checks only (`astrona validate`).

An Ubuntu 24.04 virtual machine with Node.js 22 and Yarn 4. The workspace `/opt/portal` is a small stand-in with the shape of a Backstage project: a root `package.json`, an `app` package, a `backend` package and two configuration files. It is not a real Backstage application.

## Run it

```sh
astrona run -c .
astrona ssh ats-069-playground-010-01
astrona destroy ats-069-playground-010-01
```

`astrona destroy` takes the environment name, not the config path.

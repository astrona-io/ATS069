# Running And Securing The Image - Playground

- **Slug:** ats-069-playground-050-03
- **Type:** Astrona playground, a clean environment with no task and no grading
- **Status:** UNTESTED. Built from static checks only (`astrona validate`).

An Ubuntu 24.04 virtual machine with Node.js 22 and Docker. The image `portal:run` is already built from a stand-in backend in `/opt/portal`, with a runtime configuration file and an environment file. It is not a real Backstage application.

## Run it

```sh
astrona run -c .
astrona ssh ats-069-playground-050-03
astrona destroy ats-069-playground-050-03
```

`astrona destroy` takes the environment name, not the config path.

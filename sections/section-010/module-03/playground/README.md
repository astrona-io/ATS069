# Database, Ports, Proxies And Local Integrations - Playground

- **Slug:** ats-069-playground-010-03
- **Type:** Astrona playground, a clean environment with no task and no grading
- **Status:** UNTESTED. Built from static checks only (`astrona validate`).

An Ubuntu 24.04 virtual machine with Node.js 22, Yarn 4 and Python 3 with PyYAML. The folder `/opt/envcfg` holds configuration files shaped like those of a Backstage project: a base file with a development setup and a production override file. It also holds an example catalog entity file and a checker script. It is not a running Backstage application.

## Run it

```sh
astrona run -c .
astrona ssh ats-069-playground-010-03
astrona destroy ats-069-playground-010-03
```

`astrona destroy` takes the environment name, not the config path.

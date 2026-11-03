# Developing Plugins Locally - Playground

- **Slug:** ats-069-playground-020-02
- **Type:** Astrona playground, a clean environment with no task and no grading
- **Status:** UNTESTED. Built from static checks only (`astrona validate`).

An Ubuntu 24.04 virtual machine with Node.js 22, Yarn and Git. The directory `/opt/portal` holds a small Yarn workspace with the shape of a Backstage project: the packages `app` and `backend`, a frontend plugin in `plugins/hello`, a backend plugin in `plugins/hello-backend`, a `dev/` entry point in each plugin, and a Git history with one commit. It is a simplified fixture, not a generated Backstage application, and it does not install the Backstage packages.

## Run it

```sh
astrona run -c .
astrona ssh ats-069-playground-020-02
astrona destroy ats-069-playground-020-02
```

`astrona destroy` takes the environment name, not the config path. The virtual machine needs internet access when it starts.

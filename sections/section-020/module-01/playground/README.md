# Change And Feedback Workflow - Playground

- **Slug:** ats-069-playground-020-01
- **Type:** Astrona playground, a clean environment with no task and no grading
- **Status:** UNTESTED. Built from static checks only (`astrona validate`).

An Ubuntu 24.04 virtual machine with Node.js 22 and Yarn. The directory `/opt/portal` holds a small Yarn workspace with the shape of a Backstage project: the packages `app`, `backend` and `catalog-common`, the files `app-config.yaml` and `app-config.local.yaml`, and a Git history with one commit. It is a simplified fixture, not a generated Backstage application. All checks pass at the start.

## Run it

```sh
astrona run -c .
astrona ssh ats-069-playground-020-01
astrona destroy ats-069-playground-020-01
```

`astrona destroy` takes the environment name, not the config path. The virtual machine needs internet access when it starts.

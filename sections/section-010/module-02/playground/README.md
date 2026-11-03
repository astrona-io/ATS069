# Backstage CLI, Scaffolding And Project Creation - Playground

- **Slug:** ats-069-playground-010-02
- **Type:** Astrona playground, a clean environment with no task and no grading
- **Status:** UNTESTED. Built from static checks only (`astrona validate`).

An Ubuntu 24.04 virtual machine with Node.js 22 and Yarn 4. The workspace `/opt/scaffold` is a small stand-in with the layout of a project made by `@backstage/create-app`: a root `package.json`, `backstage.json`, `app` and `backend` packages and two plugin packages. It has no registry dependencies, so the `backstage-cli` commands in its scripts are not installed.

## Run it

```sh
astrona run -c .
astrona ssh ats-069-playground-010-02
astrona destroy ats-069-playground-010-02
```

`astrona destroy` takes the environment name, not the config path.

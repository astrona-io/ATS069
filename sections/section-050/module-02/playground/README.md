# Dockerfile Layers, Caching And Build Context - Playground

- **Slug:** ats-069-playground-050-02
- **Type:** Astrona playground, a clean environment with no task and no grading
- **Status:** UNTESTED. Built from static checks only (`astrona validate`).

An Ubuntu 24.04 virtual machine with Node.js 22 and Docker. The workspace `/opt/portal` is a small stand-in with the shape of a Backstage project, plus a large `recordings` folder and two BuildKit demo Dockerfiles. It is not a real Backstage application.

## Run it

```sh
astrona run -c .
astrona ssh ats-069-playground-050-02
astrona destroy ats-069-playground-050-02
```

`astrona destroy` takes the environment name, not the config path.

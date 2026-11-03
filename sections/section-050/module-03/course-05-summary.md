---
draft: true
exam_objectives:
- Use Docker to build a container image of a Backstage project
---
# Summary

A container is a running image. A port is reachable from the host only when it is published with `-p` and when the process binds `0.0.0.0` inside the container. The commands `logs`, `exec` and `inspect` show the process output, the container internals and the stored settings. A command written after the image name replaces the `CMD` of the image, so it must repeat the configuration options it still needs.

One image serves every environment because configuration arrives at run time. Files from the image merge with mounted files in the order of the `--config` options, `${NAME}` references read the environment, and `APP_CONFIG_` variables apply last. Secrets stay out of the image and reach the process through a file or a variable. A variable is still visible to users of `docker inspect`, so the choice depends on who can reach Docker.

The image alone does not enforce security. The run command or the platform sets a non-root user, a read-only root filesystem, dropped capabilities, no new privileges and resource limits. The database connection comes from environment variables read by the configuration, and a health check tells Docker whether the process answers. The frontend can be served by the backend or by a separate nginx image that holds no secrets.

Key facts:

- `-p 8080:7007` means host port 8080 and container port 7007.
- A mounted file with `:ro` cannot be changed by the container.
- `--cap-drop ALL`, `--read-only` and `no-new-privileges` belong to the run settings, not to the image.
- The slim Node.js image has no `curl`, so health checks use Node.js.
- A finished build does not prove that the database, the ports and the permissions work.

<!-- astrona:playground:destroy -->

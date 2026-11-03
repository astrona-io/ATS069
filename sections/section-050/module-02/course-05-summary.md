---
draft: true
exam_objectives:
- Use Docker to build a container image of a Backstage project
---
# Summary

The build context is the set of files the Docker client sends to the daemon. The `.dockerignore` file removes files from it before the transfer. The last matching line wins, an exclamation mark adds files back, and a single star does not cross folders. A probe image that copies the context shows what the daemon received, which is the reliable check for both build speed and private files.

The Backstage backend build writes a skeleton archive with only package manifests and a bundle archive with compiled code. The Dockerfile installs production dependencies from the skeleton and the lockfile, then unpacks the bundle. The split lets Docker keep the slow dependency step cached while the code changes. A host build trusts that the archives match the commit, and a multi-stage build produces them from the received context.

Docker reuses a layer when its instruction and input files match an earlier build, and one rebuilt step forces every later step to rebuild. A Dockerfile ordered from rarely to often changed input, with named files in each copy, rebuilds only what changed. BuildKit cache mounts keep package downloads between builds without adding to the image, and secret mounts give a credential to one step without leaving it in a layer or the history.

Key facts:

- The context is sent on every build, so its size matters even when every step is cached.
- `*.local.yaml` matches only the context root. Use `**/*.local.yaml` for every folder.
- `COPY . .` makes the cache depend on every file in the context.
- `ENV`, `ARG` and `COPY` store a credential in the image. A secret mount does not.
- A step must still succeed with an empty cache mount.

<!-- astrona:playground:destroy -->

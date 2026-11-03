---
draft: true
exam_objectives:
- Use Docker to build a container image of a Backstage project
---
# Summary

A Backstage image packages the compiled backend, its production dependencies, its configuration files and a Node.js runtime. It does not need the repository, the source or the development tools. The build context is the set of files the Docker daemon may read, and the ignore file edits that set. A pattern that is right for one packaging approach can hide a needed file in another, and a missing pattern can let a private file into the build.

A host build compiles before Docker runs and packages the resulting archives. It is fast and reuses existing checks, but it packages whatever archives are present, so an old archive produces a successful build of old code. A multi-stage build compiles inside Docker and copies selected files from the build stage into a clean final stage. It removes build tools and source from the image only when the copy is selective. Copying a whole directory from the build stage undoes the separation.

The running container gets its behavior from the start command, the configuration files it names and the values passed at run time. A server bound to the loopback address inside a container does not receive published traffic. The `USER` instruction and the owner of the working directory decide which identity runs the process. Layers keep every file that was ever copied, so secrets belong in the run-time environment and not in the context or the image history.

Key facts:

- The default backend port is 7007, and a published port needs a process bound to all interfaces.
- `docker image build . -f packages/backend/Dockerfile --tag backstage` builds and tags an image; it does not run it or push it.
- Later `--config` files override earlier ones.
- A finished build proves packaging only. Database access, ingress routing and plugin permissions need separate checks.

<!-- astrona:playground:destroy -->

---
draft: true
exam_objectives:
- Use Docker to build a container image of a Backstage project
---
# The Build Context And The Ignore File

Every image build starts by sending files to Docker. A large or careless set of files makes the build slow and can put private files into the image. This part explains what the build context is, how the `.dockerignore` file changes it, and how to check what the daemon really receives.

The **build context** is the set of files that the Docker client sends to the Docker daemon, the background service that performs the build. The last path argument of `docker image build` is the context root. A `COPY` or `ADD` instruction can read only files inside that set. The Dockerfile itself can live elsewhere in the context, and the `-f` option names it.

## What the ignore file does

Before the client sends the context, it reads the file `.dockerignore` in the context root. Each line is a pattern, and a file that matches a pattern is left out of the context. The rules are similar to a `.gitignore` file but not identical. A pattern is matched against the path relative to the context root. A single star matches any characters inside one folder level. A double star (`**`) matches any number of folders. A line that starts with an exclamation mark makes an exception and adds matching files back.

A typical file for a Backstage repository excludes the Git history, the `node_modules` folders, local configuration files and build output that the image does not use:

```
.git
**/node_modules
*.local.yaml
.yarn/cache
```

The pattern `*.local.yaml` matches only files in the context root, because a single star does not cross a folder boundary. A local file in a subfolder needs the pattern `**/*.local.yaml`. This difference is a common reason why a secret enters an image although the ignore file seems to list it.

## Exceptions and order

The last matching line wins. The pair below leaves out everything in `packages/backend/dist` except the two archives that a host-build Dockerfile copies:

```
packages/backend/dist/*
!packages/backend/dist/skeleton.tar.gz
!packages/backend/dist/bundle.tar.gz
```

If the order is reversed, the first line removes the archives again, and the `COPY` of the archive fails with a message that the file was not found. The file exists on disk, but it is not in the context.

## A Dockerfile-specific ignore file

When a repository holds more than one Dockerfile, one ignore file may not fit all of them. BuildKit, the build engine that current Docker versions use, looks first for a file named like the Dockerfile with the suffix `.dockerignore`. For `-f packages/backend/Dockerfile` it looks for `packages/backend/Dockerfile.dockerignore`. When that file exists, it replaces the root `.dockerignore` for that build. A host-build Dockerfile and a multi-stage Dockerfile need different ignore patterns, so this feature keeps both correct.

## Why the context size matters

The client sends the whole context on every build, even when every later step comes from the cache. A context that includes `node_modules` or recorded test data can be hundreds of megabytes. With BuildKit, the build output has a step named `load build context` that reports how much data was transferred. A small number after the first build shows that the ignore file works.

Pattern errors cut in both directions. Too few patterns send large and private files. Too many patterns remove a file that a `COPY` needs, and the build fails. The check is to look at what arrived inside an image, not to trust the pattern list.

<!-- astrona:playground:renew -->

Open the playground and look at the workspace and its ignore file:

```sh
cd /opt/portal
cat .dockerignore
ls -a
```

The workspace holds a folder `recordings` with a large file that no image needs. Build the host-build image with plain progress output and find the context step:

```sh
docker image build . -f packages/backend/Dockerfile --tag portal:ctx --progress=plain 2>&1 | grep -i "context"
```

The lines that mention the context report the transferred size. Now add the folder to the ignore file and build again:

```sh
echo 'recordings' >> .dockerignore
docker image build . -f packages/backend/Dockerfile --tag portal:ctx --progress=plain 2>&1 | grep -i "context"
```

The reported size is much smaller on the second build. To see exactly which files the daemon receives, build a probe image that copies the whole context and lists it:

```sh
printf 'FROM node:22-bookworm-slim\nCOPY . /ctx\n' > Dockerfile.probe
docker image build . -f Dockerfile.probe --tag portal:probe
docker run --rm portal:probe ls -a /ctx
```

The listing shows the files that survived the ignore file. The file `app-config.local.yaml` is absent and `recordings` is absent. Remove the probe files with `rm Dockerfile.probe` and `docker image rm portal:probe` when you are done.

## What you know now

The build context is the set of files the daemon may read. The ignore file removes files from it before the transfer, with the last matching line winning and exceptions added by an exclamation mark. A single star stays inside one folder, and a double star crosses folders. A probe image that copies the context shows the real result. The next question is which files the Backstage build produces and why it produces two archives.

## Common pitfalls

> [!WARNING]
> A pattern such as `*.local.yaml` does not match `packages/backend/app-config.local.yaml`. Use `**/*.local.yaml` to cover every folder. Check the real context with a probe image instead of reading the pattern list.

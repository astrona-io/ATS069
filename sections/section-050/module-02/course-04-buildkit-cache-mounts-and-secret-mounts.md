---
draft: true
exam_objectives:
- Use Docker to build a container image of a Backstage project
---
# BuildKit Cache Mounts And Secret Mounts

Layer caching helps only when a step is unchanged. When a dependency changes, the whole install step runs and downloads every package again. Separately, a build sometimes needs a credential, for example a token for a private package registry, and that credential must not stay in the image. BuildKit has a mount feature for both problems. This part explains cache mounts and secret mounts and how to check that they work.

**BuildKit** is the build engine in current Docker versions. It is the default when the `docker buildx` plugin is installed. A Dockerfile can use its extra features through a `RUN` instruction with the `--mount` option. The option mounts something into the filesystem only while that one instruction runs.

## Cache mounts

A cache mount is a directory that Docker keeps outside the image layers and reuses between builds. Package managers write their download cache to such a directory, so a mount lets a later install reuse downloaded packages even when the layer cache missed. The Backstage Dockerfile uses it for the Yarn cache:

```dockerfile
RUN --mount=type=cache,target=/home/node/.cache/yarn,sharing=locked,uid=1000,gid=1000 \
    yarn workspaces focus --all --production
```

The option `target` is the path inside the container. The option `sharing=locked` makes parallel builds take turns on the same cache. The options `uid` and `gid` give the cache directory to the `node` user. The content of the cache is not part of the image, so it adds nothing to the image size. A cache mount speeds up a build but never changes what the build produces, so a step must still work when the cache is empty.

## Secret mounts

A secret mount exposes a file to one `RUN` instruction. The file is not written into a layer, and it does not appear in `docker image history`. The secret is given on the command line:

```sh
docker image build . --secret id=npmtoken,src=$HOME/.npmtoken --tag backstage
```

and read in the Dockerfile:

```dockerfile
RUN --mount=type=secret,id=npmtoken,target=/run/secrets/npmtoken \
    test -s /run/secrets/npmtoken
```

The wrong ways to pass a credential are a `COPY` of a file, an `ENV` instruction and an `ARG`. A `COPY` stores the file in a layer. `ENV` stores the value in the image metadata. `ARG` values are recorded in the image history. Anyone who can pull the image can read all three.

## Syntax line and other build tools

The first line of a Dockerfile can be `# syntax=docker/dockerfile:1`. It selects the current Dockerfile frontend so that features such as mounts are available even on an older Docker release. Cache mounts and secret mounts need BuildKit, so on a machine without the `docker buildx` plugin the build fails with an error about the unknown flag. The command `docker buildx version` shows whether the plugin is installed. Build caches take disk space, and `docker builder prune` removes them.

<!-- astrona:playground:renew -->

The playground has two small Dockerfiles for this part. Read the cache mount example and build it twice:

```sh
cd /opt/portal
cat Dockerfile.cache
docker image build . -f Dockerfile.cache --tag portal:mount --progress=plain --no-cache 2>&1 | tail -n 8
docker image build . -f Dockerfile.cache --tag portal:mount --progress=plain --no-cache 2>&1 | tail -n 8
```

The step appends a line to a file in the cache mount and prints the number of lines. The option `--no-cache` forces the step to run both times, yet the second run prints a larger number, because the mount kept its content between builds. Check that the file is not in the image:

```sh
docker run --rm portal:mount ls /var/cache/demo
```

The directory is empty or missing, because the cache mount is not part of any layer. Now try the secret mount:

```sh
echo 'build-time-value-91' > /tmp/demo-secret
docker image build . -f Dockerfile.secret --tag portal:secret --secret id=demo,src=/tmp/demo-secret --progress=plain 2>&1 | tail -n 6
docker image history portal:secret
docker run --rm portal:secret sh -c 'grep -r build-time-value-91 / 2>/dev/null | head -n 1; echo done'
```

The build confirms that it could read the secret. The history does not show the value, and the search of the filesystem finds nothing. Remove the secret file with `rm /tmp/demo-secret`.

## What you know now

A cache mount keeps a directory outside the layers and reuses it between builds, which makes downloads faster without changing the image. A secret mount hands a file to one instruction and leaves no trace in the layers or the history. `COPY`, `ENV` and `ARG` are not safe for credentials. The build is now fast and clean, and the remaining question is what the running container needs.

## Common pitfalls

> [!WARNING]
> Do not rely on a cache mount for correctness. A fresh runner has an empty cache, and the step must still succeed. Do not pass a token with `--build-arg`: it appears in the image history.

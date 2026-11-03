---
draft: true
exam_objectives:
- Use Docker to build a container image of a Backstage project
---
# Dockerfile Layers, Caching And Build Context

This module explains how Docker turns a Dockerfile and a build context into image layers, why some rebuilds take seconds and others take minutes, and how the two archives from the Backstage backend build fit that model. You build images in a virtual machine with Docker.

## Learning Goals

- Control the build context with a `.dockerignore` file.
- Explain what `skeleton.tar.gz` and `bundle.tar.gz` contain and why the Dockerfile unpacks them in two steps.
- Predict which build steps Docker reuses from its cache after a change.
- Use BuildKit cache mounts and secret mounts for dependency downloads and credentials.

## Before You Start

You should be able to read a short Dockerfile and know what a container image is. The hands-on parts use a playground, which is an Ubuntu virtual machine with Node.js and Docker. Its workspace is a small stand-in with the shape of a Backstage project, so builds finish quickly. Technical terms are defined where they first appear.

## Reading Order

1. The Build Context And The Ignore File
2. The Skeleton And Bundle Archives
3. Layers And The Build Cache
4. BuildKit Cache Mounts And Secret Mounts
5. Summary

<!-- astrona:playground -->

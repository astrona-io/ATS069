---
draft: true
exam_objectives:
- Use Docker to build a container image of a Backstage project
---
# Container Artifacts, Build Inputs And Runtime Responsibilities

This module explains what a Backstage container image contains, how a host build and a multi-stage build produce it, and which responsibilities remain with the running container. You build and run the images in a virtual machine with Docker.

## Learning Goals

- Describe the files and dependencies a Backstage container needs.
- Explain host-build and multi-stage packaging tradeoffs.
- Distinguish a built image from a correctly configured deployment.

## Before You Start

You should know what a container is and what a Node.js application is. The hands-on part uses a playground with an Ubuntu virtual machine, Node.js and Docker. The workspace in the playground is a simplified fixture with the shape of a Backstage project. Technical terms are defined where they first appear.

## Reading Order

1. What Goes Into A Backstage Image
2. Host Build And Multi-Stage Build
3. Runtime Configuration, Identity And What A Build Proves
4. Summary

<!-- astrona:playground -->

---
draft: true
exam_objectives:
- Use Docker to build a container image of a Backstage project
---
# Running And Securing The Image

This module explains how to run a Backstage backend image as a container: how ports are published, how configuration and secrets reach the process, which security settings limit the container, and how a database, a health check and a separate frontend image fit in. You run containers in a virtual machine with Docker.

## Learning Goals

- Start, inspect and stop a container, and publish its port.
- Supply configuration files and environment variables at run time, including `APP_CONFIG_` variables.
- Run the container as a non-root user with a read-only filesystem and fewer privileges.
- Connect the backend to PostgreSQL through environment variables and check container health.
- Describe a separate frontend image served by nginx.

## Before You Start

You should be able to build an image from a Dockerfile. The hands-on parts use a playground, which is an Ubuntu virtual machine with Docker and an already built image of a small stand-in backend. The stand-in reads `--config` files and the variable `PORTAL_TOKEN`, so some Backstage features in the readings are explained but not run. Technical terms are defined where they first appear.

## Reading Order

1. Running And Inspecting A Container
2. Configuration At Run Time
3. Identity, Privileges And Secrets
4. Database, Health Checks And The Frontend Image
5. Summary

<!-- astrona:playground -->

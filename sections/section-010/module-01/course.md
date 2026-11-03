---
draft: true
exam_objectives:
- Build and run Backstage projects locally
---
# Local Projects, Development Servers And Production Builds

This module explains how a Backstage project is put together, how it runs on a developer machine, and how it becomes artifacts that a server can run. It separates the development path from the production path, so that a failure can be placed at the right boundary.

## Learning Goals

- Explain the responsibilities of the app and backend workspaces.
- Distinguish a development server from a production artifact.
- Locate startup failures by dependency, configuration and process boundaries.

## Before You Start

You should be able to use a terminal and read a JSON file. The hands-on parts use a playground, which is an Ubuntu virtual machine with Node.js and Yarn. Its workspace is a small stand-in with the shape of a Backstage project: it has an `app` package, a `backend` package, two configuration files and simplified scripts. Technical terms are defined where they first appear.

## Reading Order

1. Workspaces And The Parts Of A Project
2. Development Servers And Configuration
3. Production Builds And Artifacts
4. Summary

<!-- astrona:playground -->

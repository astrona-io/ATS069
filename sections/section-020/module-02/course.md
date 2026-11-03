---
draft: true
exam_objectives:
- Understand local development workflows
---
# Developing Plugins Locally

This module explains how a developer creates a Backstage plugin, runs it on its own while writing it, and then connects it to the app and to the backend. The playground holds a small workspace with the same shape as a Backstage project: a frontend plugin, a backend plugin and the two packages that load them.

## Learning Goals

- Create a plugin package with `yarn new` and find the files it generates.
- Run a plugin alone from its `dev/` entry point and explain hot reload.
- Explain how a backend plugin id decides its route prefix.
- Connect a plugin to the app and to the backend, and name the files that change.

## Before You Start

You should be able to read short TypeScript files and run commands in a terminal. The playground is an Ubuntu virtual machine with Node.js 22, Yarn and Git, and a workspace in `/opt/portal`. The workspace is a simplified fixture, not a generated Backstage application: it does not install the Backstage packages, and a small script stands in for the `yarn new` command. Terms are defined where they first appear.

## Reading Order

1. Creating A Plugin With yarn new
2. The Plugin Development Entry And Hot Reload
3. Backend Plugins And Their Routes
4. Wiring A Plugin Into The App And The Backend
5. Summary

<!-- astrona:playground -->

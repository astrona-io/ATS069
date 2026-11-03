---
draft: true
exam_objectives:
- Understand local development workflows
---
# Changes, Workspace Feedback And Reviewable Development

This module explains how one change moves through a Backstage monorepo on a developer's machine: which packages it touches, which checks give feedback on it, and which files a reviewer must see. The playground gives you a small workspace with the same shape as a Backstage project, so you can run each check yourself.

## Learning Goals

- Trace a source change through the relevant workspace and checks.
- Explain why fast feedback needs both type and behavior checks.
- Distinguish local overrides from committed project configuration.
- Describe a change so that a reviewer can find its boundaries and its evidence.

## Before You Start

You should be able to read short TypeScript and YAML files and run commands in a terminal. The playground is an Ubuntu virtual machine with Node.js 22, Yarn and Git, and a workspace in `/opt/portal`. The workspace is a simplified fixture with the same shape as a Backstage project (a Yarn workspace with `app` and `backend` packages and `app-config` files). It is not a generated Backstage application. Terms are defined where they first appear.

## Reading Order

1. Tracing A Change Through The Workspace
2. Fast Feedback From Type Checks, Tests And Lint
3. Local Overrides, Configuration And Reviewable Changes
4. Summary

<!-- astrona:playground -->

---
draft: true
exam_objectives:
- Understand local development workflows
---
# Testing, Linting And Formatting Workflow

This module explains the checks that a Backstage project runs before a change is merged: tests, linting, formatting and the type check. It shows how to run each one for a single package or for the whole repository, how a continuous integration (CI) pipeline repeats them, and how a Git hook runs them before every commit.

## Learning Goals

- Run the tests of one package and of the whole repository with `backstage-cli`.
- Run the linter and fix the problems it reports, for all packages and for changed packages only.
- Check and apply formatting with Prettier, and run the type check with `tsc`.
- Combine the checks into one command that matches the CI pipeline, and run it from a Git hook.

## Before You Start

You should be able to read short TypeScript files and use Git in a terminal. The playground is an Ubuntu virtual machine with Node.js 22, Yarn and Git, and a workspace in `/opt/portal`. The workspace is a simplified fixture: small scripts stand in for Jest, ESLint and Prettier, so the output is not the output of the real tools. The reading names the real commands, and the playground shows the same workflow. Terms are defined where they first appear.

## Reading Order

1. Running Tests With backstage-cli
2. Linting With backstage-cli
3. Formatting With Prettier And Checking Types With tsc
4. One Check Command, CI And Git Hooks
5. Summary

<!-- astrona:playground -->

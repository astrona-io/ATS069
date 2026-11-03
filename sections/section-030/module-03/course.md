---
draft: true
exam_objectives:
- Compile a Backstage project with TypeScript
---
# Backstage Build Pipelines And Package Roles

This module explains how a Backstage repository turns TypeScript source into build output. It covers package roles, the difference between a transpile step and a type check, what a package build writes, and how the root scripts build the whole repository. You practise on a small workspace that has the shape of a Backstage repository.

## Learning Goals

- Explain what a package role is and what the build tooling decides from it.
- Distinguish transpiling from type checking and say which one the Backstage build does.
- Describe the build output of a library, a frontend app and a backend.
- Explain how the root scripts build all packages and in which order a pipeline runs them.

## Before You Start

You should be able to read a `package.json` file and run a command in a terminal. The hands-on parts use a playground, an Ubuntu virtual machine with Node.js and the `tsc` compiler. Its workspace is a simplified stand-in: it has no `backstage-cli`, and its build script only transpiles, so it shows the same boundary between building and checking. Technical terms are defined where they first appear.

## Reading Order

1. Package Roles In package.json
2. Transpiling Without Type Checking
3. Build Output: Libraries, The App And The Backend
4. Building The Whole Repository
5. Summary

<!-- astrona:playground -->

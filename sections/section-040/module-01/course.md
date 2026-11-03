---
draft: true
exam_objectives:
- Download and install dependencies for a Backstage project with NPM/Yarn
---
# Package Managers, Lockfiles And Reproducible Dependencies

This module explains how a Backstage project turns the dependencies declared in its package manifests into the packages on disk, and how a lockfile makes that result repeatable. You work in a playground that has a small Yarn workspace with the same shape as a Backstage project.

## Learning Goals

- Explain what a manifest declares and what a lockfile records, and which tool writes each one.
- Read a version range and say which releases it allows.
- Declare a dependency in the workspace that imports it, and explain why a hoisted package is not a declaration.
- Use `yarn install --immutable` and `npm ci` to install exactly what the lockfile says, and explain when each one fails.
- Use `resolutions` to force one version of a transitive dependency, and name the cause of an install failure from its error.

## Before You Start

You should be able to open a terminal and edit a JSON file. The playground is an Ubuntu virtual machine with Node.js 22 and Yarn 4 installed. The example project is a simplified workspace with the shape of a Backstage project: it is not a generated Backstage application.

## Reading Order

1. Manifests, Version Ranges And The Lockfile
2. Workspaces And The Dependency Boundary
3. Reproducible Installs, Resolutions And Failures
4. Summary

<!-- astrona:playground -->

---
draft: true
exam_objectives:
- Download and install dependencies for a Backstage project with NPM/Yarn
---
# Upgrading, Auditing And Private Registries

This module explains how a Backstage repository keeps its dependencies current and safe over time: how the upgrade command moves the project to a new Backstage release, how to find duplicate and vulnerable packages, how peer dependencies work in plugins, and how Yarn reaches a private package registry. You work in a playground that has a small Yarn workspace with the shape of a Backstage project.

## Learning Goals

- Describe what `backstage-cli versions:bump` changes and how to review the result.
- Find why a package is installed with `yarn why`, remove duplicates with `yarn dedupe` and report vulnerabilities with `yarn npm audit`.
- Declare a peer dependency in a plugin and explain what the application must provide.
- Route a package scope to a private registry with `npmScopes` and `npmRegistryServer`, and keep the token out of the repository.

## Before You Start

You should know what a manifest, a lockfile and a version range are, and how to run `yarn install --immutable`. The playground is an Ubuntu virtual machine with Node.js 22 and Yarn 4.4.1. The example project is a simplified workspace with the shape of a Backstage project, not a generated Backstage application. Technical terms are defined where they first appear.

## Reading Order

1. Upgrading Backstage With versions:bump
2. Finding Duplicate And Vulnerable Packages
3. Peer Dependencies In Plugins
4. Private Registries And Authentication
5. Summary

<!-- astrona:playground -->

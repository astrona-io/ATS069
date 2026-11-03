---
draft: true
exam_objectives:
- Download and install dependencies for a Backstage project with NPM/Yarn
---
# Yarn Workflows In A Backstage Repository

This module explains the daily Yarn commands of a Backstage repository: how `.yarnrc.yml` configures Yarn, how to add a dependency to one workspace, how to run a script in every workspace, and what the `backstage.json` file and the `backstage:` protocol do. You work in a playground that has a small Yarn workspace with the shape of a Backstage project.

## Learning Goals

- Read `.yarnrc.yml` and say what `yarnPath`, `nodeLinker` and `enableGlobalCache` control.
- Add, change and remove a dependency in one workspace with `yarn add`, `yarn up` and `yarn remove`.
- Run one script in every workspace with `yarn workspaces foreach`, and choose the order and the scope.
- Explain what `backstage.json` records and how the `backstage:` protocol resolves a version.

## Before You Start

You should be able to open a terminal, edit a JSON file and read a version range such as `^7.6.0`. The playground is an Ubuntu virtual machine with Node.js 22 and Yarn 4.4.1. The example project is a simplified workspace with the shape of a Backstage project, not a generated Backstage application. Technical terms are defined where they first appear.

## Reading Order

1. The Yarn Configuration File And The Linker
2. Adding And Removing Dependencies In A Workspace
3. Running Scripts Across Workspaces
4. The backstage.json File And The backstage: Protocol
5. Summary

<!-- astrona:playground -->

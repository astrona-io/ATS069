---
draft: true
exam_objectives:
- Build and run Backstage projects locally
---
# Backstage CLI, Scaffolding And Project Creation

This module explains how a new Backstage project comes into existence and which tool works on it afterwards. It covers the project generator, the layout it creates, the commands of the Backstage command-line tool, the package roles that tell that tool what to do, and the Node.js and Yarn versions a project needs.

## Learning Goals

- Describe what `@backstage/create-app` creates and which files a developer owns afterwards.
- Name the main `backstage-cli` commands and say what each one does to a package or to the repository.
- Explain what the `backstage.role` field in a `package.json` controls.
- Check that the Node.js and Yarn versions match what the project requires.

## Before You Start

You should be able to use a terminal and read a JSON file. The hands-on parts use a playground, which is an Ubuntu virtual machine with Node.js and Yarn. Its workspace is a small stand-in with the layout of a generated project. It has no registry dependencies, so the `backstage-cli` commands are read in the scripts but not run. Technical terms are defined where they first appear.

## Reading Order

1. What The Project Generator Creates
2. The Backstage CLI Commands
3. Package Roles And The Workspace Layout
4. Node.js, Yarn And Version Alignment
5. Summary

<!-- astrona:playground -->

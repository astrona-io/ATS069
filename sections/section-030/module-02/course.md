---
draft: true
exam_objectives:
- Compile a Backstage project with TypeScript
---
# Shared tsconfig, Strictness And Type Check Scripts

This module explains how a Backstage repository configures the TypeScript compiler once and shares that configuration with every package. It covers the shared base file, the `strict` option, the `skipLibCheck` option, the root check scripts and the declaration output folder. You practise on a small workspace that has the shape of a Backstage repository.

## Learning Goals

- Explain what a shared base `tsconfig.json` sets and how a root file extends it.
- Describe what `strict` switches on and what a check means without it.
- Explain what `skipLibCheck` skips and why a repository also has a full check.
- Run the root check scripts and say where declaration files go and why.

## Before You Start

You should be able to read a `tsconfig.json` file and run a command in a terminal. The hands-on parts use a playground, an Ubuntu virtual machine with Node.js and the `tsc` compiler. Its workspace is a simplified stand-in with the shape of a Backstage repository and uses no Backstage packages. Technical terms are defined where they first appear.

## Reading Order

1. What The Shared Base Configuration Sets
2. Strict Mode And What It Switches On
3. skipLibCheck And Declaration Files
4. Check Scripts, dist-types And Incremental Checks
5. Summary

<!-- astrona:playground -->

---
draft: true
exam_objectives:
- Compile a Backstage project with TypeScript
---
# Type Checking, Transpilation And Workspace Build Contracts

This module explains what the TypeScript compiler checks and what it emits, how `tsconfig.json` sets the scope of a check, why a type is not a runtime guarantee, and how a workspace of packages is built in dependency order. You practise on a small workspace that has the shape of a Backstage repository.

## Learning Goals

- Distinguish TypeScript checking from JavaScript execution.
- Explain workspace build dependencies and generated artifacts.
- Diagnose type errors separately from runtime integration failures.

## Before You Start

You should be able to read a short JavaScript or TypeScript function and a JSON file. The hands-on part uses a playground, an Ubuntu virtual machine with Node.js and the `tsc` compiler. Technical terms are defined where they first appear.

## Reading Order

1. Checking, Emitting And The Scope Of tsconfig.json
2. Types, Optional Values And Runtime Boundaries
3. Workspace Builds, Project References And Declaration Files
4. Summary

<!-- astrona:playground -->

---
draft: true
exam_objectives:
- Build and run Backstage projects locally
---
# Summary

A Backstage project starts with `@backstage/create-app`, which copies a template into a new folder and installs the dependencies. After that the project owner owns every file. The root holds the workspace list, the scripts, the base and production configuration files, and `backstage.json`. The `packages` folder holds the frontend and the backend. The `plugins` folder holds the plugins that the team writes.

Most scripts in the project call the `backstage-cli` tool. The `package` commands start, build, lint and test one package. The `repo` commands do the same for every package. Other commands create packages, print and check configuration, and upgrade the Backstage release. Reading a script tells the reader which command runs and how wide its scope is.

Each package declares its role in the `backstage.role` field, and the tool builds the package by that role. The `workspaces` field decides which folders Yarn and the tool see, so a plugin folder outside the patterns is ignored. Versions are pinned in three places: `engines.node` for Node.js, `packageManager` for Yarn through Corepack, and `backstage.json` for the Backstage release. A project upgrades its Backstage release as a whole with `versions:bump`.

Key facts:

- `@backstage/create-app` creates a new folder and does not change an existing project.
- `backstage-cli package` commands work on one package, and `backstage-cli repo` commands work on all of them.
- A missing or wrong `backstage.role` stops the build of that package.
- A package folder that no `workspaces` pattern matches is invisible to Yarn.
- The `packageManager` field and Corepack keep every machine on one Yarn version.

<!-- astrona:playground:destroy -->

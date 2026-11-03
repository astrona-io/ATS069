---
draft: true
exam_objectives:
- Understand local development workflows
---
# Summary

A Backstage plugin is a package in the `plugins/` folder of the workspace. The generator `yarn new` creates the package with a name, a source folder, a test and a development entry point. Yarn knows the package only when its folder matches a pattern in the `workspaces` field. The plugin id is set in the source code. It is not the same value as the package name or the folder name.

The `dev/` entry point runs one plugin alone with sample data or a test backend. The `start` script of the plugin package runs it, and hot reload applies a source change without a manual restart. That gives fast feedback, but it does not prove that the app or the backend load the plugin, and it does not replace the type check or the tests. Configuration changes need a restart.

A backend plugin owns the routes under `/api/<plugin id>`. The id is a contract with the code that calls those routes, so a renamed id breaks callers while the plugin tests still pass. A path that the plugin does not handle ends in 404.

Connecting a plugin takes several steps: the workspace pattern, the declared dependency, the load call in the backend, the load step in the app, and any configuration. Each missing step has its own symptom. A request through the started backend is the check that covers the whole chain.

Key facts:

- A folder that no `workspaces` pattern matches is not a workspace.
- The route prefix of a backend plugin is `/api/<plugin id>`.
- A package must declare every package it imports, with `workspace:^` for packages in the same repository.
- A working `dev/` entry point does not prove that the portal loads the plugin.
- A 404 from the backend can come from a wrong id, a missing load call or an unhandled path.

<!-- astrona:playground:destroy -->

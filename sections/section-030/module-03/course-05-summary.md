---
draft: true
exam_objectives:
- Compile a Backstage project with TypeScript
---
# Summary

A Backstage repository holds packages of different kinds, and each package declares its kind in the `backstage.role` field of its `package.json`. The role, for example `frontend`, `backend`, `common-library` or `backend-plugin`, tells `backstage-cli` how to build, start, lint and test the package. A package without a role cannot get the right build. The role records where the code runs, so a library that both sides import must not use an API that exists on only one side.

The package build transpiles: it removes types, converts syntax and packages the result, and it does not check types. The type check is a separate step that `tsc` runs for the whole repository. A build can succeed on code that fails the type check, and a type check can pass on code that the build cannot package. Each result answers its own question, so a pipeline runs both, together with the tests, and reads each result on its own.

A library builds to `dist` with JavaScript and a type file, and its `files` field must list `dist` or the published package has nothing to load. The frontend builds to static files that every visitor can read, so they hold no secrets. The backend builds to a bundle and two archives, a skeleton and a bundle, that a container build uses. Root scripts such as `tsc`, `build:all` and `build:backend` give a pipeline one agreed way to run these steps. The pipeline runs install, type check and build in order, from a clean checkout, and a failure is placed at the step that owns it.

Key facts:

- The role is a field in `package.json`, and the tooling chooses the build from it.
- A green build does not show that the types are correct.
- `files` decides what a published package contains.
- `dist` and `dist-types` are generated and are not committed.
- The type check runs before the library build because the build reads its declarations.

<!-- astrona:playground:destroy -->

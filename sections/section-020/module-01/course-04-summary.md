---
draft: true
exam_objectives:
- Understand local development workflows
---
# Summary

A Backstage project is a workspace of packages in one repository. A change is measured by the contracts it touches: shared types, routes, configuration keys and declared dependencies. The browser code and the backend run as separate processes, so a working page does not show that the backend works, and the reverse. Git shows which packages a change reaches.

Each source of feedback answers one question. The type check compares values with declared types. The tests compare results with expected values for the cases written. The linter enforces the rules of the team. The development server shows that a program starts: it restarts the backend process or updates browser modules when a file changes. A change can pass one check and fail another, so a workflow uses all of them and does not read a passing result as more than it states.

Configuration is layered. The last file has the highest priority, objects merge deeply, and values and arrays are replaced. The local override file is loaded only when no `--config` flag is given, and it holds values that are true for one machine. A key that every checkout needs belongs in the shared file. A secret enters through an environment variable reference and never through a committed value. Git ignores the local file so that personal values never reach a review.

A reviewable change carries its source, its declared dependencies, its lockfile and its configuration together. Its description gives the behavior, the packages it changes and the evidence that was collected, and it claims nothing that was not checked.

Key facts:

- `yarn workspaces list` shows which packages the workspace includes.
- A type check does not show correct behavior, and a test does not show correct types.
- `${NAME}` reads a value from the environment, and `${NAME:-default}` supplies a default.
- A `--config` flag turns off the default configuration files.

<!-- astrona:playground:destroy -->

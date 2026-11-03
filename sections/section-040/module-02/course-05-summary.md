---
draft: true
exam_objectives:
- Download and install dependencies for a Backstage project with NPM/Yarn
---
# Summary

Yarn reads its settings from `.yarnrc.yml` and merges them with a file in the home directory of the user and with environment variables that start with `YARN_`. The repository pins the Yarn release with the `packageManager` field and with `yarnPath`. The `nodeLinker` setting `node-modules` makes Yarn write a `node_modules` folder, which Backstage tooling expects. The command `yarn config get` prints the value that Yarn actually uses.

A dependency belongs in the manifest of the workspace that imports it. The command `yarn workspace <name> add <package>`, or `yarn add` inside the workspace folder, writes the range, updates `yarn.lock` and installs the package in one step. The `--cwd` option belongs to Yarn 1. The flag `-D` selects `devDependencies`, `-E` writes an exact version, and the `workspace:` protocol links a package of the same repository. The commands `yarn up` and `yarn remove` change and delete dependencies, and `yarn why` shows who asks for a package.

The command `yarn workspaces foreach` runs a Yarn command in many workspaces. The flag `-A` selects all of them, `--topological` runs dependencies first, `--parallel` runs workspaces together and `--include`, `--exclude` and `--since` narrow the scope. A root script that wraps the command gives every developer and every build server the same entry point and one exit code.

The file `backstage.json` records the Backstage release of the repository. Manifests can use the range `backstage:^` when a Yarn plugin is enabled, and Yarn then takes the version of each `@backstage` package from the release named in `backstage.json`. Without the plugin, every manifest holds plain version ranges.

Key facts:

- `yarn config get <setting>` shows the effective value, including values from outside the repository.
- A package added at the repository root is not declared by the workspace that imports it.
- `yarn workspaces foreach` stops and fails when the script fails in one workspace.
- Use `--topological` for builds, where one workspace needs the output of another.
- `backstage.json` records a release and installs nothing.

<!-- astrona:playground:destroy -->

---
draft: true
exam_objectives:
- Download and install dependencies for a Backstage project with NPM/Yarn
---
# Summary

The command `yarn backstage-cli versions:bump` moves a repository to one Backstage release. It reads the release manifest, rewrites the `@backstage` ranges in every manifest, writes the release to `backstage.json` and runs the install. It does not update template files or fix breaking code changes. A safe upgrade starts from a clean tree, runs `yarn install --immutable`, then runs the compile, test and build steps and commits the manifests, `backstage.json` and `yarn.lock` together.

`yarn why` explains why a package is installed and who asked for it. A duplicate is one package at several resolved versions in the lockfile. `yarn dedupe` merges what the ranges allow, and `--check` makes it a gate. The `resolutions` field forces one version of a package everywhere, and it overrides what the dependants tested. `yarn npm audit` reports published advisories, and the fix depends on whether the vulnerable package is a direct or a transitive dependency.

A peer dependency is a requirement that a package places on its consumer. The consumer installs the package, and the plugin uses that one copy. A plugin lists the same package in `devDependencies` so it can be built alone. Yarn reports a missing or incompatible peer as a warning, and the failure appears at run time.

Yarn sends package requests to `npmRegistryServer`. The `npmScopes` setting routes one scope to a private registry, and `npmAlwaysAuth` sends the token on every request. A token belongs in an environment variable or in a file outside the repository. Status codes separate causes: `401` is missing or rejected credentials, `403` is a denied user and `404` for an existing package often means the wrong registry.

Key facts:

- `versions:bump` changes manifests and `backstage.json`, not code or template files.
- A green install does not prove that the upgraded code compiles or passes tests.
- `yarn dedupe --check` exits with a non-zero code when a dedupe would change the lockfile.
- A peer dependency installs nothing for the package that declares it.
- A token written into a committed file must be revoked, not only deleted.

<!-- astrona:playground:destroy -->

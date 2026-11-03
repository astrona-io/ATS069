---
draft: true
exam_objectives:
- Download and install dependencies for a Backstage project with NPM/Yarn
---
# Summary

A package manifest, the `package.json` file, declares what a package needs: the names of its dependencies, the version ranges it accepts and the scripts it exposes. A lockfile records the result of resolution, which is the exact version, source and integrity checksum of every package in the dependency graph. The package manager writes the lockfile. Developers review it, commit it and do not edit it by hand.

A version range allows a set of releases. The lockfile chooses one release from that set, so two installs from the same lockfile get the same packages, while two installs from the manifest alone can get different ones. A change to a manifest or a range is a decision to change the graph. A change that only the lockfile shows is a change nobody declared.

In a workspace repository, every package declares its own dependencies. The package manager can place a dependency in the root `node_modules` directory, so a package can import something it never declared. That code works on one machine and fails when the package is packed alone or when the layout changes. The fix is a declaration in the package that imports the code, followed by a new install that updates the lockfile.

Reproducible installation uses a command that refuses to change the lockfile. `yarn install --immutable` for Yarn 4 and `npm ci` for npm fail when the manifests and the lockfile disagree, and they do not write a new resolution. Automated builds use them so that a reviewed commit produces the reviewed graph. `resolutions` in a Yarn project and `overrides` in an npm project force one version of a transitive dependency, and each such entry is a reviewed decision.

An install can fail for reasons that have nothing to do with the lockfile: a Node.js release that a package does not support, a native module that needs a compiler, a registry that cannot be reached, a private package that needs a credential, or a range that no published release satisfies. Reading the first error line and sorting it into one of these groups is faster than rerunning the install. A clean install proves that the packages can be acquired. It does not prove that the application runs, that types match or that an image builds.

Key facts:

- The manifest states intent, and the lockfile states the result.
- One project uses one package manager and one lockfile.
- Immutable installs are for verification, and `yarn install` or `npm install` are for deliberate changes.
- A hoisted package is not a declared dependency.

<!-- astrona:playground:destroy -->

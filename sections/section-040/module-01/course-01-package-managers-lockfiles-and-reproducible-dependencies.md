---
draft: true
exam_objectives:
- Download and install dependencies for a Backstage project with NPM/Yarn
---
# Package Managers, Lockfiles And Reproducible Dependencies

A Backstage application depends on the framework, installed plugins and supporting JavaScript packages. Its package manifests declare which packages each workspace needs and which scripts that workspace exposes. The package manager resolves those declarations into a concrete graph. A lockfile records that resolution so future installations can use the same selected versions rather than independently guessing from version ranges.

NPM and Yarn both manage packages, but their versions, workspace behavior and lockfile formats are not identical. A generated project commonly selects a package manager and may record its expected version. The practical contract is the repository's choice, not an assumption that any command with the word install creates equivalent results. Changing package managers should be an explicit migration with reviewed consequences.

Consider a frontend plugin that imports a catalog API package. Its own workspace should declare that dependency under the applicable package model. If the dependency is available only because another package happens to install it, the source has a hidden requirement. A stricter resolver or production packaging step may expose that requirement. A monorepo does not remove the need to describe dependencies at the correct boundary.

A version range permits a set of releases; the lockfile selects specific resolved versions and integrity information supported by the manager. Updating the manifest without reviewing the resolution leaves uncertainty about the resulting graph. Updating only a lockfile can also introduce changes whose reason is unclear. A reviewable dependency change explains which compatibility or security goal motivated it and which workspaces it affects.

Installation success depends on more than the lockfile. The selected Node.js runtime must be supported by the project and its dependencies. Native packages may need compiler tools or system libraries. Registries must be reachable, and private packages need scoped authentication. Disk permissions and repository-local package-manager configuration can also affect resolution. These prerequisites are separate from whether a plugin's runtime API works.

Suppose a fresh checkout fails while downloading a private package. The first useful distinction is whether the registry request failed, the package could not be found, or a downloaded native module could not build. An authentication failure calls for checking the approved registry credential path. A native compilation failure calls for runtime and platform compatibility. Rewriting catalog entity metadata would not address either case.

Lockfile-preserving installation modes are valuable in automated verification because they refuse to silently produce an unreviewed resolution. Their exact names and behavior vary by package-manager release. The important principle is that the committed declarations and lockfile must agree. A build system should not opportunistically upgrade dependencies while supposedly validating a reviewed commit.

Security review also includes dependency provenance and lifecycle scripts. Installing a package can execute package-defined behavior in the build environment. Restrict registry credentials and avoid making production secrets available to unrelated installation steps. Integrity verification helps detect changed package content, but it does not prove that the original package behavior is safe or appropriate.

After a deliberate update, the relevant evidence includes type compatibility, behavioral checks and packaging success for affected workspaces. A plugin can install cleanly while depending on a different Backstage API generation. Removing an installation error establishes only that the graph can be acquired; it does not establish that all source and runtime contracts remain compatible.

For modern Yarn releases, `yarn install --immutable` refuses a resolution that would modify the committed lockfile. An NPM project with a compatible committed lockfile can use `npm ci` for a clean lockfile-based installation; `npm install` has a different role when deliberately changing or updating the dependency graph. These are package-manager-specific contracts, not interchangeable spellings. A project using an older Yarn release needs that release's supported option rather than an assumed modern flag. The selected manager and version remain the authority for interpreting installation behavior.

## Common pitfalls

> [!WARNING]
> Do not mix package-manager resolutions casually or rely on dependencies supplied accidentally by another workspace. An installation can execute code and can succeed despite runtime incompatibility. Keep credentials narrow and review dependency declarations, lockfile changes and affected build paths together.

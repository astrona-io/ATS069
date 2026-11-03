---
draft: true
exam_objectives:
- Build and run Backstage projects locally
---
# Node.js, Yarn And Version Alignment

A project that works on one machine and fails on another often differs in versions, not in code. This part explains which versions a Backstage project pins, where it records them, and how to check and upgrade them.

Three versions matter. The first is the Node.js release, which runs the backend and every build tool. Backstage supports the active long-term support (LTS) releases of Node.js, which at the time of writing are 20 and 22. The second is the Yarn release, which installs the dependencies. A generated project uses Yarn 4, called Yarn Berry, and not the older Yarn 1. The third is the Backstage release, which is the set of `@backstage/*` package versions that were tested together.

<!-- astrona:playground:renew -->

Check the first two in the playground:

```sh
cd /opt/scaffold
node --version
yarn --version
node tools/check-env.js
```

The script prints the major version of Node.js, the majors that the `engines` field allows and the `packageManager` value. It stops with an error if the major version is not allowed.

## Where the versions are recorded

The `engines.node` field in the root `package.json` lists the Node.js majors that the project allows, for example `20 || 22`. Yarn prints a warning on install when the running version does not match, and a build tool can use the field to stop early. The `packageManager` field names the Yarn version, for example `yarn@4.4.1`. Corepack, a tool that ships with Node.js, reads this field and runs exactly that Yarn version, so every developer and the build server use the same one. The command `corepack enable` turns this on.

```sh
node -p "require('./package.json').packageManager"
```

The file `backstage.json` has one field, `version`, with the Backstage release number. The `backstage-cli` upgrade command reads it to know where the project stands, and writes the new number when the upgrade finishes.

## Upgrading the Backstage release

The command `yarn backstage-cli versions:bump` upgrades the project. It reads the release manifest from the Backstage servers and rewrites the version ranges of every `@backstage/*` dependency in all workspaces to the matching versions. It then updates `backstage.json`. A developer runs `yarn install` afterwards to update the lockfile, and commits the changed `package.json` files, the lockfile and `backstage.json` together.

An upgrade can need manual changes, because the owner owns the generated files. The Backstage project publishes release notes and a tool that compares a project with the current template. A developer reads that difference and applies the changes that matter.

## Version problems and their signs

A Node.js version outside the allowed majors shows up as an engines warning or as an error from a native dependency that was built for another version. A wrong Yarn version shows up as a lockfile that rewrites itself or as an error about an unknown `.yarnrc.yml` option. A mixed set of `@backstage/*` versions shows up as type errors or runtime errors about a missing export. The remedy for the first two is to match the pinned versions. The remedy for the third is `versions:bump`, not editing one package by hand.

## Common pitfalls

> [!WARNING]
> Do not upgrade one `@backstage/*` package alone: the packages are released as a tested set. Do not delete `packageManager` to make a warning go away, because then every machine can use a different Yarn. Run `corepack enable` once on a new machine before you run any `yarn` command in the project.

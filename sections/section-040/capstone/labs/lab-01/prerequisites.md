# Prerequisites

- The `astrona` command-line tool, installed and working (`astrona check` passes), and about 2 GiB of free memory and 20 GiB of free disk.
- Internet access from your machine. The virtual machine downloads Node.js, the Yarn release and the `semver` packages when it starts, and you download a package again when you change a range.
- You can read a `package.json` file and know the difference between `yarn install` and `yarn install --immutable`.

The lab starts an Ubuntu 24.04 virtual machine with Node.js 22. The project in `/opt/portal` is a simplified Yarn workspace with the shape of a Backstage project, not a generated Backstage app.

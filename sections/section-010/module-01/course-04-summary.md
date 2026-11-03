---
draft: true
exam_objectives:
- Build and run Backstage projects locally
---
# Summary

A Backstage repository combines a root package, an app workspace, a backend workspace and configuration files. The app produces the browser interface. The backend runs as a separate process, serves the APIs, and holds server-side credentials. A root script can start both, but each process has its own port, its own log and its own failures. Yarn runs a package script from the package folder, so paths inside scripts are relative to that folder.

A start is a sequence of conditions: packages resolve, source compiles, configuration provides the required keys, the process binds its port, and the browser reaches the right server. The first failed condition stops the rest, so diagnosis starts at the earliest failure. Configuration files merge in order, with later files overriding earlier ones. Values that the browser receives are public, so credentials belong in the server-only part of the configuration.

A production build turns source into artifacts for a defined runtime. It is a snapshot of the source and of the configuration the build reads. An artifact is proven only by running it without the source tree, with the configuration of its target environment. A build that leaves out a runtime file succeeds and then fails when it runs alone, and a development server does not show that failure.

Key facts:

- A script name is defined by the project's `package.json`, not by Backstage in general.
- A running frontend does not prove that the backend started.
- Browser-visible configuration is public to every user of the page.
- A successful build does not prove the artifact is complete.
- A repaired start error shows that the next boundary can be tested, not that the whole system works.

<!-- astrona:playground:destroy -->

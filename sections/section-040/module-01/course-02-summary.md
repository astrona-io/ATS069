---
draft: true
exam_objectives:
- Download and install dependencies for a Backstage project with NPM/Yarn
---
# Summary

Package manifests declare dependencies and scripts; a lockfile records a resolved dependency graph for the chosen package manager. Workspace boundaries remain important even when a monorepo installs dependencies together. Reproducibility also depends on the runtime, package-manager release and native prerequisites. A dependency update should deliberately change declarations and resolved versions, then establish compatibility through the affected checks and build paths.

---
draft: true
exam_objectives:
- Build and run Backstage projects locally
---
# Local Projects, Development Servers And Production Builds

A Backstage project is an application assembled from packages rather than a single static website. Its app workspace produces the browser interface. Its backend workspace provides server APIs, catalog processing and integrations that need privileged access. Other packages can contain plugins, shared types or organization-specific features. The root package describes the workspace arrangement and common scripts. Understanding that arrangement explains why a page may compile while a server feature still fails to start.

Local development optimizes feedback. A frontend development server can rebuild browser assets when source changes, while the backend process hosts plugin routes and reads server configuration. A root development script may coordinate both processes, but that orchestration does not merge their responsibilities. A browser request still crosses a network boundary to a backend API. Failure in one process can therefore leave the other process apparently healthy.

Consider a portal with a catalog page and a deployment-status card. The page layout can render even when the deployment plugin's backend route is unavailable. If the card reports a request failure, the relevant evidence is the requested route, response status and corresponding server error. Rebuilding a logo asset would not address that boundary. Conversely, a syntax error in the React component can prevent the card from rendering before any API request occurs.

A production build has a different purpose. It transforms source and dependencies into artifacts suitable for the selected runtime. Backend compilation and bundling produce files that the runtime can load. Frontend building produces browser assets; deployments may serve them through the backend's app-serving plugin or another deliberately configured arrangement. The exact scripts belong to the generated project's package definitions. A script name alone is not a universal contract across every Backstage release.

Prerequisites include a supported Node.js release, the package manager selected by the repository, resolved workspace dependencies and valid configuration. Native dependencies can also require operating-system libraries or compatible build tools. Matching these prerequisites matters more than copying a command from a different project. An application that works with one developer's untracked local dependency may fail in a clean checkout because that dependency was never declared.

Read startup as a sequence of contracts. Package resolution must first locate imported modules. Compilation must then accept the source and build graph. Configuration must provide the keys required by installed features. The process must bind its intended address and initialize dependencies such as a database. Finally, the browser must reach the correct server. A later symptom does not erase an earlier failed contract.

Suppose a new catalog integration introduces a required authentication setting. The application compiles, but backend initialization rejects the absent setting. That sequence identifies configuration as the immediate blocker. It does not prove the integration's external permissions will work after startup; those permissions are a later check. Separating the two avoids claiming that one repaired error establishes complete system health.

Development configuration should use credentials with limited authority and isolated data. A local process can still reach real services if given production credentials, so the word local is not a security boundary. Server-only values must remain in the backend configuration path. Browser-visible configuration should contain only values intended for every authorized browser user to inspect.

Project scripts resolve through the repository's package definitions. A script named `start` or `dev` can coordinate development processes only when that project declares it. `backstage-cli repo build` describes a repository build path, while generated applications may expose a wrapper such as `yarn build:all`. These names help distinguish responsibilities; they are not a promise that every release uses the same root script. The package definition identifies what a selected command would actually execute.

## Common pitfalls

> [!WARNING]
> A running frontend does not prove that backend plugins initialized. Development serving is also not evidence that the production artifact contains its required runtime files. Diagnose the first failing boundary and distinguish observed behavior from behavior that has not yet been checked.

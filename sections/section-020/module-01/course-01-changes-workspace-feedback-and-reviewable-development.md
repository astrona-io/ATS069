---
draft: true
exam_objectives:
- Understand local development workflows
---
# Changes, Workspace Feedback And Reviewable Development

Backstage development usually spans a monorepo with several workspaces. A change to a browser card, a backend endpoint and a shared API type can cross three packages even when the user sees one feature. The development workflow should follow those boundaries deliberately. Otherwise a developer can repair the visible component while leaving the server contract or declared dependencies inconsistent.

Start by identifying the behavior being changed. A catalog card may read entity metadata through a frontend API abstraction. Its server integration may live in a backend plugin. A reusable response interface may live in a common package. This separation determines which packages need checks and which application wiring must change. The number of edited files is less informative than the number of contracts those files alter.

For example, imagine adding a warning when a service has no owner. The browser component needs a defined loading state, an absent-owner state and a valid-owner state. A missing owner may be an accepted catalog condition rather than a failed HTTP request. If those cases are collapsed into a generic error, the interface gives misleading advice. A focused behavioral check should exercise the conditions the feature promises to distinguish.

Fast feedback commonly combines development serving, type checking and linting. The development server reveals changes quickly. Type checking catches incompatible API usage and shapes of data. Linting catches selected code-quality patterns. None of these alone proves that a permission check is enforced or that a remote integration interprets a token correctly. The relevant behavioral checks belong alongside the static feedback.

Production building adds another boundary. Development tools may resolve source directly or provide special asset handling. The production artifact must contain the files and dependencies its runtime needs. A change that works only because a developer has an old generated file in a working directory is not reproducible. Building from declared inputs helps expose that dependency before review.

Configuration is also an input to the workflow. Shared defaults describe what every checkout needs to know. A local override can point one developer at an isolated database or integration sandbox. Sensitive values should arrive through an approved secret-delivery mechanism rather than committed plaintext. A local override should not silently become the only place where a newly required shared key is documented.

Changes to dependencies should be reviewed with their lockfile and workspace declarations. A plugin imported by one package must be available to that package under the repository's dependency model. Installing something at the root because it happens to satisfy a local resolver can conceal an undeclared dependency. The problem often appears when another machine or a production packaging step resolves the graph differently.

Reviewable work explains the user behavior, affected boundaries and evidence. A small feature can have a short description: the card distinguishes an absent owner from a failed catalog request, its component checks cover those states, and the app build succeeds. That is more useful than a list of every command that happened to run. It also avoids claiming that unrelated external services were verified.

Updates should follow the Backstage release and migration expectations of the repository. A plugin's current instructions may target a newer frontend or backend system than the application uses. Migration and feature work are separate decisions even when they touch similar files. Keeping those decisions explicit makes it possible to understand failures and review changes without guessing which architecture is intended.

## Common pitfalls

> [!WARNING]
> A fast browser refresh is useful feedback, not proof of a complete change. Include declared dependencies, configuration and behavior checks for the contracts being changed. Do not rely on personal overrides or stale generated files to make a clean checkout work.

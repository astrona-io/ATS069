# Question

Solve this question on: `terminal`

The portal team in `/opt/portal` wants every commit to pass the same checks that the review pipeline runs. Today a developer can commit code with a lint problem and with wrong formatting. The workspace is a Git repository with one commit. It is a simplified fixture with the shape of a Backstage project, not a generated application.

Do not edit any `*.test.ts` file.

1. `yarn lint` must finish without problems. Fix the source, do not change the lint rules.

2. `yarn format:check` must finish without problems. Let the formatter rewrite the file instead of editing it by hand.

3. Add a root script named `check` that runs `yarn tsc`, `yarn lint`, `yarn format:check` and `yarn test` in this order and stops at the first failure.

4. Make Git run `.githooks/pre-commit` for this repository, make the hook executable, and make it run `yarn check`. A commit with a type error must be refused.

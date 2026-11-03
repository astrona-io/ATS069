---
draft: true
exam_objectives:
- Compile a Backstage project with TypeScript
---
# Summary

A Backstage repository keeps its TypeScript rules in one shared base configuration and extends it from the root `tsconfig.json`. The base holds the rules that every package needs in the same way: strictness, the shape of the output, the JSX setting, `skipLibCheck`, `incremental` and the declaration options. The root file adds only local facts: which folders to check, which to exclude, and where output goes. For each option the nearest file wins, while list fields such as `include` are replaced as a whole. The command `tsc --showConfig` prints the merged result and is the way to know which rules really apply.

The option `strict` is a group of checks, among them `noImplicitAny` and `strictNullChecks`. It does not change the compiler output. It changes how much a passing result proves. Turning it off removes errors without removing the cases that cause them, so the right response to an error is a fix in the code. The option `skipLibCheck` makes the compiler skip errors inside declaration files, which makes the everyday check faster and hides mistakes in `.d.ts` files. The full check turns it off and turns incremental mode off, so it starts from nothing and reports declaration errors too.

The root scripts `tsc` and `tsc:full` give the repository one agreed way to run these checks. The check writes declaration files only, into the `dist-types` folder, which is ignored by version control. The build of a library package reads those declarations, so a pipeline runs the type check script before the build. Incremental mode keeps a build information file and rechecks only what changed, which keeps repeated runs short.

Key facts:

- The shared base holds the rules; the root file holds the scope and the output folder.
- A package that sets `strict` to `false` weakens the check for that package only.
- `skipLibCheck` skips every `.d.ts` file, including your own.
- A command-line flag overrides a value from the configuration file.
- `dist-types` is generated output and is not committed.

<!-- astrona:playground:destroy -->

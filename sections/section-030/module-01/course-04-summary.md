---
draft: true
exam_objectives:
- Compile a Backstage project with TypeScript
---
# Summary

The word compile covers several operations: reading and resolving modules, type checking, emitting JavaScript and declaration files, and bundling. The compiler, `tsc`, does the first three. A bundler or the Backstage command-line tool packages the result. A Backstage build does not check types, so type checking and building are two separate pieces of evidence, and a result from one says nothing about the other.

A type check covers only the files in its project. The `include`, `exclude` and `files` fields choose those files, and options such as `strict` and `skipLibCheck` set how strict the claim is. A green result needs to be read together with its scope and its options. Printing the file list and the merged configuration shows what a result really covers.

Types exist only while the compiler runs. The compiler removes them from the output, so nothing in the running program enforces them. A missing value must be handled in code, because a type assertion or a non-null operator only silences the compiler. Data that enters from outside the program, such as a parsed JSON body, arrives as `unknown` and needs a runtime check at the edge, after which typed code can rely on the result.

In a workspace, packages read each other through declaration files produced by their own builds. Project references declare the dependencies, build mode orders the projects and skips work that is up to date, and a missing reference or stale output makes results differ between machines. Generated output is never the place to repair a problem. A failure belongs to one layer: a type error to the declaration and its caller, a missing export to the package entry point, and a failing request to the running service.

Key facts:

- `tsc --noEmit` checks and writes nothing, and the exit code is the result.
- `--listFilesOnly` and `--showConfig` show the scope and the merged options.
- `as` and `!` add no runtime code.
- `composite` projects emit declarations and are linked with `references`.
- `tsc --build --clean` followed by a build shows whether a clean build passes.

<!-- astrona:playground:destroy -->

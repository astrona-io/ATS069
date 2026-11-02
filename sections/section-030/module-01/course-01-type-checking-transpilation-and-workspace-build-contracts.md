---
draft: true
exam_objectives:
- Compile a Backstage project with TypeScript
---
# Type Checking, Transpilation And Workspace Build Contracts

TypeScript adds a type system to JavaScript source. In a Backstage project it helps describe plugin APIs, entity shapes, component properties and service contracts. A type checker can reject a component that expects a string but receives an optional value without handling absence. It cannot establish that an external deployment service will answer correctly when the application runs.

Compilation is often used as a broad term, but several operations can be involved. Type checking evaluates declared source contracts. Transpilation removes or transforms TypeScript syntax into JavaScript. Bundling resolves and packages modules for a target environment. Declaration generation can produce type information for another workspace to consume. The project's scripts determine how these operations are combined; they should not be treated as interchangeable evidence.

Consider a plugin client that promises a deployment record with a status field. A component that reads a field not present in the interface should fail type checking. A component that reads the declared field and displays the wrong interpretation may still pass. If the remote server sends data that does not match the interface, a compile-time declaration cannot repair it. Runtime validation or a carefully implemented client boundary is needed where untrusted data enters.

The workspace graph matters because packages depend on one another. A frontend plugin may import types from a common package. A backend plugin may use the same common contract while implementing its own server behavior. Depending on the project configuration, consumers may resolve source directly during development or rely on generated build output during packaging. A successful local edit can therefore conceal a missing production artifact.

Package exports describe the supported entry points. Importing an internal file through a guessed path can bypass the public contract and break when a dependency reorganizes its files. Correcting the import to a supported exported interface is usually more durable than weakening type checking globally. A build error is evidence that a contract needs attention, not a reason to disable the check that found it.

Compiler configuration also defines scope. Included files, target syntax, module resolution and project references influence what is checked and emitted. A successful check over one workspace says nothing about a package excluded from that check. When evaluating a report, identify the configured scope instead of reading the word success as an application-wide guarantee.

Generated files should be treated consistently. Some repositories commit specific generated interfaces; others create them in the build. Either approach needs an explicit source of truth and repeatable procedure. Editing generated output while leaving its input unchanged creates a repair that disappears on regeneration. An unexplained old artifact can make one machine pass and another fail.

A useful diagnostic sequence separates source compatibility from execution. If the compiler reports an incompatible property, inspect the interface and the caller's handling of that value. If bundling cannot locate an export, inspect dependency declarations and package entry points. If a running route receives an unauthorized response, inspect its credential and permission boundary. These failures can occur together, but one does not imply the others.

Type assertions require particular care. An assertion tells the checker to accept a programmer's claim; it does not transform or validate incoming data. Asserting that an optional catalog annotation always exists can remove an error while leaving a crash path. Handling absence explicitly preserves both the source contract and the user's experience.

The TypeScript command `tsc --noEmit` checks the selected compiler project without writing JavaScript output. A Backstage repository can wrap its configured type check in a package script, while `backstage-cli repo build` performs the supported repository build operation. A frontend bundle is therefore not interchangeable with a type-check result. For a concrete type example, an optional property `owner?: string` requires code to handle absence before using it as a guaranteed string. Adding an assertion only changes the checker's assumption; it does not supply the absent runtime value.

## Common pitfalls

> [!WARNING]
> Do not equate a clean type check with a working integration. Avoid repairing incompatibility through broad assertions or disabled checks. Confirm the checked scope, supported package exports and generated inputs before interpreting build success.

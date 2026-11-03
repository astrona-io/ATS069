---
draft: true
exam_objectives:
- Compile a Backstage project with TypeScript
---
# What The Shared Base Configuration Sets

A repository with thirty packages needs one answer to the question "which TypeScript rules apply here?". If every package carries its own options, the answers drift apart: one package allows implicit `any`, another targets an older JavaScript version, and a type that passes in one place fails in another. A Backstage repository avoids this with one shared base configuration that the root `tsconfig.json` extends. This part shows what the base contains, how the extension works and how to read the result.

A `tsconfig.json` file is the configuration of one TypeScript compiler project: the files that belong to it and the options that apply to them. The field `extends` names another configuration file. The compiler reads that file first and then applies the options of the file that extends it on top, so a later value replaces an earlier one. In a Backstage app the root file extends `@backstage/cli/config/tsconfig.json`, a file that ships inside the `@backstage/cli` package. The `@backstage/cli` package is the command-line tool of the project, and it keeps the shared options so that the repository does not have to copy them.

## What the base sets and what the root adds

The shared base sets options that every package needs in the same way. Among them are the strictness options, the options that decide the shape of the output, and the JSX setting. JSX is the syntax that lets a React component contain markup inside TypeScript code. The option `jsx` tells the compiler how to treat it, and Backstage uses `react-jsx`, which compiles markup to calls into the React runtime. The base also sets `skipLibCheck`, `incremental`, `declaration` and `emitDeclarationOnly`. Each one is explained in this module.

The root file adds what only the repository can know. It lists the folders to check in `include`, excludes `node_modules`, and sets `outDir` and `rootDir`. The option `outDir` is the folder where the compiler writes output, and `rootDir` is the folder that the output layout starts from. This split is the rule to remember: shared rules live in the base, local scope lives in the root file.

The playground has a file `tsconfig.base.json` that plays the role of the shared base, because the playground has no Backstage packages. It sets a smaller set of options than the real base, but the extension works in the same way.

<!-- astrona:playground:renew -->

Open the workspace and print both files:

```sh
cd /opt/portal
cat tsconfig.base.json
cat tsconfig.json
```

The root file has an `extends` field, an `include` list and two `compilerOptions`. It does not mention `strict`, yet strictness applies. Prove it by printing the merged result:

```sh
tsc --showConfig
```

The output is the configuration after `extends` is resolved, as JSON. It lists `strict` with the value `true`, which came from the base, and `outDir` with the value `dist-types`, which came from the root file. The command `tsc --showConfig` is the quickest way to answer "what rules does this package really run under?", because it shows the final values and not the ones in a single file.

## Override and precedence

A file that extends another can replace single options. The rule is simple: the nearest file wins for each option separately. Options that the extending file does not mention keep the value from the base. The fields `include`, `exclude` and `files` behave differently from `compilerOptions`: if the extending file sets one of them, it replaces the whole list from the base and does not merge with it. The field `paths` inside `compilerOptions` is also replaced as a whole.

Test this in the playground. Save this as `tsconfig.override.json`:

```json
{
  "extends": "./tsconfig.json",
  "compilerOptions": { "target": "ES2020" }
}
```

Then print the merged result and look at `target` and `strict`:

```sh
tsc -p tsconfig.override.json --showConfig
```

`target` is `es2020`, and `strict` is still `true`. The file changed one option and inherited the rest. An extension can have several levels, as here: the override extends the root file, and the root file extends the base.

## Why packages should not weaken the base

Because every package inherits the base, a package can also undo it. A package file that sets `"strict": false` passes checks that the rest of the repository would fail. Nothing in the compiler marks this as unusual. The result is a repository in which a green check means different things in different folders. The habit that prevents this is to read `tsc --showConfig` for a package whenever a result looks too easy, and to review any change that sets an option the base already sets.

This part showed that the shared base holds the rules and the root file holds the scope, and that `tsc --showConfig` prints the merged truth. The open question is what the most important shared option, `strict`, actually switches on.

## Common pitfalls

> [!WARNING]
> Do not read only the file in front of you: the options in effect come from the whole `extends` chain, so print them with `tsc --showConfig`. A list field such as `include` is replaced, not merged, by an extending file. A package that sets an option the base already sets can silently weaken the check for that package only.

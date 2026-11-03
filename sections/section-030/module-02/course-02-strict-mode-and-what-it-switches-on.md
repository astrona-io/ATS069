---
draft: true
exam_objectives:
- Compile a Backstage project with TypeScript
---
# Strict Mode And What It Switches On

A new developer adds a helper function to the `deploy-backend` plugin. It takes one parameter and does not declare its type. The compiler accepts it, the helper works in a test, and a month later it crashes because a caller passes `undefined`. The same code would have been rejected under `strict`. This part explains what `strict` is, which checks it contains, and why the shared base turns it on.

The option `strict` is one switch that turns on a group of stricter checks. Each check in the group has its own option name, so they can be set one by one, but the shared base sets the whole group. A value that passes under the group is a stronger statement than a value that passes without it. The compiler does not change its output because of `strict`. It only reports more errors.

## The checks in the group

The most important members of the group are these.

- `noImplicitAny` reports an error when the compiler would have to guess the type of a value as `any`. The type `any` turns off checking for that value, so a parameter without a type declaration silently disables the checks around it.
- `strictNullChecks` makes `undefined` and `null` separate types. A value that may be `undefined` cannot be used as if it were present until the code checks it.
- `strictFunctionTypes` checks the parameter types of function values more carefully when one function is assigned to another.
- `strictBindCallApply` checks the arguments of `bind`, `call` and `apply`.
- `strictPropertyInitialization` requires that a class property is assigned in the constructor when its type does not allow `undefined`.
- `noImplicitThis` reports a use of `this` whose type the compiler cannot tell.
- `alwaysStrict` emits `"use strict"` in the output and parses the files in strict mode.
- `useUnknownInCatchVariables` types the variable of a `catch` clause as `unknown` instead of `any`.

Other options such as `noUnusedLocals` are not part of the group. They are separate options that a repository can add.

## Seeing the difference

The playground has a root file that inherits `strict` from the base. Start by checking the clean workspace.

<!-- astrona:playground:renew -->

```sh
cd /opt/portal
tsc
echo "exit code: $?"
```

The exit code is `0`. Now add a file with an untyped parameter. Save this as `packages/app/src/helper.ts`:

```ts
export function double(value) {
  return value * 2;
}
```

Run the check again:

```sh
tsc
echo "exit code: $?"
```

The compiler reports an error on `value`: the parameter implicitly has an `any` type, and the error number is `TS7006`. The exit code is not `0`. Now run the same file under a configuration that turns `strict` off. Save this as `tsconfig.loose.json`:

```json
{
  "extends": "./tsconfig.json",
  "compilerOptions": { "strict": false }
}
```

Then check with it:

```sh
tsc -p tsconfig.loose.json
echo "exit code: $?"
```

The exit code is `0`. The source did not change. Only the claim became weaker. The loose configuration accepts a function that any caller can use with a string, an object or `undefined`, and it reports nothing.

## The null checks

`strictNullChecks` is the check that prevents the most runtime crashes. Without it, `undefined` is allowed as a value of every type, so the compiler cannot see that a property marked optional may be missing. Add this to `packages/app/src/helper.ts`, replacing the first function:

```ts
import type { DeploymentRecord } from '@portal/deploy-common';

export function ownerName(record: DeploymentRecord): string {
  return record.owner.toUpperCase();
}
```

The property `owner` is declared with a question mark, so its type is `string | undefined`. Run `tsc` under the root configuration. The compiler reports that `record.owner` is possibly `undefined`. Run it with `tsconfig.loose.json`. The compiler accepts the line, and a record without an owner makes it throw a `TypeError` at runtime. Fix the root-configuration error by handling the missing value in code, for example with `record.owner === undefined ? 'unassigned' : record.owner.toUpperCase()`. Delete `helper.ts` and `tsconfig.loose.json` when you finish.

## Strict mode and existing code

A project that starts without `strict` and turns it on later gets many errors at once. Teams then often turn on the checks one at a time, starting with the one that finds most bugs. A Backstage repository created from the current template starts with `strict` on, and the shared base keeps it on, so the migration question only appears in older code. The rule for new code is to keep the group on and fix the errors, and not to add `any`, type assertions or `@ts-ignore` comments to silence them. A `@ts-ignore` comment makes the compiler skip the next line, which hides the same error that `strict` was meant to find.

This part showed the checks that `strict` contains and showed the same source pass and fail depending on one option. The next question is which files the check does not look at, even under `strict`.

## Common pitfalls

> [!WARNING]
> Do not switch `strict` off to make an error go away: the error describes a real case, and only the report disappears. Do not use `any`, `as` or `@ts-ignore` as a shortcut around `strictNullChecks` or `noImplicitAny`. When a result is green, check which options produced it.

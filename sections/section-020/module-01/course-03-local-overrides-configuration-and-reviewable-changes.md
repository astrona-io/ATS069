---
draft: true
exam_objectives:
- Understand local development workflows
---
# Local Overrides, Configuration And Reviewable Changes

A change that works on one machine and fails on every other is one of the most common problems in a shared project. The usual cause is that something the code needs exists only on the first machine: a configuration value, a generated file or a dependency that was never declared. This part explains how Backstage layers its configuration, what belongs in a local override, and what a reviewer needs to see to accept a change.

## Configuration is an input of the workflow

A Backstage application reads configuration from YAML files. The main file is `app-config.yaml`. It holds the values that every checkout needs, such as the base URLs of the app and the backend, the backend port and the database settings. Other files change some of those values for one situation: `app-config.production.yaml` for a deployment and `app-config.local.yaml` for one developer's machine.

The files are layered. The loader reads them in order and the last file wins. Backstage merges the layers with simple rules: objects merge deeply, so a later file can change one key of a block and leave the others alone. Primitive values and arrays are replaced completely, and arrays are not merged item by item. An environment variable with the prefix `APP_CONFIG_` has a higher priority than every file.

One rule surprises many developers. When you start Backstage with no `--config` flags, it loads `app-config.yaml` and then `app-config.local.yaml`, so the local file wins. When you pass any `--config` flag, the loader reads only the files you name and loads no default file. A production start command that names `app-config.yaml` and `app-config.production.yaml` therefore never reads `app-config.local.yaml`, even if the file exists on the machine.

## See the merge

The practice workspace has a script that prints the merge of the files you name, with the last file winning. It follows the object and array rules above. It does not replace `${...}` references. Run it with and without the local file:

<!-- astrona:playground:renew -->

```sh
cd /opt/portal
python3 scripts/show-config.py app-config.yaml
python3 scripts/show-config.py app-config.yaml app-config.local.yaml
```

In the second output the value of `backend.listen.port` is `7008`, because the local file replaces the value from the shared file. The key `backend.database.connection.host` also changes, but the sibling keys `port` and `user` stay, because objects merge deeply. This is the intended use of a local override: change a few values for this machine and leave the rest shared.

## What belongs in the local file

A local override holds values that are true for one developer: a different port because another program uses 7007, a database on the loopback address, or a token for a personal sandbox. It does not hold anything that other checkouts also need.

Consider the key `catalog.ownerWarning.enabled`. A developer adds it to `app-config.local.yaml` to try the warning, and the feature works. The developer commits the code and never adds the key to the shared file, because the local file is ignored by Git. Every other checkout runs without the key, and the feature is off. The local file hid a missing shared requirement. The fix is to put the key in `app-config.yaml`, where it is committed and reviewed, and to leave only machine-specific values in the local file.

Ask one question of each key in a local file: would a new checkout need this value to behave as intended? If the answer is yes, the key belongs in a shared file.

## Secrets enter through the environment

A configuration file that is committed must not contain a secret, because Git keeps every version forever. Backstage supports substitution: a value written as `${BACKEND_DB_PASSWORD}` is replaced by the value of that environment variable when the configuration is loaded. A default is written as `${NAME:-default}`, which is used when the variable is unset or empty. If the variable is not set and no default exists, the whole configuration value is undefined. The loader does not fall back to some other text.

The shared file in the practice workspace uses this form for the database password. The line has no secret in it. Anyone can read the line and learn which variable the deployment must provide. Run a search for the common mistake, a literal password in a committed file:

```sh
grep -n "password" app-config.yaml app-config.production.yaml
```

Each match should show a `${...}` reference. A literal value in the output means a secret has been committed, and removing it in a later commit does not remove it from the history.

## Keep the local file out of Git

The local override file is a personal file, so Git must ignore it. A generated Backstage project already lists `app-config.local.yaml` in `.gitignore`. Check the practice workspace:

```sh
git check-ignore app-config.local.yaml
git status --short
```

The first command prints the file name if an ignore rule matches. The file does not appear in `git status`. If you remove the rule from `.gitignore` and run `git status` again, the file appears as untracked, and one careless `git add -A` would commit your personal values.

## Dependencies are part of the change

A source file that imports a package depends on that package being declared. A declaration is a line in the `package.json` of the package that imports it. The lockfile, `yarn.lock`, records the exact versions Yarn resolved for every declared dependency. Both files belong in the change.

If code imports a package that happens to exist in the root `node_modules` because another package needs it, the import resolves on your machine. A clean install, or a production build that installs only what one package declares, can fail to find it. The command `yarn install --immutable` helps here: it fails instead of changing the lockfile, so a lockfile that does not match the declarations shows up as an error before review.

When a change adds a dependency, review the declaration, the lockfile entry and the reason together. When a change touches the workspace configuration, review whether every package still appears in `yarn workspaces list`.

## A worked failure on a clean checkout

Follow one failure from symptom to cause. A colleague clones the repository and runs `yarn install` and `yarn start`. The backend starts, but the owner warning never appears. The colleague has the same source code as you. Only the inputs can differ, so list them: the source files, the declared dependencies, the lockfile and the configuration files.

The source files are identical because Git holds them. The dependencies match because the lockfile is committed. That leaves the configuration, and the colleague has no `app-config.local.yaml` with your key. Run `python3 scripts/show-config.py app-config.yaml` to see what a checkout without a local file receives. The key `catalog.ownerWarning` is absent from that output, which proves the cause. No debugger was needed, because the merge of the shared file shows exactly what a clean checkout gets.

The same method works for a missing dependency. List what a clean install receives, which is what the `package.json` files and the lockfile declare, and compare it with what your machine has.

## Describe what a reviewer needs

A reviewer cannot see your terminal. A good description of a change has three parts. First, the behavior: what a user sees, for example "a service without an owner shows a warning, and a failed catalog request shows an error". Second, the boundaries: which packages and configuration files changed, as `git status` lists them. Third, the evidence: the commands you ran and what each proved, for example "`yarn tsc` shows the three packages agree on the `Entity` type, and `yarn test` covers the owned, missing and error results".

State only what you checked. If you did not test the real catalog integration, say that the change was checked against the shared type and the unit tests. A description that claims more than the evidence invites the reviewer to trust a check that never ran.

Keep upgrades and features apart. A Backstage release can change how plugins are added or how the app is wired. If a plugin's instructions target a different architecture than the one your app uses, a migration is a separate decision, and mixing it into a feature change makes failures hard to assign.

## What this part showed

You saw how configuration files layer, why the local file is loaded only when no `--config` flag is given, how `${NAME}` keeps secrets out of Git, and why a key that every checkout needs belongs in the shared file. You also saw that dependency declarations and the lockfile travel with the change, and what a reviewer needs from a description. Together with the earlier checks, this gives a change that works on a clean checkout and that another person can verify.

## Common pitfalls

> [!WARNING]
> Do not treat the local override as the only place a new required key is written. Do not commit a literal secret, even briefly: Git history keeps it. Do not assume `app-config.local.yaml` is read in production: any `--config` flag turns off the default files. Do not rely on a package that is installed at the root but not declared by the package that imports it.

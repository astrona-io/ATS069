# Solution

Open a shell in the lab and change to the workspace with `cd /opt/portal`. Each step below ends with a check you can run, and `astrona submit` grades the whole task.

## 1. Fix the type error

Run the type check:

```sh
yarn tsc
```

The compiler reports that `owner` does not exist on the type `Entity`. The shared type keeps the owner at `spec.owner`, so the app code must read it there. Open `packages/app/src/ownerWarning.ts` and change the function body to this:

```ts
if (!entity) return 'error';
if (!entity.spec?.owner) return 'missing';
return 'owned';
```

Run `yarn tsc` again. It prints nothing when it succeeds.

## 2. Keep the three results apart

The same edit fixes the tests. The old code returned `error` for an entity without an owner, so the test for a missing owner failed. Run the tests:

```sh
yarn test
```

## 3. Move the shared key out of the local file

Edit `app-config.yaml` and add this block at the end:

```yaml
catalog:
  ownerWarning:
    enabled: true
```

Edit `app-config.local.yaml` and delete the `catalog` block. The `backend.listen.port: 7008` override stays. Check the merge:

```sh
python3 scripts/show-config.py app-config.yaml app-config.local.yaml
```

## 4. Read the password from the environment

In `app-config.yaml`, replace the line `password: hunter2` with:

```yaml
      password: ${BACKEND_DB_PASSWORD}
```

Backstage replaces the reference with the value of the environment variable when it loads the configuration.

## 5. Ignore the local override

Add a line to `.gitignore`:

```sh
echo app-config.local.yaml >> .gitignore
git check-ignore app-config.local.yaml
```

The last command prints the file name when Git ignores it. Then run `astrona submit`.

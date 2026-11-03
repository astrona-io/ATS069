# Solution

Solve this lab on `terminal`. Each step ends with `astrona submit`. This lab was built without running it, so the text describes what you should see instead of printing output.

Open a shell and go to the project:

```sh
cd /opt/portal
```

`astrona submit` right after the start shows that the project setup check passes and that the others fail.

## Step 1: Declare the peer dependency

Read the plugin manifest:

```sh
cat packages/plugin/package.json
```

The plugin code requires `@internal/shared`, but the manifest lists nothing. Edit `packages/plugin/package.json` and add two fields:

```json
"peerDependencies": { "@internal/shared": "^1.0.0" },
"devDependencies": { "@internal/shared": "workspace:^" }
```

The peer range is a normal version range, because a consumer outside the repository must be able to read it. Submit:

```sh
astrona submit
```

The check `plugin-peer-declared` passes.

## Step 2: Remove the literal token

Print the file and delete the `npmAuthToken` line that holds the value starting with `npm_FAKE`:

```sh
cat .yarnrc.yml
nano .yarnrc.yml
astrona submit
```

The check `token-not-in-file` passes. In a real repository, you would also revoke the token, because it stays in the history of version control.

## Step 3: Route the scope

Add this block to `.yarnrc.yml`:

```yaml
npmScopes:
  internal:
    npmRegistryServer: "https://npm.internal.example.com"
    npmAlwaysAuth: true
    npmAuthToken: "${NPM_TOKEN:-}"
```

The scope key has no at sign. Check what Yarn reads, then submit:

```sh
yarn config get npmScopes
astrona submit
```

The check `scope-routed` passes.

## Step 4: Answer with yarn why

```sh
yarn install
yarn why @internal/shared
```

The command lists the workspaces that ask for `@internal/shared`. Write their names to the answer file:

```sh
printf 'backend\n@internal/plugin\n' > answers.txt
astrona submit
```

The workspace `app` also lists `@internal/shared`. You may add it to the file, because the check requires only `backend` and `@internal/plugin`.

## Step 5: Confirm the install

```sh
yarn install --immutable
echo "exit code: $?"
astrona submit
```

The exit code is `0` and all checks pass. The install needs no access to the private server, because every internal package is a workspace.

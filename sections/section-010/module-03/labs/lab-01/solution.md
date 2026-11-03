# Solution

Work in `/opt/envcfg`. Use `astrona submit` after each step to see which check passes.

## 1. Match the CORS origin to the app

Run the check and read the configuration:

```sh
cd /opt/envcfg
python3 tools/check-config.py cors
grep -n "baseUrl\|origin" app-config.yaml
```

The check reports that `backend.cors.origin` is `http://localhost:3001` while `app.baseUrl` is `http://localhost:3000`. A browser compares the origin of the page with the allowed origin of the backend, and the port is part of the origin. Change the value to `http://localhost:3000`.

## 2. Define the guest provider for development

Open `app-config.yaml` and replace the empty `providers` value under `auth`:

```yaml
auth:
  environment: development
  providers:
    guest: {}
```

The empty object enables the provider without options. Leave `app-config.production.yaml` as it is, because it must not offer guest sign-in.

## 3. Fix the catalog location

```sh
python3 tools/check-config.py catalog
```

The check prints the path that the target resolves to. The folder name is `example`, but the real folder is `examples`. Change the target to `../../examples/entities.yaml`. The path climbs from `packages/backend` to `/opt/envcfg`.

## 4. Read the password from the environment

In `app-config.production.yaml` replace the literal value:

```yaml
      password: ${POSTGRES_PASSWORD}
```

The process replaces the substitution with the value of the environment variable when it loads the file. The secret then stays out of the repository. Run `astrona submit` to confirm that all five checks pass.

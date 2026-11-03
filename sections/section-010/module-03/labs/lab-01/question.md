# Question

Solve this question on: `terminal`

The folder `/opt/envcfg` holds the configuration files of the `portal` project of the `starfleet` platform team. They have the shape of a Backstage configuration, but no Backstage process runs here. The script `tools/check-config.py` checks one rule at a time. It takes the rule name as its argument and prints `OK` or the problem. Four values are wrong. Fix them in the configuration files.

1. The app is served at `app.baseUrl`, and the browser sends requests to the backend from that origin. The backend must allow exactly that origin in `backend.cors.origin`. Run `python3 tools/check-config.py cors`.

2. Developers sign in with the guest provider on their own machines. Define `auth.providers.guest` in `app-config.yaml`. Do not define it in `app-config.production.yaml`.

3. The catalog loads the entity file `examples/entities.yaml` through a `file` location in `app-config.yaml`. File targets are resolved from the `packages/backend` folder. Fix the target so that it resolves to the existing file.

4. In production the database password must come from the environment variable `POSTGRES_PASSWORD`, like the other connection values. A literal password sits in `app-config.production.yaml` today. Replace it with the substitution.

Do not delete a file, and do not change the database clients.

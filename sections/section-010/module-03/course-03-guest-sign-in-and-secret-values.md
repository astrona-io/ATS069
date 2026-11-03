---
draft: true
exam_objectives:
- Build and run Backstage projects locally
---
# Guest Sign-In And Secret Values

A developer who starts a fresh project wants to reach the interface without setting up an identity provider. At the same time, the project holds tokens for outside systems that must never reach a repository or a browser. This part explains the guest sign-in provider for development and the rules for secret values in configuration.

Authentication proves who a user is. In Backstage, the auth backend plugin offers sign-in providers, and the sign-in page of the app lists the providers that the app enables. The guest provider signs every visitor in as a generic user named `guest`, without a password. It exists for local development only.

<!-- astrona:playground:renew -->

Read the authentication block and run the checker:

```sh
cd /opt/envcfg
grep -n -B1 -A3 "auth:" app-config.yaml
python3 tools/check-config.py guest
```

The base file sets `auth.environment` to `development` and defines `auth.providers.guest` as an empty object. The checker prints `OK` when the provider is in the base file and not in the production file.

## How the guest provider is enabled

Two pieces must exist. In the configuration, the empty object `guest: {}` under `auth.providers` enables the provider without options. In the code, the backend loads the guest provider module, and the app lists the guest provider on its sign-in page. A generated project includes both. If the configuration key is removed, the sign-in page shows the guest option, and choosing it fails, because the backend has no such provider configured.

The guest provider refuses to run when `auth.environment` is not `development`. A production start with the provider configured reports an error, unless an option explicitly allows it. That option exists for tests, and using it in production means that anyone who reaches the portal is signed in. The correct production setup removes the guest provider and configures a real identity provider.

## Where secret values belong

A secret is a value that grants access, such as a token, a password or a client secret. Three rules keep secrets safe:

- Write the substitution `${GITHUB_TOKEN}` in the file, and set the value in the environment of the process.
- Put values that belong to one machine in `app-config.local.yaml`, which the generated `.gitignore` excludes, or in the environment.
- Put secrets under backend-only keys. The frontend receives configuration that the build marks as visible, and a secret there is public to every user of the page.

```sh
grep -n '${' app-config.yaml app-config.production.yaml
```

The command lists every value that the process reads from an environment variable: the GitHub token in the base file and the four database values in the production file.

## The GitHub integration

An integration tells Backstage how to read from an outside system. The `integrations.github` list holds one entry per GitHub host, and the `token` key holds a personal access token or another credential. The catalog and the scaffolder use it to read `catalog-info.yaml` files from repositories. If the token is missing, public repositories can still be read but with a low rate limit, and private repositories fail with an authorization error from GitHub.

An authorization error such as HTTP 401 or 404 from GitHub points at the token or its scopes. It does not point at the catalog code, so check the integration first.

## Common pitfalls

> [!WARNING]
> Do not commit a token, even a short-lived one, because it stays in the history. Do not enable the guest provider outside development. A substitution for a variable that is not set leaves the key without a value, so a start can fail far from the line that caused it: when a key looks right, check that the variable exists in the process environment.

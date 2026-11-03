---
draft: true
exam_objectives:
- Build and run Backstage projects locally
---
# Summary

A local Backstage project runs a frontend on port 3000 and a backend on port 7007. The `listen` block controls the port the process binds, and the `baseUrl` values control the addresses that components use. The browser treats the two servers as different origins, so the backend must allow the origin of the app in `backend.cors`, with the same scheme, host and port. A port can be overridden with an `APP_CONFIG_` environment variable.

The backend stores its data in a database that the configuration selects. The local default is in-memory SQLite, which is fast and loses its data at each stop. PostgreSQL keeps data on disk and needs host, port, user and password, which belong in environment variables written as `${NAME}` substitutions. By default each plugin gets its own database, so the database user needs permission to create databases.

Guest sign-in lets a developer into a local portal with one empty configuration object, and it works only when `auth.environment` is `development`. Secrets never belong in committed files: use substitutions, ignored local files and backend-only keys. The catalog loads entities from locations, a `file` location is resolved from the backend working directory, and a bad location produces an error in the log, not a failed start. The proxy forwards requests from the app to an outside service and can add a secret header on the server side.

Key facts:

- The CORS origin must match the app origin exactly, including the port.
- `':memory:'` SQLite data is lost when the backend stops.
- `${NAME}` in a configuration file reads an environment variable.
- Guest sign-in must not be configured in production.
- A failing catalog location shows up as missing data and a log entry.

<!-- astrona:playground:destroy -->

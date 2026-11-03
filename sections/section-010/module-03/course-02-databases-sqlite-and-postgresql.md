---
draft: true
exam_objectives:
- Build and run Backstage projects locally
---
# Databases: SQLite And PostgreSQL

The Backstage backend stores catalog entities, scaffolder tasks, search state and plugin data in a relational database. A project that starts with no database setting has already chosen one. This part explains the local default, what it loses on restart, and how to move to PostgreSQL by configuration alone.

A relational database stores data in tables and answers queries written in SQL. The backend talks to it through a database client, a library for one database product. The `backend.database.client` key names the client. The generated project includes two: `better-sqlite3` for SQLite and `pg` for PostgreSQL.

<!-- astrona:playground:renew -->

Compare the two settings in the playground files:

```sh
cd /opt/envcfg
grep -n -A3 "database:" app-config.yaml
grep -n -A7 "database:" app-config.production.yaml
```

The base file selects `better-sqlite3` with the connection `':memory:'`. The production file selects `pg` and lists host, port, user and password.

## SQLite in memory for local development

SQLite is a database engine that runs inside the application process. It needs no server and no installation of a database product. With the connection value `':memory:'`, the data lives in the memory of the backend process. This makes a local start fast and clean, and it means that all data disappears when the process stops. Entities that came from the catalog locations return at the next start, because the backend loads them again. Anything a user created through the interface does not.

SQLite can also write to a file, with a connection such as `{ filename: ./local.db }`. That keeps the data between restarts on one machine.

## PostgreSQL for persistent data

PostgreSQL is a database server that runs as its own process and holds data on disk. The production file sets the client to `pg` and gives a `connection` object:

```yaml
backend:
  database:
    client: pg
    connection:
      host: ${POSTGRES_HOST}
      port: ${POSTGRES_PORT}
      user: ${POSTGRES_USER}
      password: ${POSTGRES_PASSWORD}
```

Each value uses the substitution syntax `${NAME}`, which the configuration loader replaces with the value of the environment variable of that name. The secret stays out of the repository, and the same file works in every environment that sets the variables. A developer who wants PostgreSQL locally can start a server with Docker and point the variables at it:

```sh
docker run --name backstage-postgres -e POSTGRES_PASSWORD=secret -p 5432:5432 -d postgres
export POSTGRES_HOST=localhost POSTGRES_PORT=5432 POSTGRES_USER=postgres POSTGRES_PASSWORD=secret
```

The first command starts a PostgreSQL container that publishes port 5432. The second sets the four variables for the current shell. The backend then needs the `--config` option for a file that selects `pg`, because the base file selects SQLite.

## One database per plugin

By default the backend creates a separate PostgreSQL database for each plugin, with a name that starts with `backstage_plugin_`, for example `backstage_plugin_catalog`. The database user therefore needs the permission to create databases. If that permission is missing, the backend stops at start with a permission error from PostgreSQL. The error names the failed statement, which points at the user permissions and not at the Backstage configuration.

## Telling failures apart

A refused connection means that no server listens at that host and port: check that the container runs and that the port is right. An authentication failure means that the server answered and rejected the user or the password: check the variables. A missing variable means that the connection key has no value, and the backend reports that it cannot connect or that a required key is missing. The three failures need three different fixes, so read the first error line before changing anything.

## Common pitfalls

> [!WARNING]
> Never write a real password into `app-config.yaml`. Use the substitution and set the variable in the environment. In-memory SQLite is not a place to keep data that matters. A project that works with SQLite can still fail with PostgreSQL because of a missing permission, so test the production client before a release.

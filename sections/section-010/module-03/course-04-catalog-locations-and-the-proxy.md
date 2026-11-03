---
draft: true
exam_objectives:
- Build and run Backstage projects locally
---
# Catalog Locations And The Proxy

A portal with no data looks broken even when every process runs. This part explains how the catalog gets its first entities from a location, how a bad location fails, and how the backend proxy lets the app call an outside service without exposing a token or hitting CORS.

The software catalog is the Backstage feature that stores descriptions of software, called entities, such as components, systems and APIs. A catalog location is a pointer to a file that holds entity descriptions. The `catalog.locations` list in the configuration holds the locations that the catalog loads at start and refreshes later.

<!-- astrona:playground:renew -->

Read the catalog block and run the checker:

```sh
cd /opt/envcfg
grep -n -A8 "^catalog:" app-config.yaml
python3 tools/check-config.py catalog
```

The block lists one `rules` entry and one `file` location. The checker prints `OK` when the target resolves to an existing file.

## Location types and rules

A `file` location reads a file from the disk of the backend. A relative target is resolved from the working directory of the process. Yarn starts the backend from `packages/backend`, so the target `../../examples/entities.yaml` climbs two folders to the repository root. A `url` location reads a file from a remote address, for example a `catalog-info.yaml` in a GitHub repository, and needs a matching integration.

The `catalog.rules` list limits which entity kinds a location may add. The entry `allow: [Component, System, API, Resource, Location]` permits those kinds. An entity of another kind, for example `Template`, is rejected unless a rule or the location itself allows it. A rule that is too narrow is a common reason for an entity that is "in the file but not in the catalog".

## How a bad location fails

The backend does not stop when a location cannot be read. It starts, and the catalog logs an error for that location. The catalog page is simply empty or shorter than expected. The symptom is therefore missing data and not a failed start, and the evidence is in the backend log. Change one thing at a time: first confirm the path, then the YAML syntax, then the entity kind and the rules.

To see it, change the target in the playground to a folder name that does not exist, run the checker and read the path it prints. Restore the target afterwards.

## The proxy

The proxy is a backend plugin that forwards requests from the app to an outside service. The `proxy.endpoints` key lists the endpoints:

```yaml
proxy:
  endpoints:
    /status-api:
      target: http://localhost:9000
      changeOrigin: true
```

A request from the app to `/api/proxy/status-api/health` reaches the backend, and the backend forwards it to `http://localhost:9000/health`. The option `changeOrigin` rewrites the host header to match the target. An endpoint can also add headers, such as an `Authorization` header built from `${STATUS_API_TOKEN}`. The browser never sees that header, and the app talks only to its own backend, so there is no CORS problem with the outside service.

```sh
grep -n -A4 "^proxy:" app-config.yaml
```

The proxy plugin must also be loaded in the backend code. If it is not, the path `/api/proxy` answers with a not-found response even though the configuration is correct.

## Common pitfalls

> [!WARNING]
> A catalog problem does not stop the backend, so read the log before you suspect the database. Do not use a `file` location in production unless the file is in the container image. A proxy endpoint exposes the outside service to everyone who can reach the backend, so keep its path and headers narrow.

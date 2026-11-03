---
draft: true
exam_objectives:
- Build and run Backstage projects locally
---
# Database, Ports, Proxies And Local Integrations

A Backstage project that starts is not yet a project that works. The app must reach the backend, the backend must have a database, a developer must be able to sign in, and the catalog must have data. This module follows those four needs through the configuration files, and shows which value controls each one.

## Learning Goals

- Explain the roles of ports 3000 and 7007, the two base URLs and the CORS settings.
- Compare the SQLite database of a local start with a PostgreSQL database and set the connection safely.
- Enable guest sign-in for development and explain why it stays out of production.
- Add a catalog location and a proxy endpoint, and say where each is resolved.

## Before You Start

You should be able to read a YAML file. The hands-on parts use a playground, which is an Ubuntu virtual machine with a folder of example configuration files and a small checker script. No Backstage process runs there, so the parts read and change the files, and describe what a real process does with them. Technical terms are defined where they first appear.

## Reading Order

1. Ports, Base URLs And CORS
2. Databases: SQLite And PostgreSQL
3. Guest Sign-In And Secret Values
4. Catalog Locations And The Proxy
5. Summary

<!-- astrona:playground -->

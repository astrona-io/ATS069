# Overview: Database, Ports, Proxies And Local Integrations (Playground)

This is a playground, not a lab. It starts an Ubuntu virtual machine with example configuration files and waits. There is no task, no `astrona submit` and no pass or fail.

## What is in the box

- Node.js 22, Yarn 4 and Python 3 with PyYAML.
- `/opt/envcfg/app-config.yaml`: a development base file with ports, CORS, a SQLite database, guest sign-in, a GitHub integration, a proxy endpoint and a catalog location.
- `/opt/envcfg/app-config.production.yaml`: an override with a PostgreSQL database and public URLs.
- `/opt/envcfg/examples/entities.yaml`: one example catalog entity.
- `/opt/envcfg/tools/check-config.py`: checks one rule (`cors`, `guest`, `catalog` or `password`) and prints OK or the problem.

## Practice tasks

- Read both files and note which keys the production file overrides.
- Run `python3 tools/check-config.py cors`, then change `backend.cors.origin` to another port and run it again. Restore it.
- Change the catalog `target` to a path that does not exist and run the `catalog` check.
- Write a small Python script that loads both files, merges them with the second one winning, and prints `backend.database.client`.
- Run `grep -n '\${' app-config.yaml app-config.production.yaml` and list every value that comes from an environment variable.

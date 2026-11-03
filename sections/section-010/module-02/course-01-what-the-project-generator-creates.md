---
draft: true
exam_objectives:
- Build and run Backstage projects locally
---
# What The Project Generator Creates

Every Backstage project starts from one command. A developer who knows what that command writes to disk can find any file later without searching. This part explains the generator, its prompt, the folders it creates and the files that belong to the project owner from the first minute.

The generator is the npm package `@backstage/create-app`. A package is a folder of code with a `package.json` file that names it. The generator is run with `npx`, which downloads a package from the npm registry and runs it once. The usual command is `npx @backstage/create-app@latest`. The tool asks for the name of the new application and creates a folder with that name. It then installs the dependencies with Yarn, unless the command is given the `--skip-install` option.

<!-- astrona:playground:renew -->

Open a shell in the playground with `astrona ssh ats-069-playground-010-02`. The workspace `/opt/scaffold` has the same layout as a generated project, in a reduced form:

```sh
cd /opt/scaffold
ls
ls packages plugins
```

The listing shows the root files and two package folders. The next sections explain each one.

## The root of the project

The root folder is the repository. Its `package.json` lists the workspaces and the scripts that a developer runs every day. A workspace is a package folder that Yarn manages as part of the repository. The `.yarnrc.yml` file sets the Yarn options, for example `nodeLinker: node-modules`, which tells Yarn to create a normal `node_modules` folder. The file `backstage.json` records the Backstage release that the project was created with or last upgraded to.

```sh
cat backstage.json
cat .yarnrc.yml
```

Two configuration files sit in the root as well. `app-config.yaml` holds the base configuration for both the frontend and the backend. `app-config.production.yaml` overrides some values for a production run. A project owner often adds a third file named `app-config.local.yaml` for settings that belong to one developer machine. That file name is a convention that the generated `.gitignore` already excludes from version control.

## The packages and plugins folders

The folder `packages/app` holds the frontend application, the part that runs in the browser. The folder `packages/backend` holds the backend, a Node.js process that serves the APIs and loads backend plugins. The folder `plugins` starts empty in a generated project. Plugins that the team writes go there, one folder per plugin.

```sh
cat packages/app/package.json
cat packages/backend/package.json
```

Both package files have the same four scripts: `start`, `build`, `lint` and `test`. Each script calls a `backstage-cli package` command. The scripts are short because the real work is in the command-line tool, not in each package.

## Files that make the project yours

The generator copies a template. After that, nothing in the repository updates itself from the template. The project owner owns every file, including the root scripts, the configuration and the example catalog entities in the `examples` folder. A later Backstage release does not rewrite these files. The owner moves the project forward by upgrading the packages and by applying changes to the owned files by hand.

The file `catalog-info.yaml` in the root describes the project itself as a catalog entity. It is an example of metadata that Backstage can read. It does not change how the project builds or starts.

## Common pitfalls

> [!WARNING]
> The generator needs access to the npm registry and a supported Node.js release, so a failed run on a machine without internet access is an environment problem, not a project problem. Run the generator in an empty parent folder, because it creates a new folder and does not add files to an existing project. Do not edit files under `node_modules`: Yarn replaces them at the next install.

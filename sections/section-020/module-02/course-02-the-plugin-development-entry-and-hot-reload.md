---
draft: true
exam_objectives:
- Understand local development workflows
---
# The Plugin Development Entry And Hot Reload

Starting the whole portal to test one small change is slow, and a broken part elsewhere can hide your result. Backstage plugins therefore have a development entry point that runs the plugin alone. This part explains that entry point and what hot reload does while you edit.

## The dev folder

A generated plugin has a `dev/` folder next to `src/`. The folder holds one file that is not part of the published package. For a frontend plugin the file is `dev/index.tsx`. It creates a small app that contains only this plugin and, where needed, fake APIs that return sample data. For a backend plugin the file is `dev/index.ts`. It starts a test backend that loads only this plugin.

The file is the development entry point: the file that the start command runs first. Running the plugin through it needs no other plugin, no running catalog and no login. That is why a plugin can be developed with a few seconds of start time.

Look at the entry point of the frontend plugin in the playground:

```sh
cd /opt/portal/plugins/hello
cat dev/index.ts
```

The file imports the plugin from `../src/index.ts` and renders it with sample data. The real file in a generated plugin builds a page in a browser instead of printing text, but the idea is the same.

## Starting a plugin alone

In a generated project the `start` script of a plugin package runs `backstage-cli package start`. The command detects the package role. For a frontend plugin it starts a development web server on port 3000 and rebuilds the browser code. For a backend plugin it starts the backend process with the plugin loaded. You run it from the plugin folder, or from the root with `yarn workspace @internal/plugin-hello start`.

In the playground the `start` script runs the entry point with `node --watch`. Start it:

```sh
yarn start
```

The process prints the greeting from the sample data and keeps running, because `--watch` tells Node.js to wait for file changes.

## Hot reload

Hot reload means that the running program picks up a source change without a manual restart. The frontend development server rebuilds the changed modules and sends the update to the open browser tab, which often keeps the page state. A backend start command watches the source and restarts the process or reloads the changed modules. The cost of a change is the time of a rebuild, not of a full start.

Open a second shell and change the plugin text:

```sh
cd /opt/portal/plugins/hello
sed -i 's/Greeting: /Welcome: /' src/plugin.ts
```

The first shell prints the new line without any command from you, because Node.js saw that an imported file changed and restarted the process. Restore the file with `git checkout src/plugin.ts` and stop the process with `Ctrl+C`.

## What a hot reload does not prove

A hot reload shows that the changed file compiles and runs inside the entry point. It does not show that the app loads the plugin, or that the backend serves its routes, or that other plugins still work. It also does not run the tests or the type check. A change can look right in the entry point and still fail when the app imports it with a different configuration.

There is one more limit. Some changes need a full restart, for example a change to a configuration file or to an environment variable, because the process reads those values once at start.

## What this part showed

You saw that the `dev/` entry point runs a plugin alone with sample data, that the `start` script of the plugin package starts it, and that hot reload applies a source change without a manual restart. You also saw what a hot reload does not prove. The next question is how a backend plugin turns requests into answers, and which route it owns.

## Common pitfalls

> [!WARNING]
> Do not treat a working `dev/` entry point as proof that the plugin works in the portal. Do not wait for hot reload after changing a configuration file or an environment variable: restart the process. If the start command stays silent after an edit, check that the file you changed is imported by the entry point.

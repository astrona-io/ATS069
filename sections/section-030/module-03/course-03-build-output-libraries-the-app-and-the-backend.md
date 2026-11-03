---
draft: true
exam_objectives:
- Compile a Backstage project with TypeScript
---
# Build Output: Libraries, The App And The Backend

A release job needs three different things from one repository: a library that other repositories install, a set of static files for the browser and a server that runs in a container. The same command, `backstage-cli package build`, produces all three, but the result looks different for each role. This part explains what each kind of package writes, how `package.json` points at it and what an option such as `--minify` changes.

The output folder of a package is `dist`. Build output is generated, so it is not committed. A fresh checkout has no `dist` folders, and the build creates them.

## Libraries

A library is imported by other packages, so its build must produce files that Node.js or a bundler can load. In a Backstage repository a library builds to JavaScript in `dist`, normally in both the CommonJS format and the ES module format, and to one file of types that describes the public API. CommonJS is the older module format that uses `require`, and an ES module is the newer format that uses `import`. Offering both lets old and new consumers load the package.

Inside the repository a library points at its source, so development needs no build. When the package is published, the entry points are replaced by the build output. The `package.json` fields involved are these.

- `main` is the entry file that Node.js loads when another package imports this one.
- `types` is the entry file of the type declarations.
- `files` is the list of files and folders that a published package contains. A folder that is not listed is not published.
- `publishConfig` holds values that replace the top-level fields when the package is published, for example `main` and `types` that point at `dist`.

A published package therefore needs `dist` in `files`. If `files` names only `src`, the package is published without its build output, and the `main` field points at a file that is not there. Consumers then fail with a module-not-found error.

## The playground output

The playground build is a stand-in. It writes plain JavaScript to `dist` and no bundle or type file. It still shows the relation between the manifest and the output.

<!-- astrona:playground:renew -->

```sh
cd /opt/portal
npm run build:all
ls plugins/deploy-common/dist
grep -E '"main"|"files"' plugins/deploy-common/package.json
```

The folder has `index.js`, which is the file that `main` names. The `files` field lists `dist`. Ask npm what a published package would contain:

```sh
cd plugins/deploy-common
npm pack --dry-run
cd /opt/portal
```

The listing includes `dist/index.js` and `package.json`. Edit `files` to `["src"]`, run the `npm pack --dry-run` command again and look at the list: `dist/index.js` is gone, and a consumer would get a package with a `main` field that points at nothing. Restore the `files` field when you are done.

## The frontend app

The `frontend` role does not produce a library. It produces a set of static files: HTML, JavaScript, CSS and images. The build bundles the app and all its dependencies and writes them to `dist` in the app package. A web server or a CDN, a content delivery network, serves these files. The browser downloads them and runs them. The files hold no server code and no secrets, because every visitor can read them. The app reads its configuration at build time or from a configuration the backend serves, and values in the browser files are public.

## The backend

The `backend` role produces a bundle that Node.js runs. The build writes the bundled backend into the `dist` folder of the backend package, together with two archives, `skeleton.tar.gz` and `bundle.tar.gz`. The skeleton archive holds the `package.json` files of the workspace packages that the backend needs. The bundle archive holds the built output. A container build unpacks the skeleton first and installs dependencies from it, then unpacks the bundle. Splitting them lets a container build reuse the cached dependency layer when only the code changes. The command that creates them is `yarn build:backend` in a repository from the template, which runs the build of the backend workspace.

Run the stand-in for it in the playground. Delete the backend output and build only that package:

```sh
rm -rf packages/backend/dist
npm run build:backend
node -e "console.log(require('/opt/portal/packages/backend').startBackend(7007))"
```

The output is `backend listening on 7007`. The other packages kept their `dist` folders, because only the backend workspace was built.

## The minify option

The command `backstage-cli package build` takes an option `--minify` that makes the output smaller by removing whitespace and shortening names. It is meant for library output, and it does not apply to the app and backend bundles. Which options apply to which role can change between releases, so read `backstage-cli package build --help` for the version in the repository. Minified output is harder to read in an error message, so a team minifies only where size matters.

This part showed the output of each role and the manifest fields that connect a package to its output. The open question is how one command builds all of these in a repository and in which order a pipeline runs it.

## Common pitfalls

> [!WARNING]
> Do not commit `dist`. Do not publish a library whose `files` field does not list the build output: the package installs but cannot be imported. Do not put credentials in the app: its build output is public. Check which options a Backstage command supports with its `--help` for the installed version, because options differ between releases.

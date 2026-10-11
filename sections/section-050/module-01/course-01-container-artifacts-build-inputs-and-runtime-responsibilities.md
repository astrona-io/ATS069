---
draft: true
exam_objectives:
- Use Docker to build a container image of a Backstage project
---
# Container Artifacts, Build Inputs And Runtime Responsibilities

A container image is a packaged filesystem and runtime description. For Backstage it normally contains the backend application output, the dependencies needed at runtime and a supported Node.js base environment. Frontend assets can be packaged for serving through the app-backend plugin or through another explicitly designed deployment path. The image is an artifact; the running deployment still supplies configuration, identities and access to external services.

A common host-build approach compiles and bundles the application before the image packaging step. The Dockerfile then copies expected output into a runtime image. This can make build caching and existing continuous integration checks straightforward. It also creates a prerequisite: the build output must exist and correspond to the source revision being packaged. A stale bundle can produce a successful image containing an old application.

A multi-stage approach performs build work in an earlier image stage and copies selected artifacts into a final stage. This can keep compiler tools and development-only files out of the runtime filesystem. It does not automatically make the final image minimal or secure. The copy instructions, dependency selection and base-image contents determine what remains. A careless copy of the entire build directory can undo the intended separation.

The build context determines which files Docker can access. It should contain the inputs required by the Dockerfile and exclude irrelevant or sensitive files. An ignore file can prevent a local credential file, large dependency directory or unrelated repository data from entering the context. Exclusion has to remain compatible with the packaging approach: removing a required bundle causes a predictable failure rather than a smaller working image.

Imagine a pipeline that builds backend output from commit A and later packages a directory containing source from commit B. The image can have conflicting provenance even if every step reports success. A sound artifact chain connects the source revision, dependency resolution, generated output and image identifier. That connection makes review and rollback meaningful because the team knows what was actually shipped.

Runtime dependencies need attention when native modules are involved. A module compiled for one operating system or incompatible library environment may not load in the chosen runtime base image. Copying a developer's dependency directory is therefore not a general substitute for a controlled packaging process. Architecture and Node.js compatibility belong to the artifact contract.

The image should run with an appropriate non-root identity and receive only required filesystem access. Database endpoints, integration tokens and deployment-specific settings should arrive through the approved runtime configuration path. Baking production credentials into an image spreads them through registries, caches and every environment that can pull the artifact. Removing a credential in a later filesystem layer may not remove its earlier history.

A successful build proves that the declared packaging process completed. It does not prove that a production database is reachable, an ingress route reaches the right port or a plugin has sufficient external permissions. Startup readiness and functional integration are later observations. The diagnosis should therefore distinguish missing image files from missing runtime configuration and external authorization failures.

Reusing a tested image across environments reduces uncertainty compared with rebuilding separate artifacts for each environment. Configuration still needs validation in each environment, and browser-visible values need deliberate treatment. An immutable image reference identifies content more reliably than a moving tag, but content identity alone does not establish operational safety.

The command form `docker image build . -f packages/backend/Dockerfile --tag backstage` identifies a current-directory build context, a selected Dockerfile and a local image tag. It does not run the resulting application or publish the image to a registry. In a host-build arrangement, expected backend and frontend output must already exist before packaging. In a different project arrangement the Dockerfile can perform build stages itself. Interpreting the context, Dockerfile and prerequisites is therefore more useful than treating the command text as proof that an artifact was built.

## Common pitfalls

> [!WARNING]
> Do not package stale output or a developer's unexplained dependency directory. Keep secrets out of build contexts and image layers. A completed image build is packaging evidence; deployment readiness requires separate configuration, identity and connectivity evidence.

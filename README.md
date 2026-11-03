# Backstage Development Workflow (ATS069)

Certified Backstage Associate (CBA): Backstage Development Workflow, worth 24% of the official curriculum. This course belongs to ATP014.

Concept lessons explain each official objective through mechanisms and examples. Every module has a playground (a clean Ubuntu 24.04 virtual machine to explore), a graded lab and a summary. Every section ends with a capstone lab and a knowledge check. A final knowledge check closes the course.

## Course Outline

| Section | Objective | Modules | Tools used in the labs |
| --- | --- | --- | --- |
| 010 | Build and run Backstage projects locally | 1 + capstone | Yarn workspaces, app-config, Node.js |
| 020 | Understand local development workflows | 1 + capstone | tests, lint, local config overrides |
| 030 | Compile a Backstage project with TypeScript | 1 + capstone | tsc, tsconfig, project references |
| 040 | Download and install dependencies for a Backstage project with NPM/Yarn | 1 + capstone | Yarn, npm, lockfiles |
| 050 | Use Docker to build a container image of a Backstage project | 1 + capstone | Docker, Dockerfile, .dockerignore |

## Authoring Status

Readings are drafts for review. The playgrounds and labs run on Ubuntu 24.04 QEMU virtual machines and are built untested: only static checks were run (`astrona validate -c`, `bash -n`, YAML parsing). Every lab README says UNTESTED. The labs use small workspace fixtures, not a full Backstage app.

## Run A Lab

```sh
astrona run -c sections/section-010/module-01/labs/lab-01
astrona submit -c sections/section-010/module-01/labs/lab-01
astrona destroy ats-069-lab-010-01
```

## Author Review

See [curriculum coverage](CURRICULUM.md), [primary sources](SOURCES.md), [question-bank documentation](ASSESSMENTS.md) and [contribution instructions](CONTRIBUTING.md). No runtime execution is claimed: labs are untested.

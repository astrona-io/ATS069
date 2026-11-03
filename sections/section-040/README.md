---
draft: true
exam_objectives:
- Download and install dependencies for a Backstage project with NPM/Yarn
---
# Section 040: Download and install dependencies for a Backstage project with NPM/Yarn

This section teaches you how a Backstage project turns its package manifests into installed packages, and how a lockfile makes that result repeatable. You declare dependencies in the right workspace, install with `yarn install --immutable` and `npm ci`, force a release with `resolutions` and sort install failures by cause.

**Exam objective covered:** Download and install dependencies for a Backstage project with NPM/Yarn

---

## What You Will Master

- Explain what a manifest declares and what a lockfile records, and which tool writes each one.
- Read a version range and say which releases it allows.
- Declare a dependency in the workspace that imports it, and explain why a hoisted package is not a declaration.
- Install exactly what the lockfile says with `yarn install --immutable` or `npm ci`.
- Force one release of a transitive dependency with `resolutions`.
- Sort an install failure into Node.js version, registry, authentication, native build or integrity causes.

---

## The Learning Path

### 1. Package Managers, Lockfiles And Reproducible Dependencies
*   **Module Reader:** **[Module 1: Package Managers, Lockfiles And Reproducible Dependencies](./module-01/course.md)**
*   **Hands-on Playground:** `sections/section-040/module-01/playground` - an Ubuntu virtual machine with Node.js 22 and Yarn 4.4.1. `/opt/portal` is a simplified Yarn workspace (`app`, `backend`, `@internal/shared`) and `/opt/npm-demo` is a small npm project. The backend imports `semver` without declaring it.
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS069.git -c sections/section-040/module-01/playground
    ```
*   **Lab:** `sections/section-040/module-01/labs/lab-01` (UNTESTED)
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS069.git -c sections/section-040/module-01/labs/lab-01
    astrona submit -c .
    ```

### Section Capstone Challenge
*   **Comprehensive Challenge:** Reproducible Dependencies Capstone - `sections/section-040/capstone/labs/lab-01` (UNTESTED)
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS069.git -c sections/section-040/capstone/labs/lab-01
    astrona submit -c .
    ```
*   **Hands-on Objective:** Make the CI install step immutable, declare `semver` in the backend, force one `semver` release of 7.5.2 or later with `resolutions` and remove a stray `package-lock.json`. The grader checks the files and runs `yarn install --immutable`.

### Knowledge Check
*   **Quiz:** 10 questions in `sections/section-040/quiz.yaml`. The pass score is 70 percent.

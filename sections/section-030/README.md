---
draft: true
exam_objectives:
- Compile a Backstage project with TypeScript
---
# Section 030: Compile a Backstage project with TypeScript

This section teaches you what the TypeScript compiler checks and what it emits, how `tsconfig.json` sets the scope of a check, why a type does not protect against bad data at runtime, and how a workspace of packages builds in dependency order. You practise on a small workspace that has the shape of a Backstage repository.

**Exam objective covered:** Compile a Backstage project with TypeScript

---

## What You Will Master

- Distinguish parsing, type checking, emit and bundling, and say which tool does each one.
- Read a check result together with its scope, using `--listFilesOnly` and `--showConfig`.
- Handle an optional property in code instead of silencing the compiler with an assertion.
- Validate data at the edge of a program with a function that takes `unknown`.
- Declare project references, build in dependency order with `tsc --build` and explain declaration files.
- Explain why a clean build can fail where an incremental build passes.
- Extend a shared base `tsconfig.json`, explain what `strict` and `skipLibCheck` change and run the `tsc` and `tsc:full` check scripts.
- Read the `backstage.role` of a package, separate a transpile-only build from a type check and explain the build output of libraries, the app and the backend.

---

## The Learning Path

### 1. Type Checking, Transpilation And Workspace Build Contracts
*   **Module Reader:** **[Module 1: Type Checking, Transpilation And Workspace Build Contracts](./module-01/course.md)**
*   **Hands-on Playground:** `sections/section-030/module-01/playground` - an Ubuntu virtual machine with Node.js 22 and `tsc`. A small valid workspace in `/opt/portal` with three packages, a flat check configuration and a solution file with project references.
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS069.git -c sections/section-030/module-01/playground
    ```
*   **Lab:** `sections/section-030/module-01/labs/lab-01` (UNTESTED)
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS069.git -c sections/section-030/module-01/labs/lab-01
    astrona submit -c .
    ```

### 2. Shared tsconfig, Strictness And Type Check Scripts
*   **Module Reader:** **[Module 2: Shared tsconfig, Strictness And Type Check Scripts](./module-02/course.md)**
*   **Hands-on Playground:** `sections/section-030/module-02/playground` - an Ubuntu virtual machine with Node.js 22 and `tsc`. A workspace with a shared base configuration, the `tsc` and `tsc:full` scripts and a declaration file that only the full check rejects.
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS069.git -c sections/section-030/module-02/playground
    ```
*   **Lab:** `sections/section-030/module-02/labs/lab-01` (UNTESTED)
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS069.git -c sections/section-030/module-02/labs/lab-01
    astrona submit -c .
    ```

### 3. Backstage Build Pipelines And Package Roles
*   **Module Reader:** **[Module 3: Backstage Build Pipelines And Package Roles](./module-03/course.md)**
*   **Hands-on Playground:** `sections/section-030/module-03/playground` - an Ubuntu virtual machine with Node.js 22 and `tsc`. A four-package workspace with Backstage roles, a transpile-only build and a root type check.
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS069.git -c sections/section-030/module-03/playground
    ```
*   **Lab:** `sections/section-030/module-03/labs/lab-01` (UNTESTED)
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS069.git -c sections/section-030/module-03/labs/lab-01
    astrona submit -c .
    ```

### Section Capstone Challenge
*   **Comprehensive Challenge:** TypeScript Workspace Build Capstone - `sections/section-030/capstone/labs/lab-01` (UNTESTED)
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS069.git -c sections/section-030/capstone/labs/lab-01
    astrona submit -c .
    ```
*   **Hands-on Objective:** Repair a composite workspace so that it builds from a clean state in dependency order: declare the project references, correct a type error, replace a type assertion with a runtime parser, set the `build:all` script and emit declaration files for all three projects.

### Knowledge Check
*   **Quiz:** 28 questions in `sections/section-030/quiz.yaml`. The pass score is 70 percent.

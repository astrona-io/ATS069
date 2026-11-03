---
draft: true
exam_objectives:
- Understand local development workflows
---
# Section 020: Understand Local Development Workflows

This section teaches you to follow one change through a Backstage monorepo on your own machine. You will find the packages a change touches, get feedback from the type check, the tests, the linter and the development server, separate local overrides from shared configuration, and describe a change so that a reviewer can verify it.

**Exam objective covered:** Understand local development workflows

---

## What You Will Master

- Trace a source change through the workspace packages and the contracts it touches.
- Explain what the type check, the tests, the linter and hot reload each prove and do not prove.
- Explain how configuration files layer, and when `app-config.local.yaml` is loaded.
- Keep secrets out of committed configuration with `${NAME}` references.
- Describe a change with its behavior, its boundaries and its evidence.
- Create a plugin, run it alone from its `dev/` entry point and connect it to the app and the backend.
- Run tests, lint, formatting and the type check, combine them in one command and run it from a Git hook.

---

## The Learning Path

### 1. Changes, Workspace Feedback And Reviewable Development
*   **Module Reader:** **[Module 1: Changes, Workspace Feedback And Reviewable Development](./module-01/course.md)**
*   **Hands-on Playground:** `sections/section-020/module-01/playground` - an Ubuntu virtual machine with Node.js 22, Yarn and Git, and a working portal workspace in `/opt/portal`. All checks pass at the start.
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS069.git -c sections/section-020/module-01/playground
    ```
*   **Lab:** `sections/section-020/module-01/labs/lab-01` (UNTESTED)
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS069.git -c sections/section-020/module-01/labs/lab-01
    astrona submit -c .
    ```

### 2. Developing Plugins Locally
*   **Module Reader:** **[Module 2: Developing Plugins Locally](./module-02/course.md)**
*   **Hands-on Playground:** `sections/section-020/module-02/playground` - an Ubuntu virtual machine with Node.js 22, Yarn and Git, and a portal workspace in `/opt/portal` with a frontend plugin and a backend plugin.
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS069.git -c sections/section-020/module-02/playground
    ```
*   **Lab:** `sections/section-020/module-02/labs/lab-01` (UNTESTED)
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS069.git -c sections/section-020/module-02/labs/lab-01
    astrona submit -c .
    ```

### 3. Testing, Linting And Formatting Workflow
*   **Module Reader:** **[Module 3: Testing, Linting And Formatting Workflow](./module-03/course.md)**
*   **Hands-on Playground:** `sections/section-020/module-03/playground` - an Ubuntu virtual machine with Node.js 22, Yarn and Git, and a portal workspace in `/opt/portal` with a check script and a pre-commit hook.
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS069.git -c sections/section-020/module-03/playground
    ```
*   **Lab:** `sections/section-020/module-03/labs/lab-01` (UNTESTED)
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS069.git -c sections/section-020/module-03/labs/lab-01
    astrona submit -c .
    ```

### Section Capstone Challenge
*   **Comprehensive Challenge:** Local Development Workflow Capstone - `sections/section-020/capstone/labs/lab-01` (UNTESTED)
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS069.git -c sections/section-020/capstone/labs/lab-01
    astrona submit -c .
    ```
*   **Hands-on Objective:** Finish an unfinished deployment status change across `catalog-common`, `backend` and `app`: fix the type errors, the failing tests and the lint problems, move a shared key out of the local override, read the database password from the environment, ignore the local file and write a change description. The grader checks files and runs the checks.

### Knowledge Check
*   **Quiz:** 28 questions in `sections/section-020/quiz.yaml`. The pass score is 70 percent.

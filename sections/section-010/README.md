---
draft: true
exam_objectives:
- Build and run Backstage projects locally
---
# Section 010: Build and run Backstage projects locally

This section teaches how a Backstage project is put together, how it runs on a developer machine, and how it becomes artifacts that run without the source tree. You practise on an Ubuntu virtual machine that holds a small example workspace with the shape of a Backstage project.

**Exam objective covered:** Build and run Backstage projects locally

---

## Learning Outcomes

- Explain the responsibilities of the app and backend workspaces.
- Distinguish a development server from a production artifact.
- Locate startup failures by dependency, configuration and process boundaries.
- Start the backend, merge configuration files and keep server-only values out of the browser configuration.
- Build the workspace and run the built output without the source folder.

---

## The Learning Path

### 1. Local Projects, Development Servers And Production Builds
*   **Module Reader:** **[Module 1: Local Projects, Development Servers And Production Builds](./module-01/course.md)**
*   **Hands-on Playground:** `sections/section-010/module-01/playground` - Ubuntu 24.04 virtual machine with Node.js 22 and Yarn 4. The workspace `/opt/portal` is complete and nothing is running.
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS069.git -c sections/section-010/module-01/playground
    ```
*   **Lab:** `sections/section-010/module-01/labs/lab-01` (UNTESTED)
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS069.git -c sections/section-010/module-01/labs/lab-01
    astrona submit -c .
    ```

### Section Capstone Challenge
*   **Comprehensive Challenge:** Build And Run Backstage Projects Locally Capstone - `sections/section-010/capstone/labs/lab-01` (UNTESTED)
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS069.git -c sections/section-010/capstone/labs/lab-01
    astrona submit -c .
    ```
*   **Hands-on Objective:** Start the backend and the app from source, move a token out of the browser configuration, make `yarn build:all` build both workspaces and run both built artifacts alone. The grader runs the processes and reads the files.

### Knowledge Check
*   **Quiz:** 9 questions in `sections/section-010/quiz.yaml`. The pass score is 70 percent.

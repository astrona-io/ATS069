---
draft: true
exam_objectives:
- Use Docker to build a container image of a Backstage project
---
# Use Docker to build a container image of a Backstage project

This section teaches how to package a Backstage backend as a container image with Docker. It covers the files an image needs, host-build and multi-stage builds, the build context and run-time configuration.

Read the module goals, teaching and closing summary in order. Each module has a playground and a graded lab, and the section ends with a capstone lab and a knowledge check.

## Learning Outcomes

- Describe the files and dependencies a Backstage container needs.
- Explain host-build and multi-stage packaging tradeoffs.
- Distinguish a built image from a correctly configured deployment.
- Control the build context, predict Docker layer cache reuse and use BuildKit cache and secret mounts.
- Run the image with mounted configuration, environment variables, hardening options, a database and a health check.

## The Learning Path

### 1. Container Artifacts, Build Inputs And Runtime Responsibilities
*   **Module Reader:** **[Module 1](./module-01/course.md)**
*   **Hands-on Playground:** `sections/section-050/module-01/playground` - Ubuntu virtual machine with Node.js and Docker, and a portal workspace in `/opt/portal` with a host-build and a multi-stage Dockerfile.
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS069.git -c sections/section-050/module-01/playground
    ```
*   **Lab:** `sections/section-050/module-01/labs/lab-01` (UNTESTED)
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS069.git -c sections/section-050/module-01/labs/lab-01
    astrona submit -c .
    ```

### 2. Dockerfile Layers, Caching And Build Context
*   **Module Reader:** **[Module 2](./module-02/course.md)**
*   **Hands-on Playground:** `sections/section-050/module-02/playground` - Ubuntu virtual machine with Node.js and Docker, the portal workspace, a large `recordings` folder and two BuildKit demo Dockerfiles.
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS069.git -c sections/section-050/module-02/playground
    ```
*   **Lab:** `sections/section-050/module-02/labs/lab-01` (UNTESTED) - Shrink the build context, stop copying local files and keep the bundle unpack step cached.
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS069.git -c sections/section-050/module-02/labs/lab-01
    astrona submit -c .
    ```

### 3. Running And Securing The Image
*   **Module Reader:** **[Module 3](./module-03/course.md)**
*   **Hands-on Playground:** `sections/section-050/module-03/playground` - Ubuntu virtual machine with Docker and the built image `portal:run`, a runtime configuration file and an environment file.
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS069.git -c sections/section-050/module-03/playground
    ```
*   **Lab:** `sections/section-050/module-03/labs/lab-01` (UNTESTED) - Start the container with a mounted configuration file, a published port, a run-time token, hardening options and a health check.
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS069.git -c sections/section-050/module-03/labs/lab-01
    astrona submit -c .
    ```

### Section Capstone Challenge
*   **Comprehensive Challenge:** Multi-Stage Image And Runtime Configuration - `sections/section-050/capstone/labs/lab-01` (UNTESTED)
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS069.git -c sections/section-050/capstone/labs/lab-01
    astrona submit -c .
    ```
*   **Hands-on Objective:** Fix the `.dockerignore` file and the multi-stage Dockerfile, keep source and local configuration out of the final image, run as a non-root user, start a container that answers on port 7007 and pass a token at run time.

### Knowledge Check
*   **Quiz:** 30 questions in `sections/section-050/quiz.yaml`. The pass score is 70 percent.

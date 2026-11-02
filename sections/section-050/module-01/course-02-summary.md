---
draft: true
exam_objectives:
- Use Docker to build a container image of a Backstage project
---
# Summary

A Backstage image packages application output and runtime dependencies for a chosen Node.js environment. Host-build and multi-stage approaches differ in where compilation occurs, while both need reproducible declared inputs. Image contents, build context and runtime configuration are separate concerns. A successful image build does not establish database access, integration permissions or safe browser configuration in the deployed application.

---
name: Deployment Build
about: Follow these steps to prepare and publish a deployment build for QA and Production
title: "Deployment Build: version: "
labels: deployment_build
assignees: ''
---

Follow the steps below to prepare a deployment build of OnDemand Loop.

> This process creates and publishes build artifacts to environment branches. **Deployment itself is performed externally (e.g., by Puppet).**

1. **Prepare the issue**
    - Ensure the title starts with `Deployment Build: version: <tag>`.  
      Example:
      ```
      Deployment Build: version: v0.5.13+2025-07-01
      ```
    - Add at least one assignee to this issue.
    - Add the label `deployment_build`

2. **Create a QA deployment build**
    - Comment the following slash command on this issue:
      ```
      /deployment_build_candidate
      ```
    - This builds the specified version and pushes it to the `iqss_qa` branch.

3. **Test and approve**
    - [Test the deployment in the QA environment]([url](https://harvardwiki.atlassian.net/wiki/spaces/HMDC/pages/370870157/OnDemand+LOOP+at+FASRC#QA-Testing)).
    - When ready, approve the deployment by commenting:
      ```
      build approved
      ```

4. **Create a Production deployment build**
    - After approval, publish to production by commenting:
      ```
      /deployment_build_release type=<patch|minor|major>
      ```
    - Creates a GitHub release based on the `VERSION` file.
    - Pushes the same version to a new production branch (e.g., `iqss_production_<version>`).
    - For beta releases we have been doing minor releases.

5. **Mark release as deployed**
    - Once the production deployment is completed and verified (via external system like Puppet), mark the release as deployed by commenting:
      ```
      /deployment_build_deployed
      ```
    - This updates the release issue with:
        - A `production_deployed` label
        - A moving label `production` pointing to the issue that is currently deployed
        - A confirmation comment

6. **Finish up**
    - The workflow will comment with the result of the build publication and deployment marking, including a link to the workflow run.
    - Close this issue once the production deployment is complete and verified.

_Only authorized users in `.github/workflows/slash_command_listener.yml` can execute the slash commands above._

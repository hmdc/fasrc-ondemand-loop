# FASRC OnDemand Loop Deployment Builds

This repository contains the configuration and automation pipeline used to manage **deployment builds** for the [OnDemand Loop](https://github.com/IQSS/ondemand-loop) application, tailored for the **Cannon** and **FASSE** clusters at FASRC.

The Harvard Dataverse landing page to inform users of the access requirements to use OnDemand Loop is managed in this repo.  
**Production landing page:** https://hmdc.github.io/fasrc-ondemand-loop/dv_external_tools/landing.html  
**QA landing page:** https://hmdc.github.io/fasrc-ondemand-loop/qa/dv_external_tools/landing.html

## Overview

- 🚀 **Deployment Build Management**  
  Orchestrates creation of QA and production builds via GitHub Actions, driven by issue comments and labels.

- ⚙️ **FASRC-Specific Configuration**  
  Hosts and maintains the environment-specific configuration needed to deploy OnDemand Loop as a Passenger application within FASRC.

- 🧭 **Dataverse External Tools Landing Page**  
  Improves UX for Dataverse users without an FASRC account by explaining access requirements to OnDemand Loop.

- 🧩 **Separation of Concerns**  
  Application code lives in [`IQSS/ondemand-loop`](https://github.com/IQSS/ondemand-loop).  
  This repository builds and deploys that code into FASRC environments.

## Usage (Source of Truth)

To create QA or Production deployment builds, **use the _Deployment Build_ issue template** and follow the instructions at the top of the template.  
This keeps instructions centralized and avoids duplication or drift in the README.

- Open a **new issue** using the **Deployment Build** template (via *New issue → Deployment Build*).
- Follow the template’s embedded steps (slash commands, approvals, promotions, etc.).
- The workflows read the issue’s labels and hidden comments to coordinate builds and deployments.

➡️ **Template:** [Deployment Build issue template](.github/ISSUE_TEMPLATE/deployment_build.md)

> ℹ️ The issue template is the canonical reference for creating builds. If a process changes, update the template—no README edits required.

## Environment

This repository:

- Runs GitHub Actions to coordinate builds and deploy GitHub Pages.
- Prepares the application with FASRC-specific configs.
- Publishes artifacts to the appropriate locations.
- **Does not deploy servers directly**—deployment to FASRC hosts is handled externally (e.g., via Puppet).

## Project Structure

- `.github/workflows/` — Build and deployment automation workflows
- `.github/scripts/` — Shared utility scripts for workflow logic
- `config/` — FASRC-specific configuration
- `dv_external_tools/` — Static HTML landing page integrated with Harvard Dataverse

## Requirements

- Only authorized users may run deployment commands via issue comments.
- Production promotions require explicit approval, as described in the **Deployment Build** issue template.

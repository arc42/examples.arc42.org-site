---
title: Introduction and Goals
order: 1
---

The mission of NFDI4Earth is to address the digital needs of the Earth System
Sciences (ESS) for more FAIRness and [Openness](https://doi.org/10.5281/zenodo.10123879)
in ESS research and in particular in research data management (RDM) practices.

We develop several services and concepts within NFDI4Earth and reuse/integrate
existing services when suitable. By doing so, we enable researchers, data
experts, and software specialists to discover, access, analyse, and share
relevant Earth data and related publications or tools.

## Requirements Overview

NFDI4Earth supports the following use cases with common services:

1. Discover and explore Earth data sources
2. Support data publication and data curation
3. Solve a research data management problem
4. Create and publish information products, e.g., as services

The architecture of the NFDI4Earth describes the different services built to
make resources from the ESS findable, accessible, interoperable and reusable,
as well as the requirements for interfaces enabling their interaction.

In NFDI4Earth, we follow the service definition used in the joint statement of
NFDI consortia on basic services:

> A service in NFDI is understood as a technical-organisational solution, which
> typically includes storage and computing services, software, processes, and
> workflows, as well as the necessary personnel support for different service
> desks.

The service portfolio is described in
[section 4, Solution Strategy](../04-solution-strategy/).

## Quality Goals

In this section, we describe quality goals synonymously used as a term to
describe architecture goals with a long-term perspective. As the NFDI4Earth
Software Architecture is evolving, we envision to regularly evaluate the
prioritization of the quality goals. Following ISO 25010:2011 on software
product quality, we consider the following quality goals for the NFDI4Earth
Software Architecture:

| Quality goal | Meaning |
|---|---|
| **Functional suitability** | Degree to which the architecture provides functions that meet stated and implied needs when used under specified conditions. |
| **Maintainability** | Degree of effectiveness and efficiency with which the architecture can be modified to improve it, correct it or adapt it to changes in environment, and in requirements. |
| **Usability** | Degree to which a component of the architecture can be used by specified users to achieve specified goals with effectiveness, efficiency and satisfaction in a specified context of use. |

ISO 25010 — *Systems and software engineering — Systems and software Quality
Requirements and Evaluation (SQuaRE) — System and software quality models* —
includes the quality goals functional suitability, maintainability,
portability, compatibility, usability, and reliability. The three above are the
ones NFDI4Earth has committed to.

## Stakeholders

We consider the following roles for using the NFDI4Earth Software Architecture
Documentation:

| Role | Expectations |
|---|---|
| Internal developers of NFDI4Earth services | Find descriptions and specifications of NFDI4Earth-developed services and integrate the services within their own projects |
| External developers | Find specifications on how to use existing NFDI4Earth-developed services; find descriptions on how to add services to the NFDI4Earth infrastructure |

The envisioned target group of the documentation includes software developers
and architects as well as service providers.

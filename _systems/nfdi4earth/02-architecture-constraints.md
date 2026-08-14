---
title: Architecture Constraints
order: 2
---

The following requirements constrain the design and implementation decisions
and processes for the NFDI4Earth Software Architecture:

| No. | Constraint | Type | Explanation |
|---|---|---|---|
| 1 | NFDI4Earth Proposal | organisational, strategic and technical | The [proposal](https://doi.org/10.5281/zenodo.5718943) provides the context and aims of the NFDI4Earth software architecture. |
| 2 | NFDI integration and interoperability | technical, strategic | The NFDI4Earth software architecture must fit with relevant activities of the overall NFDI, e.g., with NFDI-wide basic service initiatives. |
| 3 | International integration and interoperability | technical, strategic | The NFDI4Earth software architecture will be embedded in international infrastructures. |
| 4 | Developer expertise, research interests, and availability | organisational, technical | The expertise, research interests, and availability of a distributed software developer team affect the software project management as well as the technology decisions. |
| 5 | Architecture team | organisational | Software decisions for NFDI4Earth services are made by the NFDI4Earth architecture team on suggestion and on agreement with the measure leads of the relevant service. |
| 6 | Developer team | organisational, conventions | NFDI4Earth cross-product implementations, guidance and conventions will be provided by the software developer team. |
| 7 | FAIR principles | technical | NFDI4Earth services should support the implementation of the FAIR principles. |
| 8 | Programming languages | technical | Services will be developed in an established programming language, e.g., JavaScript, Java, Python, C#, HTML, and follow the basic structures of a sustainable software project, e.g., testing, dependency management, documentation and internationalisation. |
| 9 | Free and Open Source Software | technical and strategic | NFDI4Earth services must be provided as Free and Open Source (FOSS) whenever possible. Used open-source solutions must be well established, documented and maintained, e.g., guaranteed by their long-term applicability. |
| 10 | Open standards / specifications | technical | NFDI4Earth services will reuse existing (preferably) or define open standards or specifications for all interfaces, when interfaces are relevant for the component. |
| 11 | Established software | technical | Chosen software products should represent established solutions, i.e., they should have been available for several years and be embedded in a software developer network or be used in at least one NFDI4Earth-comparable project. |
| 12 | Loosely coupled services | technical | NFDI4Earth services must be loosely coupled using well defined interfaces and separations of concern to allow replacing (partial) software solutions, e.g., due to agile adaptions to user needs, changing requirements, or newly developed NFDI-wide solutions. |
| 13 | Software repository | organisational | The source code of the NFDI4Earth services must be managed in a software repository that allows contributions from NFDI4Earth participants. |
| 14 | Hosting at TU Dresden | technical, organisational | The NFDI4Earth services are hosted at TU Dresden Enterprise cloud and maintained by following the respective [guidelines / regulations](https://nfdi4earth.pages.rwth-aachen.de/architecture/devguide/). |
| 15 | Containerization | technical | NFDI4Earth services run in virtual containers, whenever possible. |

Constraints 2 and 7–11 are also the criteria against which every individual
software decision is weighed — see
[section 9, Architecture Decisions](../09-architecture-decisions/).

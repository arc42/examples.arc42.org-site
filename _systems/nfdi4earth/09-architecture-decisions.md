---
title: Architecture Decisions
order: 9
---

## Decision Process

As described in the NFDI4Earth proposal, the Measure 4.3 *Central Support
Services for the federated NFDI4Earth Community* is responsible for the Support
and Coordination of Software Developments (Action 5). One major goal of this
action is to ensure a coherent software development within and for NFDI4Earth.

Software decisions concern the use and purpose of software solutions (what and
how) that are parts of the emerging NFDI4Earth software components and whose
use affects the NFDI4Earth community directly or prospectively. The software
decisions are made by the **NFDI4Earth Architecture Team** on the proposal of
and in consultation with the measure leads responsible in each case. This
ensures that the chosen tools and systems fit into the overall software
ecosystem and the NFDI4Earth software architecture concept.

The software solutions selected for NFDI4Earth software products should meet
essential functional and non-functional requirements of the respective software
component or be the best available basis for further development. Moreover, it
should meet the software constraints 2 and 7–11 (see
[section 2, Architecture Constraints](../02-architecture-constraints/)).

Software solutions chosen for an NFDI4Earth software component can be changed
at any time — again in consultation with the NFDI4Earth Architecture Team — if
there are appropriate reasons for doing so (e.g., better solutions on the
market or changes in requirements). Decisions on software solutions are made by
the NFDI4Earth Architecture Team within **14 days**. The request for a software
decision to the NFDI4Earth Architecture Team is usually made by a measure lead.

In the case of unresolvable conflicts or diverging ideas on software decisions
between the measure leads and the NFDI4Earth Architecture Team, the NFDI4Earth
Architecture Team prepares a decision proposal for the steering group, which
then acts as the decision-making authority.

Software decisions are documented by the initiating measure leads including the
time of the decision, the NFDI4Earth related software products and a short
explanation taking into account the above-mentioned criteria for software
selection and the made decision. This documentation is edited by the NFDI4Earth
Architecture Team and published in the form of a management version in the
software architecture project of the NFDI4Earth GitLab.

> The NFDI4Earth Architecture Team consists of Auriol Degbelo, Christin Henzen,
> Carsten Keßler, Ralf Klammer, Daniel Nüst and Claus Weiland and can be
> contacted via
> [nfdi4earth-architecture@tu-dresden.de](mailto:nfdi4earth-architecture@tu-dresden.de).
> See the
> [software architecture team page](https://nfdi4earth.de/2coordinate/software-architecture-team).

## Decisions

The following decisions have already been taken:

| # | Decision | For |
|---|---|---|
| 1 | [Fuseki](https://jena.apache.org/documentation/fuseki2/) as the triple store <sup>[1](#fn1)</sup> | Knowledge Hub |
| 2 | [CORDRA](https://www.cordra.org) as middleware for metadata and data management | Knowledge Hub |
| 3 | [MkDocs](https://www.mkdocs.org) as a static site generator | Living Handbook |
| 4 | [Znuny](https://www.znuny.org) as ticketing system | User Support Network |
| 5 | [Open edX](https://openedx.org) as learn management system | EduTrain |
| 6 | A custom solution based on [React](https://react.dev) | OneStop4All |

<span id="fn1"></span>1. The original adds, as a footnote to this decision: *"We
expect this decision to change as Fuseki might not be able to scale as the
number of managed triples grows rapidly."* See
[section 11, Risks and Technical Debt](../11-risks-and-technical-debt/).

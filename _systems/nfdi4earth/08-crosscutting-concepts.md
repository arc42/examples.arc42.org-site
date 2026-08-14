---
title: Cross-cutting Concepts
order: 8
---

Not written yet, but scoped. The PDF omits the section; the
[online architecture documentation](https://nfdi4earth.pages.rwth-aachen.de/architecture/architecture-docs/#cross-cutting-concepts)
holds the place and names what will go in it:

> This section will be updated at a later stage including
>
> - Developer's guide
> - Certificate strategy
> - CI/CD implementation
> - Identity management

Two of those four are already partly covered elsewhere: the certificate
strategy (Sectigo, ACME, Certbot, renewal 30 days before expiry) is written up
in [section 7](../07-deployment-view/), and identity management appears in
[section 4](../04-solution-strategy/) as the IAM4NFDI integration using the
NFDI-AAI AcademicID solution.

The concepts that already cut across every service, stated elsewhere in the
document:

- **FAIR principles and Openness** — the mission in
  [section 1](../01-introduction-and-goals/) and constraint 7 in
  [section 2](../02-architecture-constraints/).
- **Metadata as RDF, served over a SPARQL API**, with the
  [NFDI4Earth Ontology](https://nfdi4earth.de/ontology) as the shared schema —
  [section 5](../05-building-block-view/).
- **Loose coupling over well-defined interfaces**, so that any single service
  can be replaced — constraint 12.
- **Free and Open Source Software and open standards** for every component —
  constraints 9 and 10.
- **One service per VM, everything in Docker, deployed by Ansible** — the
  operational conventions in [section 7](../07-deployment-view/).

Each service additionally lists the concept paper or deliverable it was
designed against, in the table at the end of
[section 4](../04-solution-strategy/).

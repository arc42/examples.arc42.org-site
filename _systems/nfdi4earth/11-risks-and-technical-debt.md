---
title: Risks and Technical Debt
order: 11
---

The register is empty, but the method is agreed. The
[online architecture documentation](https://nfdi4earth.pages.rwth-aachen.de/architecture/architecture-docs/#risks-and-technical-debts)
carries the section as a prepared table with no rows yet:

> Risks and technical debts to be added here as they come up. The systematic
> detection and evaluation of risks and technical debts in the architecture
> will serve management stakeholders in the overall risk analysis and planning.

| Name | Priority (high, medium, low) | Measures to minimize, mitigate, avoid, or reduce |
|---|---|---|
| … | … | … |

with the priorities defined as: **high** risks or debts are critical and can
break the whole project; **medium** risks or debts can cause serious extra
efforts but can be fixed even if one must go outside of the given resources;
and **low** risks or debts are uncertainties that can be handled within the
normal project resources.

Two risks are named elsewhere in the documentation, and both are worth pulling
out here.

**The triple store is expected to be outgrown.** The decision for Fuseki as the
Knowledge Hub's triple store
([section 9](../09-architecture-decisions/), decision 1) carries a footnote in
the original: *"We expect this decision to change as Fuseki might not be able
to scale as the number of managed triples grows rapidly."* The decision was
taken anyway — a documented, deliberate piece of technical debt with a named
trigger.

**Most of the portfolio is operated by other people.**
[Section 3](../03-context-and-scope/) puts the availability, functional
correctness, completeness and up-to-dateness of every harvested and integrated
service explicitly out of scope, and states that NFDI4Earth will not host and
maintain external project-based ESS services after their funding ends. For an
architecture whose strategy is to link rather than rebuild, that is the
standing risk, and the document names it rather than assuming it away.

A third is stated as a drawback rather than a risk: Ansible's SSH-based,
agentless model gets slower as the number of managed machines grows, and large
infrastructures need careful organisation of playbooks, roles and inventories
to stay manageable — see [section 7](../07-deployment-view/).

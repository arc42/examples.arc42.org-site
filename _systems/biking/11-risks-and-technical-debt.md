---
title: Risks and Technical Debt
order: 11
---

_biking2_ has been up and running for nearly 2 years now; the architecture contains no known risk for its usage scenario.

There is a possibility that the H2 database can be damaged due to an unexpected shutdown of the VM (that is, an OS or hardware failure). The risk is mitigated through regular backups of the serialized database file.

---
title: Risks and Technical Debt
order: 11
---

* The `Receiver` component suffers from overly complicated source code,
created by a number of developers without consent. Since early days, most production bugs resulted from this part of MaMa-CRM.

* The runtime flexibility of import/export configurations and campaign processes might lead to incorrect and _undetected_ behavior at runtime, as there are no configuration checks. Mischievous administrators can misconfigure any MaMa-CRM instance at any time.

* Configuration settings are not archived and therefore might get lost (so there might
be no fallback to the last working configuration in case of trouble).   

* The 'Common-Metadata-Store' is an overly trivial and resource-wasting synchronization
mechanism and should be replaced with a decent async / event-based system asap.

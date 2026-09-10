---
title: Architecture Decisions
order: 9
---

## Why are there many repositories and extensions instead of one central UMTHES repository?

iQvoc started as an extensible product that can be configured to the requirements of different customers. Because not all extensions were relevant for every customer, they were not meant to be part of the core application. To be able to use the base parts across all customers, they are published as OSS, which is also used by other developers and companies with no connection to INNOQ. INNOQ currently works on iQvoc only for SNS, so this strategy has since become obsolete and the code could in principle simply be merged into the respective application repositories. However, this could mean that code would have to be changed twice for the individual SNS applications.

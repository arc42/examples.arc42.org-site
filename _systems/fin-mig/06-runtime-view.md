---
title: Runtime View
order: 6
---

## 6.1 Course of the Migration

In the first phase, the individual readers inside the VSAM Reader read all the
delivered files ("tapes") and fill the migration database.

![Runtime view, first phase: reading the tapes into the migration database](../images/06-runtime-load-phase.png)

After that, the Segmentizer divides the data into segments that can be processed
in parallel.

The Rule Processor has a Packager — encapsulated in the figure by the `getPackage`
call — select from the migration database all the data needed to migrate one
person or one account, and then executes the business rules on that data package.

The Target System Adapter writes the migrated data into the new database.

![Runtime view, second and third phase: segmenting, then migrating in parallel](../images/06-runtime-migrate-phase.png)

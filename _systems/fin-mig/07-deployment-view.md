---
title: Deployment View
order: 7
---

![Deployment view: migration on two separate servers](../images/07-deployment-view.png)

The entire migration takes place on a dedicated Linux server (`migration-2`), on
which several parallel instances of the actual migration components (Packager and
Rule Processor) run inside an EJB container.

A fast bus connects this server to the database server (`migration-1`), on which
the VSAM Reader and the Segmentizer perform the initial filling of the migration
database.

Surprising, but decided this way by the client: the tape drives holding the VSAM
files produced by the existing mainframe are attached to server `migration-2`.

*Note:* in a real architecture documentation you should describe further
performance data of the hardware here (machines, networks, bus systems and so on).

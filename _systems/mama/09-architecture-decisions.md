---
title: Architecture Decisions
order: 9
---

No Commercial CRM Tool

: Do not use any of the commercial CRM tools as foundation for MaMa.
The main reason was the incredible amount of flexibility required to quickly
setup campaigns. This decision proved to be correct, as several early competitors
(which operated upon slightly customized standard CRM tools) failed to enter
the market MaMa operated in.

JBoss Drools for Rule Processing

: Use JBoss Drools as rule processing engine. We evaluated Python (Jython) as
an alternative, but that proved to be incredibly slow for our kind of processing.

No ETL Tool for Data import

: Do not use an ETL tool for importing data. The contractor, InDAC, refused
to consider the license fee of commercial ETL tools - therefore the development
team had no chance to even evaluate those as data import solutions.

---
title: Architecture Decisions
order: 9
---

The original documentation records these decisions in a table with a *decided by*
column but no dates. "PM" stands for the project manager.[^pl]

[^pl]: In the German original this column reads *PL* (Projektleiter). The other values are *Architekt, Entwickler* (architect, developers), *Auftraggeber* (client) and *PL, Kunde* (project manager, customer).

Describe the migration logic in Java, NOT in a simplified natural language
*(decided by: PM)*

: After several attempts, among them purpose-built rule languages written with
Lex and Yacc, the development team judged that expressing business rules in such
a rule language would not have been significantly simpler than programming them
in Java.

No commercial rule interpreter
*(decided by: PM)*

: After a few attempts with commercial rule engines, the project team decided
against using such a component. See the decision on the rule language above.
*Note: from today's point of view (that is, posthumously…) I would reconsider
this decision, and would in particular check open-source rule frameworks such as
JBoss Drools for their suitability.*

Pipes-and-filters architecture
*(decided by: architect, developers)*

: This simplifies parallelizing the actual migration rules in the Rule Processor.
No GUI of any kind is needed.

Dual server
*(decided by: the client)*

: Because of the high performance requirements, the database and the migration
logic run on two separate server machines. The machine later used by the new
account system serves as the database server.

Process the business rules in the Rule Processor (see sections 5.1.6 and 5.2.2)
in several parallel processes inside the J2EE application server
*(decided by: PM, customer)*

: A requirement from the customer. Processing all the existing persons purely
sequentially would not have been possible within the available runtime of 24
hours.

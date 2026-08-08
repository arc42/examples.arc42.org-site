---
title: Building Block View
order: 5
---

Starting from a set of VSAM files (delivered as tapes), the M&M application
converts ("migrates") every record into the new object model.

## 5.1 M&M Building Block View, Level 1

### Fundamental Structural Decision: Pipes and Filters

To solve the M&M migration problem we apply a modified **pipes-and-filters**
architecture pattern, described in detail in *Pattern-Oriented Software
Architecture* by Buschmann et al. \[Buschmann+96\].

A key criterion for choosing this architecture was the ability to parallelize
parts of these building blocks should the need arise (a need for performance).

Contrary to the classical pipes-and-filters pattern, the input building block
(VSAM Reader) processes its input data **completely** before the next filter is
called.

![Whitebox view of the migration system, level 1](../images/05-building-block-level-1.png)

The following sections describe the building blocks shown in the figure:

* Migration Controller
* VSAM Reader
* Segmentizer
* Migration database
* Packager
* Rule Processor
* Target System Adapter

### 5.1.1 Migration Controller

The Migration Controller coordinates the course of the migration. It is a single
Java class with thorough exception and error handling, plus an interface for
reporting and analysis (not shown in the diagram).

### 5.1.2 VSAM Reader

*Purpose / responsibility:* converts records from VSAM format (EBCDIC encoding)
into an ASCII or Unicode format that can be processed directly under Unix. At the
same time it resolves the constituents of the VSAM data into individually
identifiable data elements — in the EBCDIC representation, individual bits or
groups of bits sometimes carry a special meaning. The VSAM Reader performs no
business checks whatsoever, only format conversions.

*Interface(s):* input of VSAM files. For each kind of file (persons, account
data, address data, bank data) there is a separate reader component that knows
the record layout of its own input files.

*Variability:* none, because the system as a whole is meant to run only once.

*Performance characteristics:* not applicable.

*Location / file:* not applicable.

*Other administrative information:* none.

*Open issues:* for later use at other companies the individual converters could
be made "pluggable". That is not currently planned.

### 5.1.3 Segmentizer

*Purpose / responsibility:* prepares the parallelization of the Rule Processor.
It assigns the individual records from the different data sources (person data,
account data, bank data, address data) to coherent groups of data, called
**segments**. Elements of one segment can be processed independently of the
contents of any other segment. The input data has to be split across at least
3–5 different segments.

*Interface(s):*

* *Input:* the data fields of the input data, as converted by the VSAM Reader.
* *Output:* the migration database.

*Variability:* none.

*Performance characteristics:* the point is to divide the data into segments as
*quickly* as possible, not to optimize or balance the segments. The main emphasis
is therefore on performance.

*Location / file:* not applicable in this example.

*Other administrative information:* none.

*Open issues:* the segmentation criteria are currently not configurable; they are
coded out.

### 5.1.4 Migration Database

Buffers the converted and segmented migration data. In the sense of the
pipes-and-filters pattern it acts as the **pipe**, i.e. it contains no logic of
its own. The migration database is a set of tables in a relational database
(person, account, bank, address, plus a few key tables).

### 5.1.5 Packager

See the Rule Processor in the following section.

### 5.1.6 Rule Processor (and Packager)

*Purpose / responsibility:* produces an object graph with the respective person
(natural or non-natural person) as the root node, and all associated business
objects as its branches (addresses, bank accounts, accounts, postings).

The Rule Processor thereby performs the actual business migration step, from the
old (data-kind-oriented) representation into the new (person-oriented) one. This
may require several iterations over the rule base.

Examples — these are part of the requirements specification and are repeated here
to illustrate what the approach has to cope with:

* When migrating a married woman, the spouse must be migrated beforehand, as must
  any former spouses (divorced, disappeared or deceased).
* When migrating minors, the natural parents, legal guardians and foster parents
  must be migrated beforehand.
* When migrating companies, all predecessor companies from which the current firm
  emerged must be migrated beforehand. The same applies analogously to clubs and
  associations.

So that data or groups of data that belong together in business terms can be
migrated by processes running in parallel, a pre-processing step has to assemble
all related data into a "package". This is the job of the **Packager**.

### 5.1.7 Target System Adapter

*Purpose / responsibility:* transfers the object graph produced by the Rule
Processor into the object model of the (new) target system. Minor modifications
may be needed for this; depending on the runtime environment finally decided
upon, it may amount to no more than the concluding persistence step.

After a successful transfer into the new system, the Target System Adapter
returns a message. In the error case the entire object graph is written to the
error database together with the error messages from the target system.

### 5.1.8 Migrated Account Data in the Target Database

The migrated account data resides in a relational database, in a structure that
will only be settled in the course of development and that is defined
exclusively by the parallel project "New Account System".

It is filled by the Target System Adapter.

## 5.2 Building Block View, Level 2

This section refines the blackbox building blocks of level 1 described in the
previous section. Because this documentation is an example, only a few building
blocks are shown in detail.

*Note:* even in a real documentation you may concentrate on the components that
matter most. Do, however, give a reason for every component you decide not to
present in detail.

### 5.2.1 VSAM Reader Whitebox

![Internal structure of the VSAM Reader](../images/05-vsam-reader-whitebox.png)

Separating this building block into an EBCDIC-to-ASCII converter and the
individual specific reader building blocks would have been conceptually cleaner.
The development team saw that as over-structuring and rejected it for pragmatic
reasons.

The relationships between the reader building blocks and the EBCDIC2ASCII
converter component are pure *uses* relationships. The individual readers write
their results into the migration database.

#### 5.2.1.1 Person, Account, Address and Bank Data Readers

The reader components each read one particular kind of data from "their" input
tape. They convert everything it contains into separate attributes.

The individual readers encapsulate the syntax of the "old" VSAM representation
and the technical details of the data encoding.

#### 5.2.1.2 EBCDIC2ASCII Converter

*Purpose / responsibility:* converts a character string from EBCDIC to ASCII. The
only building block in the system implemented in ANSI C.

*Interface(s):* not applicable.

* *Input:* character string, maximum length 256 characters.
* *Output:* character string, maximum length 256 characters.

*Open issues:* extension to longer character strings. Not required for M&M, so
dropped.

An overview of EBCDIC encoding, plus further links, is on
[Wikipedia](https://en.wikipedia.org/wiki/EBCDIC).

### 5.2.2 Rule Processor Whitebox

The Rule Processor performs the actual business migration of records. It combines
the different categories of input data (persons, accounts and postings,
addresses, bank accounts) with one another and handles all the business special
cases. In particular, the Rule Processor takes care of the required
reorganization of the data, so that in future persons rather than accounts serve
as the entry points for navigation.

#### Structurally Relevant Design Decisions

**No commercial rule interpreter.** After a few attempts with commercial rule
engines, the project team decided against using such a component. The deciding
reason in the end was that expressing the business rules in a rule language would
not have been significantly simpler than programming them in Java.

> *Note:* from today's point of view (that is, posthumously…) I would reconsider
> this decision, and would in particular check open-source rule
> frameworks[^drools] for their suitability.

[^drools]: JBoss Drools, for example — today [drools.org](https://www.drools.org/); the original cites the then-current `labs.jboss.com/drools`.

**No explicit rule language.** The approach of having the domain experts
formulate the rules and merely executing them through an interpreter foundered on
the complexity of the overall data landscape. Efficient, performant navigation
within the object space needed at any given moment could not be achieved with a
rule language. See the note on the rule interpreter above.

![Internal structure of the Rule Processor](../images/05-rule-processor-whitebox.png)

*Note:* because this documentation is an example, only the UseCase Dispatcher and
the Person Mapper are sketched below. In a real documentation you should detail
all building blocks as far as necessary.

#### 5.2.2.1 UseCase Dispatcher

*Purpose / responsibility:* the UseCase Dispatcher decides, on the basis of the
data constellation, which of the business mapper components has to be addressed.
This decision is not trivial and cannot be made by the mappers themselves. In
some cases further records have to be read alongside the current data before the
decision can finally be made.

*Examples:*

* Single-member companies, as non-natural persons, can in some cases be mapped by
  the Person Mapper — depending on the date the company was founded and on the
  course of its corporate history. It must always have been a single-member
  company and must not have emerged from a multi-member company.
* Natural persons who were co-owners of multi-member companies in the past, and
  who are still active as entrepreneurs today, have to be carried both as a
  natural and as a non-natural person, depending on the legal form of the former
  company. The account and posting information has to be split accordingly.

#### 5.2.2.2 Person Mapper

*Purpose / responsibility:* creates a natural person in the new object model from
the input data and fills in the address data, bank data, account data and posting
data accordingly. If the person is married, the corresponding spouse — and
possibly spouses from earlier marriages — is migrated to match.

The Person Mapper uses the other mappers.

> *Further architecture building blocks are not documented in this example.*

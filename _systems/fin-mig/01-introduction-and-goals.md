---
title: Introduction and Goals
order: 1
---

## Purpose of the System

This document describes the software architecture of **M&M**[^mm], a system for
migrating roughly 20 million person and account records belonging to *Fies und
Teuer AG*, a financial-services organization.[^name]

[^mm]: M&M stands for **M**igration von **M**assendaten — migration of mass data.

[^name]: As you can easily guess, I deliberately changed the name of this organization. In German, *fies und teuer* means roughly *nasty and expensive*.

The client behind M&M has been running a number of mainframe applications
(COBOL, VSAM) since about 1970 to maintain person, account and bank data. Those
systems are currently being replaced by a homogeneous Java application, built by
a separate project running in parallel with M&M.

Fies und Teuer AG has around 20 million customers in Germany and maintains more
than 50 million accounts for them. Customers can be natural persons or legal
entities, in some cases also other kinds of organizations (federations, clubs
and associations).

Besides pure posting information, accounts also hold statistical and other
finance-related information about the customers, about persons associated with
them (a spouse, for example) or about organizations associated with them (a
company they run, for example).

The meaning of this account and posting information, and of the attributes it
contains, has changed considerably over the operational lifetime of the existing
application. To move to the new, consolidated object model, a team of about 20
domain experts drew up a body of several hundred business rules that the
migration has to follow.

All existing data has to be migrated out of its present format (VSAM files,
EBCDIC encoding) into that Java object model. Performing this migration is the
job of the system described here.

![Purpose of the system: migrating existing data](../images/01-purpose-of-the-system.png)

## Starting Situation of the Existing Data

Previously the data was organized around **accounts**.

For any operation, clerks first had to identify the accounts concerned; only
then could business operations (postings, enquiries) be carried out for the
persons involved.

As Fies und Teuer AG becomes more customer-oriented, the data is in future to be
organized around **persons**.

The source data arrives as a set of files on tape whose entries have to be
matched up with one another according to business criteria.

Key and code systems that used to apply have to be carried over into new keys.
Example: the old tariff class "T13" becomes the new tariff class "annual payment
without early-payment discount".

## Intended Audience

* All stakeholders of M&M named in [section 1.3](#13-stakeholders) of this
  documentation.[^audience]
* Software developers, architects and technical project managers looking for
  examples of an architecture documentation based on the arc42 template.
* People working in IT projects who want to make their life in software
  architecture easier by falling back on a proven documentation template.
* Those who still believe that templates are the devil's work and that
  architectures belong on the back of a used envelope. They can read here how it
  can be done differently.

[^audience]: The original German text refers to "the stakeholders of MaMa" at this point. That is a copy-and-paste artefact from a different example in the same book; the system meant here is M&M.

## 1.1 Requirements Overview

The most important functional requirements:

* Existing customer, account and address data is to be migrated out of the
  present VSAM[^vsam]-based mainframe[^mainframe] programs, from EBCDIC format
  into the object model of a Java application currently under development
  (Unicode/ASCII).
* The source data arrives as a set of files, or "tapes", whose entries have to be
  matched up with one another according to business criteria.
* The data used to be organized by accounts; in the new system, persons are the
  point of reference.
* Parts of the former key and code systems are to be carried over into new keys.

[^vsam]: VSAM = Virtual Storage Access Method, an access method for files used by IBM mainframes. A VSAM file consists of a metadata catalogue plus at least one physical file. There is more on VSAM in the references at the end of this documentation. Incidentally, there is a German saying about it: *"VSAM ist grausam"* — VSAM is gruesome.

[^mainframe]: A current introduction to OS/390 can be found at `www.informatik.uni-leipzig.de/cs/esvorles/` (the URL given in the original; the lecture pages have since moved).

## 1.2 Quality Goals

The primary quality goals of M&M are:

| Priority | Quality goal | Scenario |
|---|---|---|
| 1 | **Efficiency (performance)** | Migrate roughly 20 million person and account records within at most 24 hours. |
| 2 | **Correctness** | The migration has to be audit-proof and legally sound. This calls for suitable measures to prevent and to detect errors. |

### Non-Goals

What M&M is explicitly *not* meant to achieve:

* Modifiability or flexibility of the business transformation rules — the
  migration happens exactly once.
* There are no special security requirements. M&M runs in production only a
  single time, and it does so inside a secured data centre.

## 1.3 Stakeholders

| Role | Description, goal and intention |
|---|---|
| Management of Fies und Teuer AG | Wants a smooth and error-free migration. |
| The 20 million customers of Fies und Teuer AG | Care that their finance-related information is migrated correctly. These stakeholders never appear in the course of the project at all; they are involved only indirectly. |
| Formal audit / accounting review | Watches over the legal and bookkeeping correctness of the migration. |
| The tabloid press | Keeps a particularly close eye on Fies und Teuer AG. Any misconduct by the company is published without mercy. :-) |

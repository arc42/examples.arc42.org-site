---
title: Glossary
order: 12
---

The original states that the glossary is omitted in this example. The terms below
are collected from the rest of the documentation, because several of them are
mainframe vocabulary that a reader coming from the Java or web world will not
know.

| Term | Definition |
|---|---|
| EBCDIC | Extended Binary Coded Decimal Interchange Code. The 8-bit character encoding used on IBM mainframes; not compatible with ASCII. |
| Error record | A record that could not be migrated. Every one of them is written to the error database and later migrated by hand. |
| FT record type | A record layout defined by Fies und Teuer AG, identified by a number (27 = persons, 33 = addresses, 43 = accounts and postings). |
| KOUSYNE | The parallel project that builds the new Java account system and defines the target object model. |
| LTO-1 | Linear Tape-Open, generation 1. The tape format the source data is delivered on, holding up to 100 GB per tape here. |
| M&M | *Migration von Massendaten* — migration of mass data. The system documented here. |
| Package | All the data needed to migrate one person or one account, assembled by the Packager so that it can be processed independently of every other package. |
| Posting | An entry recording a movement on an account. The account tape holds the postings, despite its name. |
| Segment | A group of records that can be processed independently of the contents of any other segment. Segments are what make the Rule Processor parallelizable. |
| VSAM | Virtual Storage Access Method. An access method for files used by IBM mainframes. A VSAM file consists of a metadata catalogue plus at least one physical file. |

## References

* \[Buschmann+96\] Buschmann, Meunier, Rohnert, Sommerlad, Stal:
  *Pattern-Oriented Software Architecture — A System of Patterns.* Wiley, 1996.
  The source of the pipes-and-filters pattern used in
  [section 5](../05-building-block-view/).
* More on VSAM in the freely available IBM Redbook:
  [VSAM Demystified](https://www.redbooks.ibm.com/abstracts/sg246105.html).
* [EBCDIC on Wikipedia](https://en.wikipedia.org/wiki/EBCDIC).

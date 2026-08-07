---
title: Solution Strategy
order: 4
---

Here you just find the shorthand form of the architectural approaches to
the most important (quality) requirements, plus the links to the detailed
description in section 8 (crosscutting concepts).

|Goal/Requirement    |Architectural Approach |Details|
|--|---|-|
|[Flexible Data Structure](../01-introduction-and-goals/) |Database structure + persistence code is completely (100%) generated from UML-model |[Section 8.1](../08-crosscutting-concepts/) |
| | | |
|[Flexibility in Transmission Formats (CSV and fix-record-formats)](../01-introduction-and-goals/)|Create domain-specific languages for CSV and fix-format import/export configurations. Build an ANTLR based parser for these languages plus the corresponding interpreters. |[Section 8.2](../08-crosscutting-concepts/) |
| | | |
|Flexibility (Configurable CSV/fix formats) |Implement customized editor for CSV/fix DSL as Eclipse plugin |[Section 8.2](../08-crosscutting-concepts/)  |
| | | |
|[Performance](../01-introduction-and-goals/) (import/process 250k images/24hrs) |Treat images as special case, store images in filesystem instead of database, create unique path/filename based upon cient-ID, include load-testing in automatic build, create test-data generator |Include special case for image persistence in [code generator, Section 8.1](../08-crosscutting-concepts/) |
| | | |

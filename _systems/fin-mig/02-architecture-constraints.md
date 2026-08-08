---
title: Architecture Constraints
order: 2
---

## 2.1 Technical Constraints

| Constraint | Explanation |
|---|---|
| Hardware infrastructure | IBM mainframe as the platform of the legacy system, a Sun Solaris cluster for the target system. |
| Software infrastructure | Sun Solaris as the operating system of the target environment · Oracle as the new database · a J2EE-compatible application server as a possible runtime environment |
| Source data in EBCDIC | Source data arrives EBCDIC-encoded on four separate tapes. Fies und Teuer AG cannot pre-sort it. |
| System operation | Batch |
| Graphical user interface | None. Operation can be done from the console. |
| Libraries, frameworks and components | Free choice |
| Programming languages | Java, because of the existing know-how in the development team. |
| Reference architectures | None available |
| Analysis and design methods | Object-oriented approach |
| Data structures | The object model of the target environment is known (it is part of another project). |
| Programming interfaces | Data is delivered by the (existing) host system. |
| Coding guidelines | None |
| Technical communication | With the host via ftp or sftp |

## 2.2 Organizational Constraints

* Fies und Teuer AG is known to be a legally meticulous client. Its management
  understands nothing whatsoever about IT (and, rumour has it, nothing about
  money either — but that is another story).
* The tangled ownership structure of Fies und Teuer AG suggests that decision
  paths will be complicated.
* Fies und Teuer AG has signed long-term supply contracts with various IT service
  providers, which methodically prevent any free, market-driven selection of the
  external staff that might be needed.
* A highly effective external quality assurance function demands extensive
  documentation — and even checks it for factual correctness, which is rather
  unusual in the IT industry, but that too is another story.

## 2.3 Conventions

CM Synergy for version control, and compliance with the Sun Java coding
guidelines.

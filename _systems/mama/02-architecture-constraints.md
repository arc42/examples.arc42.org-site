---
title: Architecture Constraints
order: 2
---

## General Constraints

Setup Campaign without programming

: To setup a campaign, no _programming_ shall be necessary. _Configuration_ in various forms  is allowed. 

Implementation based upon Java 

: MaMa-CRM shall work on a recent Java runtime (>1.6)

Use Oracle(tm) as database

: InDAC holding company has negotiated a favorable deal with Oracle Inc. considering license and maintenance fee, therefore Oracle-DB has to be used for data storage.

## Software Infrastructure Constraints

* Linux operating system (preferably RedHat Enterprise Linux, as there exist _hardened_ editions certified by several security organizations.
* Open source frameworks with liberal licenses are possible (esp.: GNU and FSF licenses not allowed)
* Code generation / MDSD preferred for development
* Use of (UML) modeling tool recommended
* InDAC prefers iterative development processes but does not impose them.
* Sound technical documentation: InDAC emphasizes long-lasting, robust and cost-effective software systems and therefore strongly requires maintainable, understandable and expressive technical documentation (part of which you are currently reading).

## Operational constraints

* Every MaMa-CRM instance shall be operable in its own virtual machine
* MaMa shall run in batch/background mode to minimize operation overhead
* Complete configuration shall be possible from custom Eclipse plugin (alternatively: via browser)

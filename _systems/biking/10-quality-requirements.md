---
title: Quality Requirements
order: 10
---

## Quality Tree

![Quality tree](../images/10-quality-tree.png)

## Evaluation Scenarios

**Testability / Coverage**

By using JaCoCo during [development and the build process](http://info.michael-simons.eu/2014/05/22/jacoco-maven-and-netbeans-8-integration/), ensure a code coverage of at least 95%.

**Testability / Independent from external services**

The architecture should be designed such that algorithms depending on external services can be tested without the external service being available — all external dependencies should be mockable.

Example: `FetchBikingPicturesJob` needs a resource containing an RSS feed. Retrieving the resource and parsing it are two separate tasks. Fetching the resource through a separate class, `DailyFratzeProvider`, makes testing the actual parsing independent from an HTTP connection, and thus relatively simple.

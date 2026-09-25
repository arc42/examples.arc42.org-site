---
layout: system

permalink: /systems/wirschiffendas/

title: WirSchiffenDas
tagline: Choreographed microservices analysing engine options.

domain: Engineering / manufacturing

highlights:
  - section: 6
    why: circuit breaker edges in a table, each with its fallback
  - section: 9
    why: eight ADRs in one table, alternatives and consequences included
  - section: 11
    why: technical debt traced to named microservice anti-patterns

main_goal: >-
  Show that the analysis of an engine's optional equipment can run as
  independent services that stay responsive and isolate each other's failures.

decisions:
  - Choreography, the coordinator starts only the anchor
  - REST for transitions, Kafka for status and retry
  - Circuit breaker at the caller, publishing failed

technologies:
  - NestJS
  - Kafka
  - React

keywords:
  - adr
  - runtime-view
  - quality-scenario
  - risk

scale: proof of concept · 6 services, 8 containers · single author · 2026

order: 110

# ---------------------------------------------------------------------------
# Provenance. Nihad Jabrayilzade wrote the system and its documentation and
# gave the arc42 maintainers permission to host this snapshot in September
# 2026. The repository is MIT licensed.
# Snapshot: docs/arc42.md at commit e54e991f47ffdf3d420b89d910e4de171abeac70
# (2026-09-25, "Initial public release").
# ---------------------------------------------------------------------------
attribution: Nihad Jabrayilzade
contributed: true
licence: MIT
licence_url: https://opensource.org/license/mit
source_url: https://github.com/nihadio/wirschiffendas
imported: 2026-09
---

**WirSchiffenDas** is a proof of concept by **Nihad Jabrayilzade**. It
analyses the optional equipment configuration of a yacht engine, the "Diesel
Engine 2000 M96". Eleven equipment groups are cut into four clusters by
physical assembly group (Fluids, Drivetrain, Mechanical and EMS), and each
cluster runs as its own NestJS service. Nihad wrote both the code and this
documentation; the full repository, runnable with one Docker Compose command,
is at [github.com/nihadio/wirschiffendas](https://github.com/nihadio/wirschiffendas).

The services coordinate themselves by choreography. The coordinator checks
the configuration and starts only Fluids; Fluids starts Drivetrain and
Mechanical in parallel, and EMS waits until both have reported for the same
run. Status and results travel over Kafka and reach the browser as
server-sent events. Every REST call between services sits behind a circuit
breaker, and a single failed cluster can be retried on its own.

The documentation is compact and dense with tables. Section 6 lists every
protected call with its breaker and fallback. Section 9 holds eight decisions,
each with the alternatives that were rejected. Section 11 names ten debts and
two risks, half of the debts traced to a published catalogue of microservice
anti-patterns, and ends with a short retrospective on where orchestration
stops and choreography begins.

Nihad explains that design question in an article of his own:
[Choreography moves the orchestrator's work, it does not delete it](https://medium.com/@nihadio/choreography-moves-the-orchestrators-work-it-does-not-delete-it-273b7835b094).

This is a snapshot of the documentation as of 25 September 2026. The original
covers arc42 sections 1 to 11; section 12 says so. The quality tree at the
head of section 10 is Nihad's own diagram, which his build places in that
section. The Markdown source, the PlantUML and Mermaid diagram sources and
the OpenAPI documents of the six services are kept in this site's repository.

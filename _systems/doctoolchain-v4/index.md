---
layout: system

permalink: /systems/doctoolchain-v4/

title: docToolchain v4
tagline: Docs-as-code toolchain, documenting its own ground-up rewrite.

domain: Developer tooling

main_goal: >-
  Turn AsciiDoc documentation into published HTML, PDF, microsites and
  Confluence pages — cross-platform, from one wrapper script, with the v4
  rewrite shedding Gradle and jBake for plain Groovy.

decisions:
  - Plain Groovy scripts as tasks — v4 removes Gradle entirely
  - LLM-native architecture with MCP integration
  - Kroki server for rendering all diagrams-as-code

technologies:
  - Groovy
  - AsciiDoctor
  - Kroki

keywords:
  - adr
  - quality-scenario
  - risk
  - runtime-view

scale: Open source since 2017 · community project led by its creator · the v4 rewrite is documented in 20 ADRs

order: 70

# ---------------------------------------------------------------------------
# Provenance. docToolchain was created by Ralf D. Müller and is developed by
# its community; the arc42 documentation reproduced here comes from the
# main-4.x branch of the docToolchain repository (src/docs/arc42/, fetched
# 2026-08-12) and is MIT-licensed, which permits republication with the
# licence notice preserved — _originals/LICENSE keeps it. The AsciiDoc
# originals and rendered diagrams live in _originals/.
# ---------------------------------------------------------------------------
attribution: Ralf D. Müller & the docToolchain contributors
# contributed: third-party work — puts "Contributed by <attribution>" on the
# dashboard tile.
contributed: true
licence: MIT
licence_url: https://github.com/docToolchain/docToolchain/blob/main-4.x/LICENSE
source_url: https://doctoolchain.org/docToolchain/v4.0.x/arc42/
imported: 2026-08
---

**docToolchain** is the docs-as-code toolchain created by **Ralf D. Müller**:
it turns AsciiDoc into HTML, PDF, microsites and Confluence pages, and pulls
architecture material out of tools like Enterprise Architect so the
documentation can live in the repository next to the code. It has grown with
its community since 2017; this documentation describes **version 4**, a
ground-up rewrite that removes Gradle and jBake in favour of plain Groovy
scripts and adds an LLM-native, MCP-integrated architecture.

![docToolchain logo](images/doctoolchain-logo.png)

Two things make this example worth reading. First, it documents an
**architecture in transition**: the building block view reasons openly about
the v3→v4 delta — what was removed and why — and one ADR even records that
its accepted decision was reversed during implementation. Second, it is
unusually well cross-wired: quality scenarios, risks, threats and decisions
all carry stable IDs and reference each other, so every decision names the
scenarios it supports and the risks it creates — the goals→strategy→decisions
traceability chain arc42 recommends, worked end to end.

The chapters were written for a tool that builds documentation, by the people
who build it — down to a runtime scenario for error recovery and a quality
tree with nineteen six-part scenarios.

---
layout: system

permalink: /systems/htmlsc/

title: HtmlSanityCheck
tagline: Broken-link checker for generated HTML documentation.

domain: Developer tooling

# The curated band on /sections/NN-slug/ — "worth starting with".
#
# Declared HERE, in the system's own directory, and not in a central
# _data/section-picks.yml: that file would be exactly the registry
# _includes/system-context.html forbids, and it would be the file nobody
# remembers to revisit when a system is added.
#
# Optional, per system and per section. A system with none appears in the full
# list on each page and is simply never a lead, which is what lets an import
# ship complete before anyone has decided what it is exemplary at.
#
# `why` completes an implied "read this one because...": one line, lower case,
# no closing full stop, under about sixty characters. It is about THIS SECTION
# of this document, not about the system — "4M requests a day" is a fact about
# the software and belongs in `scale`.
highlights:
  - section: 5
    why: small enough to read at once, still three levels deep
  - section: 9
    why: two decisions, one of them a deliberate postponement

main_goal: >-
  Find broken links and missing images in generated HTML, from inside an
  automated build.

decisions:
  - Groovy, with minimal external dependencies
  - Shipped as a Gradle plugin
  - Template method for checkers and reporters

technologies:
  - Groovy
  - Java
  - Gradle

keywords:
  - adr
  - quality-scenario
  - deployment-view
  - lean

scale: Small open-source tool · single maintainer · on GitHub since 2014

order: 10

# Provenance. Confirmed by Gernot Starke, 2026-08-07: he is the author of
# this documentation and it is CC BY-SA 4.0. That covers the PROSE reproduced
# here, which is the thing this block is about — HtmlSanityCheck the software
# is separately Apache-2.0, and that licence is not what governs this page.
attribution: Gernot Starke
licence: CC BY-SA 4.0
licence_url: https://creativecommons.org/licenses/by-sa/4.0/
source_url: https://leanpub.com/arc42byexample
imported: 2026-08
---

![HtmlSanityCheck](images/htmlsc-logo.png)

The system documented here is a small open source tool hosted on
[GitHub](https://github.com/aim42/htmlSanityCheck).

The full sourcecode is available — you might even configure your Gradle build
to use this software. Just in case you're writing documentation based on
Asciidoctor, that would be a great idea!

But enough preamble. Let's get started…

> **Convention for this example**
>
> At the beginning of each section you find short explanations, formatted in
> boxes like this.

This is the smallest example on the site, and the most readable end to end.
It is worth comparing against [MaMa-CRM](../mama/): the same twelve sections,
one describing a single-maintainer build tool, the other a system built by ten
people over fifteen months.

---
layout: system

permalink: /systems/htmlsc/

title: HtmlSanityCheck
tagline: Broken-link checker for generated HTML documentation.

domain: Developer tooling

main_goal: >-
  Find broken links and missing images in generated HTML, from inside an
  automated build.

decisions:
  - Groovy, with minimal external dependencies
  - Shipped as a Gradle plugin
  - Template method for checkers and reporters
  - jsoup for HTML parsing

technologies:
  - Groovy
  - Java
  - Gradle
  - jsoup
  - Asciidoctor

scale: Small open-source tool · single maintainer · on GitHub since 2014

order: 10

# ---------------------------------------------------------------------------
# LICENCE NEEDS CONFIRMING, same as MaMa-CRM.
#
# The chapter carries no licence statement of its own. The SOFTWARE is
# Apache-2.0 (see the repository), but that says nothing about the prose,
# which is what is reproduced here. CC BY-SA 4.0 is the site default and
# Gernot is the author, so it is the likeliest answer — but it is an
# assumption, and this block exists precisely so the site does not assume
# other people's terms.
# ---------------------------------------------------------------------------
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

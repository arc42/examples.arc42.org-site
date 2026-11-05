---
layout: system

permalink: /systems/fotomax/

title: FotoMaX
tagline: Photo-ordering kiosks, moved from monolith to modulith.

domain: Retail / photo services

# Picked at import, 2026-11. Each line is about the section, not the system.
highlights:
  - section: 4
    why: a monolith-to-modulith migration, drawn in four steps
  - section: 8
    why: errors sorted by who can see them and who can fix them
  - section: 9
    why: two decision matrices, the second one weighted
  - section: 10
    why: a priority legend that says when compromise is allowed

main_goal: >-
  Keep one kiosk application serving many retail partners, each with its own
  workflows and branding, while the old monolith is taken apart.

decisions:
  - Restructure the monolith into a modulith
  - Legacy Wizard runs as the first module
  - Partner variants as modules and configuration

technologies:
  - .NET
  - WPF
  - Prism

keywords:
  - adr
  - decision-matrix
  - quality-scenario
  - concept
  - migration
  - onboarding

scale: workshop example · 4 teams, 19 people · ~250 kiosks described

order: 120

# ---------------------------------------------------------------------------
# Provenance. Hendrik Lösch wrote this documentation as chapter VII of
# "arc42 by Example" (Leanpub) and gave the arc42 maintainers permission to
# host it here in November 2026. Source: the book's Markua chapter files and
# draw.io diagrams, kept unchanged in _originals/.
# ---------------------------------------------------------------------------
attribution: Hendrik Lösch
contributed: true
licence: © Hendrik Lösch, republished with permission
source_url: https://leanpub.com/arc42byexample
imported: 2026-11
---

**FotoMaX** is the photo kiosk you find in a drugstore or supermarket: a
screen, a card reader, a printer, and software that turns a memory card into
an order. **Hendrik Lösch** wrote this documentation for his workshops on
architecture documentation, and it first appeared as a chapter of
[arc42 by Example](https://leanpub.com/arc42byexample). FotoMaX never existed
as one product. Hendrik assembled it from several real cyber-physical projects,
so the problems it describes are real ones: software grown since 2010,
maintained by several teams, tied to special hardware, and customised for
dozens of retail partners.

The documentation follows one of those problems all the way through. The kiosk
software, the Wizard, began as a WPF monolith; after an architecture review in
2019 it is being turned into a modulith. Section 4 draws the migration step by
step, section 9 records the decisions behind it, including a matrix that rates
four architecture patterns against the ISO 25010 qualities and a weighted
comparison of two application frameworks, and section 11 lists the risks the
old code still carries.

Hendrik also bent the arc42 structure on purpose, and says why. The original
puts the quality requirements second, right after the introduction, because
they are few and all of them matter. It opens with a page that tells each
reader which parts concern them, and it ends with a chapter that is not arc42
at all: onboarding checklists, review guidelines, Definition of Ready and Done,
kept next to the architecture so the team treats both as one body of work. On
this site the sections follow the arc42 numbering. The opening page is part of
[section 1](01-introduction-and-goals/), and the team chapter follows the
[glossary](12-glossary/#organizational-topics).

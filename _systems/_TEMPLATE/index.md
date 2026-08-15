---
layout: system

# ---------------------------------------------------------------------------
# THE ONLY LINE THAT REPEATS THE DIRECTORY NAME.
# `make new-system SLUG=...` rewrites it for you. If you copied this directory
# by hand, change TEMPLATE to your directory name and nothing else.
# ---------------------------------------------------------------------------
permalink: /systems/TEMPLATE/

# ---------------------------------------------------------------------------
# Everything below IS the dashboard tile. Write it for a reader who has never
# heard of this system and is deciding, in about eight seconds, whether it is
# worth opening. Keywords, not sentences, wherever a list is asked for.
# ---------------------------------------------------------------------------

title: Name of the System

# Heads the system's OWN page, and is matched by the dashboard filter. It is no
# longer printed on the tile (2026-08-12) — the tile prints `main_goal`, and a
# tagline that paraphrases the goal was the tile's last piece of redundancy. So
# write these two as a pair: if the tagline is the goal with different words,
# the tagline is doing nothing. Under 60 characters.
tagline: One line, under 60 characters, saying what it is.

# Free text, but reuse a value another example already uses where it fits —
# the dashboard filter matches on it.
domain: Business domain

# One sentence. The single thing this architecture had to get right.
main_goal: The most important goal the architecture had to achieve.

# The handful of decisions that shaped everything else (arc42 section 4). At
# most three; the tile truncates beyond that.
#
# A SHORT CLAUSE, not a keyword. This said "keywords only" until 2026-08-11 and
# all 24 values in the corpus ignored it, correctly: "Pipes and filters, with a
# database as the pipe" is the decision, and "Pipes and filters" is a pattern
# name that could describe half the systems here. The tile now sets these as a
# plain list rather than as chips, which is what made the sentences legible.
# Aim under 50 characters. Every one of these wraps to two lines in the tile.
decisions:
  - The decisive architectural choice, in a clause
  - Another one
  - A third

# At most three, ONE TOKEN EACH: "PostgreSQL", not "PostgreSQL 14 for storage",
# and never a parenthesis or a slash — "MQTT", not "MQTT (via ActiveMQ)". These
# no longer appear on the dashboard tile (2026-08-11) — only on the system's own
# page — but the site search matches them, so keep them to the tokens a reader
# would actually type.
technologies:
  - Language
  - Framework
  - Datastore

# OPTIONAL, and a DIFFERENT AXIS from `domain`: the domain says what the
# SYSTEM is, keywords say what the DOCUMENTATION demonstrates. Loose, like
# blog tags — not a fixed vocabulary — but reuse the docs.arc42.org tip
# keywords where they fit (adr, runtime-view, quality-scenario, deployment-
# view, glossary, …) so the two sites stay searchable in the same words.
# Rendered on the system's own page and matched by the site search; NEVER on
# the dashboard tile.
# keywords:
#   - adr
#   - runtime-view

# Optional. Gives a reader a sense of scale — the thing a documentation
# usually never says out loud.
scale: ~50 kLOC · 6 developers · in production since 2019

# Position on the dashboard. Lower numbers first. Leave gaps (10, 20, 30) so
# an example can be slotted in later without renumbering every other one.
order: 999

# OPTIONAL, and rare: announce an example before it is written. Set
# `upcoming: true` and the tile is quieted — recessed fill, dashed border, no
# catalogue number — and stamped with a diagonal "Coming soon" band; the
# system's page prints a "not published yet" note where the twelve-section
# grid normally goes; and the dashboard's opening sentence counts it
# separately, because it calls everything it counts complete.
#
# The four tile fields above are still owed: an announced tile that says
# nothing about what is coming is just a gap in the grid. `decisions` and
# `keywords` are NOT — both describe a documentation nobody has read, and
# scripts/check-system-fields.sh exempts an upcoming system from both rather
# than inviting you to invent them. Supply neither or supply both.
#
# Use it only when the documentation is genuinely on its way and there is a
# public URL to point at in `source_url`. To publish: delete this line, add
# the twelve section files, fill in decisions and keywords. Nothing else
# changes.
# upcoming: true

# Review notes need NO field here. If the arc42 maintainers review this
# system, their notes live in _data/reviews/<slug>.yml — deliberately
# outside this directory, because the review is their voice, not part of
# the contributed work — and the overview derives its disclaimer and
# findings list from that file's existence. Workflow: CONTRIBUTING.md,
# "Review notes"; contract: ADR-0009 (meta.arc42.org).

# ---------------------------------------------------------------------------
# Provenance. NOT OPTIONAL — these are other people's systems and other
# people's writing, and the site says so on every overview page.
# ---------------------------------------------------------------------------
attribution: Who wrote the original documentation
# Set `contributed: true` when the documentation is third-party work: it puts
# "Created by <attribution>" on the dashboard tile. Omit it for
# site-authored examples. Not derivable from `imported`, which every system
# carries.
# contributed: true
licence: CC BY-SA 4.0
licence_url: https://creativecommons.org/licenses/by-sa/4.0/
source_url: https://github.com/example/original
imported: 2026-08
---

Optional prose. Two or three paragraphs introducing the system and, more
usefully, saying **why it is worth reading as an example** — what a reader
should look at, what this documentation does unusually well or unusually
briefly.

Skip it if the tagline and the facts above already say enough.

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
tagline: One line, under 60 characters, saying what it is.

# Free text, but reuse a value another example already uses where it fits —
# the dashboard filter matches on it.
domain: Business domain

# One sentence. The single thing this architecture had to get right.
main_goal: The most important goal the architecture had to achieve.

# The handful of decisions that shaped everything else (arc42 section 4).
# Keywords only, at most four — the tile truncates beyond that.
decisions:
  - Decisive architectural choice
  - Another one
  - A third

# At most six. Keywords only: "PostgreSQL", not "PostgreSQL 14 for storage".
technologies:
  - Language
  - Framework
  - Datastore

# Optional. Gives a reader a sense of scale — the thing a documentation
# usually never says out loud.
scale: ~50 kLOC · 6 developers · in production since 2019

# Position on the dashboard. Lower numbers first. Leave gaps (10, 20, 30) so
# an example can be slotted in later without renumbering every other one.
order: 999

# ---------------------------------------------------------------------------
# Provenance. NOT OPTIONAL — these are other people's systems and other
# people's writing, and the site says so on every overview page.
# ---------------------------------------------------------------------------
attribution: Who wrote the original documentation
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

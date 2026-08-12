---
layout: system

permalink: /systems/fin-mig/

title: M&M Data Migration
tagline: Mainframe migration of 20 million financial records.

domain: Financial services

main_goal: >-
  Move ~20 million person and account records off VSAM/EBCDIC into a new Java
  object model, audit-proof, inside a single 24-hour window.

decisions:
  - Pipes and filters, with a database as the pipe
  - Parallel rule processing over independent segments
  - Migration rules in Java, not in a rule engine

technologies:
  - Java
  - Oracle
  - VSAM

scale: ~20 million persons · 50+ million accounts · 24-hour migration window · ran once, ca. 2002/2003

order: 40

# ---------------------------------------------------------------------------
# Provenance. THE ONE EXAMPLE ON THIS SITE THAT IS NOT CC BY-SA 4.0 — do not
# "harmonize" it with the others.
#
# mama, htmlsc and status.arc42.org are CC BY-SA 4.0 because their source is
# «arc42 by example» (Leanpub). This one comes from chapter 12 of «Effektive
# Softwarearchitekturen», a book published by Carl Hanser Verlag, so the rights
# are held jointly by the author and the publisher. Confirmed by Gernot Starke,
# 2026-08-08.
#
# The site-wide CC BY-SA 4.0 in the footer therefore does NOT cover this
# example's text or figures. That is exactly what the footer's second sentence
# is for ("each example additionally carries its own licence and attribution on
# its overview page"), and why `licence` is a free-text field rather than an
# enum.
# ---------------------------------------------------------------------------
attribution: Gernot Starke
licence: © Gernot Starke and Carl Hanser Verlag
source_url: https://esabuch.de
imported: 2026-08
---

M&M — short for *Migration von Massendaten*, migration of mass data — is a batch
system that moved roughly 20 million person records and more than 50 million
accounts off a 1970s IBM mainframe and into the object model of a new Java
application. It ran in production exactly once.

That "exactly once" is what makes it worth reading. A system with a single
production run has no modifiability requirements, no security requirements worth
the name, and no user interface — so almost everything in this architecture is
driven by just two goals: get through 20 million people in under 24 hours, and be
able to prove afterwards that every record was handled correctly. The
[solution strategy](04-solution-strategy/) is three lines long, and you can
trace nearly every [decision](09-architecture-decisions/) back to one of those
two goals.

It is also a good example of a documentation that says out loud where it stops.
Several building blocks are deliberately left as blackboxes, the quality
scenarios and the risk section are marked as omitted, and the author notes at
each point what a real documentation would have to add instead.

## Notes on the System

A few words of clarification: this project really happened, and the M&M system
really was built. The client, "Fies und Teuer AG", was of course called something
else in reality, and the business content has been simplified a little.

The real migration project took place around 2002/2003 somewhere in Germany. Over
a good twelve months, more than ten domain experts analysed the logic and
business rules of the existing mainframe systems and built the business migration
concept on that basis. This had to take account of the particular requirements
for proof and record-keeping, and of the legal conditions that had changed over
time. Interlocked with that work, a team of more than ten developers and
architects built the matching software.

Some of the stumbling blocks and challenges of the "real" M&M project are
collected in [section 11](11-risks-and-technical-debt/).

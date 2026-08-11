---
layout: system

permalink: /systems/tpu/

title: Traffic Pursuit Unit
tagline: In-car speed measurement and video evidence for police pursuits.

domain: Embedded / law enforcement

main_goal: >-
  Produce measurements and video recordings accurate and tamper-evident enough
  to hold up in court, while keeping every legally approved part inside one
  separately certifiable unit.

decisions:
  - Legally relevant functions isolated in an exchangeable MeasuringUnit
  - Embedded real-time OS for measuring, Linux for video
  - Integer (fixed-point) arithmetic throughout
  - Fixed 200 ms display delay via a five-frame buffer

technologies:
  - C++
  - RTOS
  - ARM
  - GPS

scale: Hardware/software product · in police cars · successor to an earlier TPU generation

order: 50

# ---------------------------------------------------------------------------
# Provenance. Chapter IX of «arc42 by Example — 20th Anniversary Edition»,
# published on Leanpub — same source as mama and htmlsc, hence the same
# licence and the same source_url.
#
# Copyright is held jointly by Wolfgang Reimesch and Peter Hruschka; Wolfgang
# Reimesch wrote the chapter. Both are named here because `attribution` is what
# the overview page prints as "Written by", and what CC BY-SA attribution
# requires. Confirmed by Gernot Starke, 2026-08-10. Do not reduce this to one
# name.
# ---------------------------------------------------------------------------
attribution: Wolfgang Reimesch and Peter Hruschka
licence: CC BY-SA 4.0
licence_url: https://creativecommons.org/licenses/by-sa/4.0/
source_url: https://leanpub.com/arc42byexample
imported: 2026-08
---

The Traffic Pursuit Unit (TPU) is a hardware/software system built into police
cars. It follows a suspect vehicle, measures its speed profile with high
precision, and records video evidence of the violation — accurate enough, and
documented well enough, to survive a challenge in court.

Two things make it worth reading as an example. First, it is the only system on
this site where the architecture is driven by *legal approval*: everything a
regulatory authority has to certify is deliberately confined to one physically
separate MeasuringUnit, so that the rest of the device can be changed without
re-certifying it. Second, its authors chose to go deep — the building block
view descends to the level of C++ classes and header files, and the runtime
view shows *the same scenario four times* in four different UML notations
(sequence, communication, activity, and an extended activity diagram with
swim lanes), which is an unusually direct answer to the question of what each
notation actually buys you.

Compare the depth here with the other examples on this site: the TPU
documentation goes further down than any of them, and its diagrams are hand-drawn
in Enterprise Architect rather than generated.

---
layout: system

permalink: /systems/rgcat/

title: RGCAT
tagline: Geometry coverage analysis for roboforming process data.

domain: Academia and research

main_goal: >-
  Turn tabular roboforming geometry data into reduced representations and
  clusters, find the regions the process has not covered, and make every run
  reproducible enough to compare one pipeline variant against another.

# ---------------------------------------------------------------------------
# UPCOMING. The arc42 documentation and the ADRs are named on the project's
# own release page as part of a public release that has not happened yet, so
# this example is announced rather than written: the dashboard tile is quieted
# and stamped "Coming soon", and the page below carries no section grid.
#
# `decisions:` and `keywords:` are deliberately absent, and scripts/
# check-system-fields.sh exempts an upcoming system from both. They describe
# what a documentation demonstrates; nobody has read this one, because it does
# not exist yet, and filling them in from a project home page would be
# guessing dressed as a fact.
#
# TO PUBLISH: drop `upcoming:`, add the twelve section files, and fill in
# decisions + keywords from what they actually say. Nothing else changes.
# ---------------------------------------------------------------------------
upcoming: true

technologies:
  - Python
  - HDBSCAN
  - Docker

scale: Master's thesis · Ruhr-Universität Bochum · source not yet public

order: 90

# ---------------------------------------------------------------------------
# Provenance. RGCAT is Per Starke's master's thesis project, supervised by Jan
# Schäfer. Nothing is reproduced here yet — this page describes a project from
# its public home page and links to it. `licence:` records the licence the
# release page announces, marked as announced, so it is never mistaken for a
# licence we have actually seen.
# ---------------------------------------------------------------------------
attribution: Per Starke, Ruhr-Universität Bochum
contributed: true
licence: MIT (announced)
licence_url: https://opensource.org/license/mit
source_url: https://rgcat-toolkit.github.io/
---

![RGCAT — a formed sheet-metal surface rendered as a coloured mesh above the
wordmark](images/rgcat-logo.png)

**RGCAT** — the Roboforming Geometric Coverage Analysis Toolkit — is a Python
toolkit for *roboforming*, the incremental sheet-forming process in which one
or more robot arms push a blank into shape along a path instead of pressing it
in a die. A campaign of such runs produces a table of geometries, and the
question this toolkit exists to answer is which shapes the campaign has *not*
made: where the covered region of the geometry space has holes, and which
candidate geometry would fill the largest one.

It is being built by **Per Starke** at Ruhr-Universität Bochum as a master's
thesis, supervised by **Jan Schäfer**.

## Why it is here before it exists

The project's [release page](https://rgcat-toolkit.github.io/) lists what will
be published with the source code, and two of the items are the reason this
tile is on the dashboard:

> - Python source code
> - Docker and Conda environments
> - Usage and configuration guides
> - Pipeline walkthrough
> - **arc42-based architecture documentation**
> - **Architecture decision records**
> - MIT license

The documentation is being written with the system, by the person building it,
and it is arriving with the first public release rather than after it. What is
new here is only that the dashboard now has somewhere to say so before the
chapters exist.

## What it does, so far as the project says

The pipeline is config-driven — one YAML file selects each stage — and runs in
nine steps: ingestion of CSV, Parquet or Feather tables; feature expansion into
flat vectors and z-map features; representation by PCA, VAE or VaDE;
clustering by KMeans, HDBSCAN or a combination; k-nearest-neighbour coverage
and sparse-region metrics; gap detection by candidate sampling and ranking;
reconstruction of a candidate back into the original feature space; an
analytical before/after evaluation of adding that candidate; and a timestamped
run folder holding metrics, plots, logs, a config snapshot and a static HTML
report.

Reproducibility is the stated design driver rather than a quality goal added
afterwards: every run writes the same folder structure so that two pipeline
variants can be compared on identical outputs. The project is careful to say
that reconstructed candidates are analytical suggestions, not validated
process data.

## When it lands

The source repository is not public yet; the software, environments,
documentation and licence files are to be published together. When the arc42
chapters appear, they will be reproduced here in full under the MIT licence
the project announces — the same basis on which
[docToolchain v4](../doctoolchain-v4/) is hosted.

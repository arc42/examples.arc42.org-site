---
layout: system

permalink: /systems/heldenhelfer/

title: Heldenhelfer
tagline: Volunteering platform for the clubs of Würzburg.

domain: Public sector

highlights:
  - section: 10
    why: thirty-five scenarios, each with a priority
  - section: 9
    why: a dated decision log, two entries deferring a storage choice past the pilot
  - section: 8
    why: a real log line as the specification of the logging concept

main_goal: >-
  One portal where the clubs and initiatives of Würzburg keep their members,
  files and forum, assembled from open source parts behind a single login.

decisions:
  - Third-party tools wired by Kafka events, one sidecar each
  - Keycloak of the Smart City Hub for single sign-on
  - Clean Architecture in every self-written service

technologies:
  - Python
  - Next.js
  - Kafka

keywords:
  - quality-scenario
  - adr
  - building-block
  - concept

scale: 5 self-built services beside Nextcloud and Discourse · team of about 6 · half a year · pilot 2024

order: 100

# ---------------------------------------------------------------------------
# Provenance. The platform and its documentation belong to Smarte Region
# Würzburg (Stadt und Landkreis Würzburg); the documentation was written by
# smart and public GmbH on their behalf. Permission to host this snapshot was
# given by email from the Heldenhelfer project manager at Smarte Region
# Würzburg in September 2026, with the note that the repository is archived
# on openCode and neither code nor documentation will change from their side.
# Snapshot: documentation v1.5.0 of 2024-07-01, repository commit
# b36958260577625c1fb6da66a4acdcb597ae6750 (2026-04-22).
# ---------------------------------------------------------------------------
attribution: Smarte Region Würzburg
contributed: true
licence: MIT
licence_url: https://opensource.org/license/mit
source_url: https://gitlab.opencode.de/wuerzburg/heldenhelfer/-/tree/main/architecture_doc
imported: 2026-09
---

**Heldenhelfer** ("heroes' helper") is the volunteering platform of the city
and district of Würzburg: a portal where clubs and initiatives keep their
member records, a Nextcloud digital office for their files, and a Discourse
forum, all behind one Keycloak login. The platform belongs to **Smarte Region
Würzburg** and runs at
[heldenhelfer.wuerzburg.de](https://heldenhelfer.wuerzburg.de/info/); it was
built and documented by smart and public GmbH on their behalf, on the
infrastructure of the region's Smart City Hub.

The architecture is small and easy to hold in one view. Two services are
written for the project, a Next.js web UI and a FastAPI backend. Everything
else is an open source product configured at runtime: when a club is created,
the backend publishes an event to Kafka, and one sidecar service per product
picks it up and configures Nextcloud, Discourse or Keycloak through their
APIs. Section 6 walks through exactly that flow.

Worth reading for the quality requirements, thirty-five scenarios sorted by
priority in section 10, and for the decision log in section 9, where each entry
carries a date and the people who took it, and two of them record choosing the
cheaper storage for the pilot with the switch deliberately postponed.

This is a snapshot of documentation version 1.5.0, dated 1 July 2024, the
last of seven revisions listed in the original's document history. Development
stopped in August 2024 and the repository on openCode is archived, so the
snapshot is also the final state. The sources, including the Structurizr model
the diagrams were exported from, are kept alongside.

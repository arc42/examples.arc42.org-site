---
layout: system

permalink: /systems/UBA-SNS/

title: UBA-SNS (Semantic Network Service)
tagline: Environmental thesaurus and chronicle as Linked Open Data.

domain: Environmental information

main_goal: >-
  Open access to environmental information through W3C standards, in human and
  machine readable form, with reusable web services for specialist
  applications.

decisions:
  - Linked Open Data, with HTTP URIs and the W3C RDF and SKOS standards
  - Modular Rails engine architecture on the open source iQvoc framework
  - Docker containers behind a Caddy reverse proxy

technologies:
  - Ruby on Rails
  - iQvoc
  - PostgreSQL

keywords:
  - runtime-view
  - deployment-view
  - concept

scale: ~12,000 descriptors · ~40,000 non-descriptors · ~4,000 chronicle entries · in production at sns.uba.de

order: 60

# ---------------------------------------------------------------------------
# Provenance. The application and its documentation belong to the German
# Environment Agency (Umweltbundesamt, UBA). Permission to republish the
# documentation here (Freigabe) was granted by the UBA and received on
# 2026-08-12. SNS was developed by INNOQ on behalf of the UBA; the UBA runs
# it, curates its content and remains the owner, which both the attribution
# line and the overview text below state on the page.
# ---------------------------------------------------------------------------
attribution: Umweltbundesamt (UBA)
# contributed: third-party work — puts "Contributed by <attribution>" on the
# dashboard tile. Not derivable from `imported`, which every system carries.
contributed: true
licence: CC BY-SA 4.0
licence_url: https://creativecommons.org/licenses/by-sa/4.0/
source_url: https://sns.uba.de
imported: 2026-08
---

The **Semantic Network Service (SNS)** makes the environmental thesaurus
UMTHES and the Environmental Chronicle publicly available as Linked Open Data.
The application belongs to the **German Environment Agency (Umweltbundesamt,
UBA)**, which runs the service at [sns.uba.de](https://sns.uba.de) and curates
its content; development was carried out by INNOQ on behalf of the UBA.

![Logo of the German Environment Agency (Umweltbundesamt)](images/uba-logo.png)

Beyond interactive search and navigation in the browser, SNS offers reusable
services and APIs for environmental informatics, among them automatic keyword
assignment for documents (**AutoClassify**) and the retrieval of semantically
similar concepts (**SimilarTerms**).

The architecture builds on the open source framework **iQvoc**, a Ruby on
Rails engine architecture, on the standardized W3C formats RDF, SKOS and
SKOS-XL, and on a containerized infrastructure with PostgreSQL and Caddy.

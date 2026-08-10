---
layout: system

permalink: /systems/UBA-SNS/

title: UBA-SNS (Semantischer Netzwerkservice)
tagline: Open-Data-Plattform des Umweltbundesamtes für Umweltthesaurus und -chronik.

domain: Environmental Information / Semantic Web

main_goal: >-
  Den Zugang zu Umweltinformationen über offene Standards (RDF, SKOS, Linked Open Data) in menschen- und maschinenlesbarer Form ermöglichen und wiederverwendbare Webdienste für Fachanwendungen bereitstellen.

decisions:
  - Linked Open Data (HTTP-URIs und W3C RDF/SKOS Standards)
  - Modulare Rails-Engines-Architektur (iQvoc Framework)
  - Docker-Containerisierung hinter Caddy Reverse-Proxy
  - PostgreSQL als relationales Datenbankmanagementsystem

technologies:
  - Ruby on Rails
  - iQvoc / SKOS / RDF
  - PostgreSQL
  - Caddy
  - Docker
  - Bootstrap 5

scale: ~12.000 Deskriptoren · ~40.000 Nicht-Deskriptoren · ~4.000 Chronik-Einträge · Open-Data-Dienst des UBA

order: 70

attribution: Umweltbundesamt (UBA) & INNOQ
licence: CC BY-SA 4.0
licence_url: https://creativecommons.org/licenses/by-sa/4.0/
source_url: https://sns.uba.de
imported: 2026-08
---

Der **Semantische Netzwerkservice (SNS)** macht den UmweltThesaurus (UMTHES) und die Umweltchronik des Umweltbundesamtes (UBA) öffentlich als Linked Open Data zugänglich.

Neben der interaktiven Suche und Navigation im Web-Browser stellt SNS wiederverwendbare Dienste und APIs für Anwendungen der Umweltinformatik bereit, darunter die automatische Verschlagwortung von Dokumenten (**AutoClassify**) und die Ermittlung semantisch ähnlicher Begriffe (**SimilarTerms**).

Die Architektur basiert auf dem Open-Source-Framework **iQvoc** (Ruby on Rails Engine-Architektur), standardisierten W3C-Formaten (RDF, SKOS, SKOS-XL) und einer containerisierten Infrastruktur mit PostgreSQL und Caddy.

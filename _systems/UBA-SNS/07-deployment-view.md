---
title: Deployment View
order: 7
---

Diese Sicht beschreibt die Umgebung, auf denen das SNS-System betrieben wird.

## Produktionsumgebung

Die Betriebsinfrastruktur wird seit Anfang 2024 vom Umwelt-Info Projekt (https://gitlab.opencode.de/umwelt-info/infrastruktur/testbetrieb) bereitgestellt und basiert auf eine einzige virtuelle Maschine im eigenen Rechenzentrum. Die virtuelle Maschine wird komplett automatisiert mit OpenStack aufgesetzt. Cloud-Dienste sind nicht involviert.

## Infrastruktur Ebene 1

![Infrastruktur Umwelt-Info](../images/deployment-view-umweltinfo.png)

## Infrastrukturkomponenten

### Applikationsserver

* **Betriebssystem**: Ubuntu 24.04 LTS
* **Caddy Reverse-Proxy**: letzte stabile Version für Ubuntu 24.04
* **Docker**: letzte aktuelle Version
* **Gitlab (OpenCode) Container Registry**: Technische Infrastruktur für das Deployment. Dient zum Empfang/Quelle von Docker-Containern, die die jeweilige Fachanwendung enthalten.

### Datenbankserver

* **PostgreSQL**

### Fachanwendungen

Die Fachanwendungen UMTHES, Chronik und Portal werden von der Entwicklung in Form von Docker-Containern geliefert und auf dem Container-Plattform betrieben. Die Container enthalten alle benötigten Komponenten (z.B. Ruby Interpreter) und liefern die jeweilige Anwendung über einen exponierten Port an den Applikationsserver aus.

Details zur Installation bzw. dem Betrieb von Docker sind in der offiziellen Dokumentation zu finden: https://docs.docker.com/

Die spezifischen Docker-Container für UMTHES, Chronik und Portal sind Teil des Quelltexts (Dockerfile, docker-compose.yml) der jeweiligen Fachanwendung (siehe [Bausteinsicht](../05-building-block-view/)).

---
title: Building Block View
order: 5
---

## Whitebox Gesamtsystem

![Bausteinsicht Gesamtsystem](../images/building_block_view.jpg)

| Subsystem | Beschreibung | Quelltext |
|---|---|---|
| Caddy Reverse-Proxy | Zentraler Einstiegspunkt in das SNS-System. Dispatched auf das jeweilige Subsystem. Zugriff auf den Reverse-Proxy erfolgt verschlüsselt über HTTPS. Reverse-Proxy führt SSL-Offloading durch. Die Kommunikation mit den Subsystemen erfolgt anschließend unverschlüsselt. | |
| UMTHES | Umweltthesaurus mit ca. 12.000 Deskriptoren (Schlagwörtern) und ca. 40.000 Nicht-Deskriptoren (Zugangsvokabular, deutsch und englisch). | [https://github.com/innoq/iqvoc_umt](https://github.com/innoq/iqvoc_umt) |
| Chronik | Umweltchronik mit ca. 4.000 Einträgen zu Umweltereignissen. | [https://github.com/innoq/iqvoc_chronicle](https://github.com/innoq/iqvoc_chronicle) |
| Portal | Einfaches CMS und Einstiegsseite des SNS-Systems. Mit Hilfe des Github-Editors werden Markdown-Dateien in der Portal Versionsverwaltung erstellt. Die Portalanwendung übernimmt die Transformation von Markdown in das HTML-Format. | [https://github.com/innoq/sns_portal](https://github.com/innoq/sns_portal) |
| PostgreSQL DBMS | Relationales Datenbankmanagementsystem (UMTHES & Chronik) | |

## Ebene 2

### Whitebox UMTHES

![Whitebox UMTHES](../images/building_block_umthes.jpg)

Eine Beschreibung der einzelnen Komponenten und der Architektur findet sich im Kapitel [Querschnittliche Konzepte](../08-crosscutting-concepts/) unter *iQvoc* -> *Erweiterungen*.

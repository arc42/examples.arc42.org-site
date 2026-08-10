---
title: Context and Scope
order: 3
---

![Kontextdiagramm](../images/context.jpg)

| Akteur | Beschreibung | Schnittstelle |
|---|---|---|
| Besucher (Browser) | Der Besucher des öffentlichen Web-Portals https://sns.uba.de. Hierbei handelt es sich um anonyme Besucher, die sich für Umweltinformationen interessieren. | HTTPS |
| Schnittstellenbenutzer | Drittsystem, das Schnittstellen/Dienste von SNS integriert und strukturiert Informationen abruft. Die Dienste und Schnittstellen können anonym ohne Registrierung verwendet werden. | HTTPS |
| Administrator (Browser) | Der Administrator des SNS-Systems. Es handelt sich hierbei um eine Rolle mit erweiterten Zugriffsrechten. Administratoren können unter anderem:<br>- Benutzer anlegen (z.B. für die redaktionelle Pflege)<br>- die Systemkonfiguration verwalten (z.B. verfügbare Sprache)<br>- Daten importieren und exportieren | HTTPS |
| Pflege (Browser) | Benutzer, der SNS-Datenbestand redaktionell pflegt (i.d.R. UBA-Mitarbeiter). SNS ermöglicht die Zusammenarbeit bei der Pflege und der Veröffentlichung des Datenbestandes darüber hinaus durch ein feingranulares Rollensystem. | HTTPS |

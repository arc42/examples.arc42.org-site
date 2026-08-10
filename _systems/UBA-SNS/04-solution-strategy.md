---
title: Solution Strategy
order: 4
---

Die Veröffentlichung des Datenbestandes von SNS erfolgt auf Basis von Linked Open Data (https://www.w3.org/standards/semanticweb/data). Linked Data steht für eine Vernetzung von einzelnen Datenelementen, auf die unmittelbar zugegriffen werden kann. Dies basiert auf Webadressen (HTTP-URIs) für jedes Datenelement und auf dem universellen Datenmodell des Resource Description Frameworks (RDF). Dementsprechend ist jeder SNS-Datensatz durch eine dedizierte URL identifizierbar und kann dadurch frei referenziert werden. Die Bereitstellung der Daten über vom W3C standardisierte RDF-Formate und Serialisierungen garantiert dabei die maschinenlesbare Verarbeitung.

Die vom SNS-System bereitgestellten Daten entstammen zwei autonomen Fachanwendungen:

* **Umweltthesaurus UMTHES**: Umweltterminologie miteinander verknüpfter fachsprachlicher und alltagssprachlicher Benennungen. Von den Benennungen fungieren ca. 12.000 als Begriffe für die Verschlagwortung von Dokumenten. Die übrigen Benennungen (ca. 23.000 deutsche und ca. 17.000 englische) sind den Begriffen (Schlagwörtern) bedeutungsgleich gesetzt. Alle Begriffe sind in eine Netzstruktur eingebunden, wobei allgemeinere Oberbegriffe mit spezielleren Unterbegriffen verknüpft sind (z.B. Baum <> Nadelbaum). Darüber hinaus gibt es aber auch eine Verbindung zwischen thematisch verwandten Begriffen (z.B. Baum <> Baumschutz).
* **Umweltchronik**: Zusammenstellung von ca. 4.000 historischen und aktuellen Umweltereignissen. Seit 2017 wird die Umweltchronik nicht mehr regelmäßig gepflegt.

## Beispiel

Ein Beispiel für die Vernetzung der Daten aus den einzelnen Fachanwendungen:

* Umweltthesaurus UMTHES:
  * Begriff: "Seeschifffahrt", URL: https://sns.uba.de/umthes/de/concepts/_00022275.html
  * Begriff: "Schutzgebiet", URL: https://sns.uba.de/umthes/de/concepts/_00021997.html
  * Begriff: "Wattenmeer", URL: https://sns.uba.de/umthes/de/concepts/_00027422.html
* Umweltchronik:
  * Ereignis: "Wattenmeer international unter Schutz gestellt", URL: https://sns.uba.de/chronik/de/concepts/t1d97d0d_102035cd5d4_-362b.html

![Beispiel für Datenvernetzung](../images/solution-example.jpg)

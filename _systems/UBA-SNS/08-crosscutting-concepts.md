---
title: Crosscutting Concepts
order: 8
---

Dieser Abschnitt beschreibt querschnittliche Regelungen und Prinzipien, die mehr als einen Baustein betreffen und für das Gesamtsystem relevant sind.

## Dienste

Mit den Webdiensten von SNS steht Anbietern von Umweltinformationen (z.B. Umweltportale) eine semantische Unterstützung für ihre Anwendungen zur Verfügung. Alle Dienste verfügen über eine grafische Benutzeroberfläche sowie eine API für die Integration in Fachanwendungen.

Zu den Diensten gehören:

* **Suche**: Durchsuchen des Datenbestands mit Suchwörtern
* **SimilarTerms**: Ausgabe Ähnlicher Begriffe zu einer Sucheingabe
* **AutoClassify**: Verschlagwortung von Dokumenten mit Hilfe des SNS-Wortguts
* **Anniversary**: Ausgabe von Ereignissen "heute vor X Jahren"

Die technischen Schnittstellenbeschreibungen sind öffentlich einsehbar und unter folgendem Link erreichbar: https://sns.uba.de/de/api

### Suche

Die Suche ermöglicht das Auffinden von passenden Fachwörtern bzw. Umweltereignissen anhand von Suchwörtern und Suchräumen. Im UMTHES stehen darüber hinaus Informationen über alternative Benennungen des gefundenen Fachworts sowie dessen Beziehungen zu anderen Fachwörtern des SNS-Wortbestands zur Verfügung. Auch Definitionen zur Bestimmung der Bedeutung der Fachwörter sind in den meisten Fällen als Zusatzinformation vorhanden.

Der Dienst ist unter folgenden URLs erreichbar:

* https://sns.uba.de/umthes/de/search.html
* https://sns.uba.de/chronik/de/search.html

Bekannte Integrationen:

* InGrid: https://dev.informationgrid.eu/umweltchronik

### SimilarTerms

Hierbei handelt es sich um einen Dienst zur Ermittlung von semantisch "ähnlichen" Wörtern zum eingegebenen Suchwort. So liefert SimilarTerms für die Suche nach "Biosprit" u.a. die Ähnlichen Begriffe "Biokraftstoff", "Ökosprit" und "Kraftstoff aus Biomasse".

Der Dienst ist unter folgender URL erreichbar: https://sns.uba.de/umthes/de/similar.html

![SimilarTerms Dienst](../images/sns-services-similar.png)

#### Anwendungsfall

Der SimilarTerms-Dienst kann auch eingesetzt werden, um die Suche in Fachanwendungen zu verbessern. So könnte bei einer Suche mit der Zeichenkette "Biosprit" z.B. die o.g. Begriffe "Biokraftstoff" und "Ökosprit" mitberücksichtigt werden. Dies würde das Suchergebnis aufwerten.

### AutoClassify

Bei AutoClassify handelt es sich um einen Dienst zur automatischen Verschlagwortung von Dokumenten. Der Dienst zerlegt einen Eingabetext in seine Bestandteile, durchsucht an Hand dieser das Wortgut des UMTHES und gibt dann passende Begriffe (Schlagwörter) inklusive Scoring als Antwort zurück.

AutoClassify unterstützt die Analyse von eingegebenem Freitext, es ist aber auch möglich nur eine URL-Adresse einzugeben. Bei Analyse einer URL versucht AutoClassify den Haupttextkörper der Webseite zu extrahieren (d.h. ohne Seitennavigationen, Werbung etc.) und führt anschließend die Textanalyse durch.

Der Dienst ist unter folgender URL erreichbar: https://sns.uba.de/umthes/de/classification.html

![AutoClassify Dienst](../images/sns-services-autoclassify.png)

### Anniversary

Dieser Dienst gibt Umweltereignisse aus, die sich an einem frei wählbaren Datum vor "x-Jahren" ereignet haben (ohne Eingabedatum wird das aktuelle Datum verwendet).

Der Dienst ist unter folgender URL erreichbar: https://sns.uba.de/chronik/de/anniversary.html

![Anniversary Dienst](../images/sns-services-anniversary.png)

## iQvoc

iQvoc ist ein von INNOQ entwickeltes Open-Source-Werkzeug für das Management von Vokabularen (Klassifikationen, Thesauri, …), das einfache Bedienbarkeit mit Semantic-Web-Standards vereint.

iQvoc unterstützt umfassende Funktionen, die alle Aspekte dieses Managements abdecken:

* Import/Export bestehender Vokabulare im SKOS-Format
* Mehrsprachige Darstellung und Navigation in jedem gängigen Web-Browser
* Redaktionsfunktionen für registrierte Anwender im Web
* Einsatz des Vokabulars im Linked-Data-Netz

iQvoc setzt auf aktuelle Technologien und modulare Architektur und kann einfach erweitert werden. iQvoc ist als Open Source verfügbar nach der Apache 2.0-Lizenz.

**Import/Export bestehender Vokabulare im SKOS-Format**

Das Simple Knowledge Organisation System (SKOS) ist ein verbreitetes RDF-Schema zur Abbildung von Vokabularen, wie Glossaren, Klassifikationen, Taxonomien und Thesauri, das von den meisten spezialisierten Anwendungen unterstützt wird. iQvoc unterstützt SKOS vollständig, einschließlich Collections und Mapping Properties. Es liegt auch eine Erweiterung von iQvoc für die SKOS Extension for Labels (SKOS-XL) vor.

**Mehrsprachige Darstellung und Navigation im Web Browser**

iQvoc unterstützt sowohl mehrsprachige Vokabulare als auch eine mehrsprachige Benutzeroberfläche. Beide können beliebig kombiniert werden. Im Vokabular gilt Mehrsprachigkeit für alle Textanteile, also Bezeichnungen (Labels), Definitionen und alle Formen von Anmerkungen (Notes).

Die Navigation ist intuitiv durch direkte Links und ausklappbare hierarchische Darstellungen. Dies funktioniert in allen gängigen Browsern. Das Erscheinungsbild kann durch die moderne, modulare HTML-Architektur einfach und weitreichend angepasst werden.

**Redaktionsfunktionen für registrierte Anwender im Web**

iQvoc ist das perfekte Werkzeug für eine räumlich verteilte Redaktion. Alle arbeiten auf derselben Datenbasis im Web. Die Redaktion umfasst die Rollen Editor, Publisher, Administrator und Gast. Der Workflow beginnt mit dem Auschecken (oder der Neuanlage) einzelner Begriffe. Alle Änderungen sind zunächst nach außen verborgen und gegen konkurrierende Bearbeitung gesperrt. Die Bearbeitung kann aber an andere Redaktionsmitglieder übergeben werden. Eine formale Konsistenzprüfung unterstützt die Qualität. Der Publisher kann freigeben, verwerfen oder zur Bearbeitung zurückgeben. Ein Dashboard zeigt der Redaktion jederzeit den aktuellen Bearbeitungsstand.

**Einsatz des Vokabulars im Linked-Data-Netz**

iQvoc unterstützt Linked-Data-Technik, insbesondere auch Content Negotiation. Dieselbe Concept URI gibt in Abhängigkeit vom geforderten Mime Type HTML, RDF/XML, NTriples oder Turtle Syntax zurück. In Verbindung mit einem Triple Store wird auch ein SPARQL Endpoint verfügbar.

### Rollensystem

Das Rollensystem von iQvoc umfasst Gäste, Leser, Editoren, Match-Editoren, Veröffentlicher und Administratoren:

| Rolle | Beschreibung |
|---|---|
| Gast | API nutzen, Inhalt lesen |
| Leser / Registrierter Nutzer ohne Rechte | Unveröffentlichte Inhalte sehen |
| Editor | Datenpflege, neue Versionen, zum Review vorlegen |
| Veröffentlicher | Änderungen veröffentlichen, Änderungen vorschlagen |
| Administrator | Konzepte entsperren, Benutzeradministration, Datenimport und -export, Systemkonfiguration |

Ein normaler Besucher der Seite ist Gast. Nach dem Einloggen kann er ein Leser werden, der nur lesen darf und keinerlei sonstige weitere Berechtigungen hat. Ein Editor ist verantwortlich für die Datenpflege des Wortgutes und kann somit das Wortgut bearbeiten. Ein Match-Editor kann nur Konzepte bearbeiten, während der Veröffentlicher für die Kontrolle und Veröffentlichung der gemachten Änderungen verantwortlich ist. Der Administrator ist für die Konfiguration und Verwaltung des Systems verantwortlich, hat aber auch alle Rechte der anderen Rollen.

Der Bearbeitungsworkflow startet mit dem Erstellen oder Auschecken individueller Begriffe. Alle Änderungen sind hierbei unsichtbar für die Öffentlichkeit und nur für die Editoren, Veröffentlicher und Administratoren sichtbar. Beim Bearbeiten wird außerdem der Begriff dem Editor zugeordnet und für alle anderen gesperrt, so dass es keinerlei Bearbeitungskonflikte geben kann. Die Bearbeitung kann aber auch an einen anderen Editor abgegeben werden. Ein Konsistenzcheck stellt dabei die Qualität des Datensatzes sicher. Veröffentlicher können Änderungen veröffentlichen sowie verwerfen oder sie zur weiteren Bearbeitung empfehlen. Zusätzlich kann das Editorenteam auf einem Dashboard alle in Bearbeitung befindlichen Begriffe überblicken. Knapp zusammengefasst lässt sich der Workflow folgendermaßen visualisieren:

![iQvoc Redaktions-Workflow](../images/iqvoc-workflow.png)

### Erweiterungen

Die komplette iQvoc/UMT-Architektur basiert auf "Rails Engines", die es erlauben, eine Anwendung aus mehreren Teilanwendungen zusammenzustecken. Eine Rails Engine kann man sich als Miniaturanwendung vorstellen, die zusätzliche Funktionalität für die Hauptanwendung zur Verfügung stellt. Damit ist sie auch einem Plugin ähnlich. Mehr Details zu den Rails Engines finden sich in der Rails-Dokumentation.

Zur Zeit existieren diverse, i.d.R. öffentlich verfügbare Erweiterungen der Funktionen von iQvoc. Diese sind in Form von Rails-Engines implementiert. Zu den Erweiterungen zählen:

| Name | Beschreibung | URL |
|---|---|---|
| iqvoc_skosxl | Erweitert iQvoc um eine eigenständige Label-Entität und implementiert den SKOS-XL Standard des W3C. Label sind hierdurch eindeutig identifizierbar und es können dadurch auch Beziehungen zwischen verschiedenen Label abgebildet werden (z.B. Übersetzungsbeziehungen). | [https://github.com/innoq/iqvoc_skosxl](https://github.com/innoq/iqvoc_skosxl) |
| iqvoc_compound_forms | Erweitert iqvoc_skosxl um die Teil-Ganze-Beziehung auf Label-Basis (z.B. Label "Abbau von natürlichen Ressourcen" besteht aus dem Label "Abbau" und dem Label "Natürliche Ressource"). Die entsprechende Erweiterung ist auch von Bedeutung bei der automatischen Verschlagwortung durch Autoclassify. | [https://github.com/innoq/iqvoc_compound_forms](https://github.com/innoq/iqvoc_compound_forms) |
| iqvoc_inflectionals | Ermöglicht die Festlegung von alternativen Schreibweisen und Konjugationen von Label (z.B. bei Baum: Bäume, (des) Baumes). Durch die Erweiterung wird auch die Generierung von deutschen und englischen Schreibweisen auf Grundlage von Endungscodes unterstützt. | [https://github.com/innoq/iqvoc_inflectionsl](https://github.com/innoq/iqvoc_inflectionsl) |
| iqvoc_similar_terms | In dieser Erweiterung ist der Dienst zur Rückgabe von ähnlichen Begriffen zu einem Suchbegriff implementiert. | [https://github.com/innoq/iqvoc_similiar_terms](https://github.com/innoq/iqvoc_similiar_terms) |
| iqvoc_autoclassify | In dieser Erweiterung ist der Verschlagwortungsdienst des UMTHES implementiert. Die Erweiterung liefert passend zu einem Eingabetext (Text, URL) eine Liste von Begriffen aus dem UMTHES-Wortgut inklusive Scoring. | [https://github.com/innoq/iqvoc_autoclassify](https://github.com/innoq/iqvoc_autoclassify) |

Neben den Rails-Engine-Erweiterungen gibt es noch 2 RDF-Erweiterungen, die essentiell für iQvoc sind:

| Name | Beschreibung | URL |
|---|---|---|
| iq_triplestorage | Erlaubt die Interaktion mit RDF-Triple- und Quadstores in Ruby. | [https://github.com/innoq/iq_triplestorage](https://github.com/innoq/iq_triplestorage) |
| iq_rdf | Ermöglicht das Rendern von RDF mit dem Ruby on Rails Framework | [https://github.com/innoq/iq_rdf/](https://github.com/innoq/iq_rdf/) |

### Entwicklung

#### Repositories

Die schon genannten Erweiterungen stehen anders als der Source-Code der Fachanwendungen unter OSS und werden daher auch von anderen Entwicklern genutzt. Deshalb darf in den Erweiterungen kein anwendungsspezifischer Code (z.B. für den UMTHES) liegen, sondern die Klasse muss dann in der jeweiligen Fachanwendung erweitert werden. Gleichzeitig sollte aber allgemeine Funktionalität nicht in den Fachanwendungen implementiert werden, sondern über die OSS-Repositories der Allgemeinheit zur Verfügung gestellt werden.

Exemplarisch wird das anhand der `concept.rb` dargestellt. Die elementarste `iqvoc/app/models/concept/base.rb` befindet sich in iQvoc, wird aber dort direkt von der SKOS-Concept-Klasse erweitert. iQvoc-SKOS-XL erweitert dann die Konzept-Klasse wiederum, um die für SKOS-XL nötigen Änderungen einzupflegen, bevor das Konzept dann im UMTHES final definiert wird. Alternativ kann man jedoch auch eine Klasse komplett neu schreiben, wie es der UMTHES bei der `iqvoc_umt/app/models/umt_ability.rb` macht anstatt die `iqvoc/app/models/ability.rb` zu erweitern. Dann muss jedoch auch der iQvoc-Configeintrag angepasst werden, auf die im nächsten Abschnitt genauer eingegangen wird.

#### Einstellungen

Da iQvoc ein generisches, aus Erweiterungen zusammenbaubares Thesaurus-Framework ist, unterscheidet sich die Entwicklung von klassischen Ruby on Rails-Anwendungen. Prinzipiell kann jede iQvoc-Klasse individuell erweitert/überschrieben werden. Die Konfiguration von iQvoc dazu findet sich unter `config/initializers/iqvoc.rb`. Dort müssen die erweiterten Klassen eingetragen werden, damit sie auch von iQvoc genutzt werden. Die möglichen Einstellungen finden sich in `iqvoc/lib/iqvoc.rb` bzw. den dort referenzierten Klassen wie `iqvoc/lib/iqvoc/configuration/core.rb`. Im UMTHES werden die spezifischen Einstellungen in der `iqvoc_umt/config/initializers/iqvoc.rb` gesetzt.

```ruby
Iqvoc.config do |cfg|
  cfg.register_settings({
    # ...
    'available_languages' => ['de', 'en'],
    'languages.pref_labeling' => ['de'],
    'languages.notes' => ['de', 'en'],
    # ...
  })
end
```

Hier werden initial die Sprachen definiert, in denen das System und seine Entitäten verfügbar sind. Diese Einstellungen können über die Web-Oberfläche unter System überschrieben werden. Änderungen werden in der Datenbanktabelle `configuration_settings` gespeichert, die Vorrang vor der Konfigurationsdatei hat.

Falls man eine Standard-iQvoc-Datei erweitern muss, wie z.B. im Falle der `Concept::UMT::Base`, um eine Validierung hinzuzufügen, kann man entweder die Datei aus iQvoc kopieren oder erweitern, muss die Datei aber auch in der `iqvoc.rb` mit `Iqvoc::Concept.base_class_name = 'Concept::UMT::Base'` eintragen. Anstelle der konkreten Klasse nutzt man deshalb im Code also `Iqvoc::Concept.base_class` um Methoden auf den Konzepten aufzurufen, um bei einer Erweiterung nicht alle Klassennamen ändern zu müssen. Das funktioniert analog auch für alle anderen Klassen, bspw. für die Label- oder Ability-Klasse.

Weiterhin kann man über `Iqvoc::Entity.view_sections` (bspw. Concept/XLLabel) die angezeigten Tabs in den jeweiligen Entitätsansichten dort definieren. `Iqvoc.searchable_class_names` definiert die in der Suche benutzbaren Entitäten. Da dadurch manchmal unklar werden kann, wo eine Information gerendert wird, wird in der im Development Mode gestarteten Umgebung der Pfad zu der View-Datei in den Seitenquelltext gerendert:

```erb
<!-- Partial: /Users/dev/.rbenv/versions/2.5.5/lib/ruby/gems/2.5.0/bundler/gems/sns_theme-5087ffabdcf0/app/views/layouts/_navigation.html.erb -->
```

Generell werden die gerenderten Partials dynamisch in den jeweiligen Modelklassen definiert, beispielhaft anhand `app/models/concept/base.rb` aus iQvoc demonstriert:

```ruby
# app/models/concept/base.rb
def self.inline_partial_name
  'partials/concept/inline_base'
end

def self.new_link_partial_name
  'partials/concept/new_link_base'
end

def self.edit_link_partial_name
  'partials/concept/edit_link_base'
end

def self.dashboard_path
  'dashboard_path'
end
```

Diese Methoden können dann in einer Erweiterungsklasse einfach überschrieben werden.

## Styleguide

SNS besteht aus drei völlig autonomen Anwendungen. Das visuelle Erscheinungsbild der Anwendungen ist weitestgehend identisch, sodass für Benutzer der Wechsel zwischen den Anwendungen nicht als visueller Bruch anmutet. Erreicht wird dies durch einen einheitlichen Styleguide, welcher isoliert entwickelt wird und von jeder Anwendung verwendet wird.

Der Quellcode des UBA-Styleguides den SNS verwendet ist hier verfügbar: [https://github.com/innoq/uba-bootstrap-theme](https://github.com/innoq/uba-bootstrap-theme)

Technisch basiert der Styleguide auf Bootstrap 5. Der Styleguide wird von jeder Anwendung als NPM-Dependency in der Datei `package.json` referenziert. Die jeweilige Anwendung zieht die zentralen Assets (Stylesheets, Javascript, Bilder und Schriften) zur Build-Zeit während des Deployments an. Es ist also möglich, dass die Anwendungen auf verschiedenen Versionen des zentralen Styleguides basieren. Zusätzlich zu den zentralen Assets definieren die Anwendungen auch spezifische Stylesheets und Javascript-Funktionen.

Bei Aktualisierung der verwendeten Bootstrap-Version muss als erstes der zentrale Styleguide aktualisiert werden. Anschließend muss ggf. das HTML-Markup aller iQvoc-Anwendungen auf die neue Version angepasst werden.

## Semantik Web Grundlagen

### Semantic Web

Das Internet ist heutzutage allgegenwärtig und aus dem Alltag nicht mehr wegzudenken. Das World Wide Web (WWW) hat ganze Industriezweige verändert sowie neue Geschäftsmodelle erschaffen. Damit wird das Web zum Symbol für die Entwicklung von der Industrie- zur Informationsgesellschaft.

Das Internet ist zum größten Teil für den Menschen geschaffen. Inhalte von Internetseiten können von Maschinen zwar erfasst werden (z.B. durch Suchmaschinen), eine echte Erfassung des Kontextes sowie des Verständnis der Bedeutung ist für Maschinen aber nur bedingt möglich. Ein sowohl für Menschen als auch für Maschinen verständliches Netz, in dem Waren und Dienste vermittelt und Fragen verstanden sowie automatisch beantwortet werden können, wird als nächste Evolutionsstufe des Internets bezeichnet.

Hierzu existieren zwei Ansätze. Der erste Ansatz basiert auf Methoden der künstlichen Intelligenz, die darauf abzielen, die kognitive Wahrnehmung des Menschen auf Maschinen zu übertragen.

Ein orthogonaler Ansatz ist der des Semantic Web. Ziel ist hierbei, Inhalte für eine optimierte Verarbeitung durch Maschinen bereitzustellen. Dies impliziert eine formale Auszeichnung von Wissen. Das Semantic Web verlangt die Verlagerung des verteilten Netzes von der Präsentationsebene zur Datenebene. Demnach müssen Inhalte zukünftig auf Datenebene miteinander verbunden werden, um eine optimierte Informationsverarbeitung zu gewährleisten.

Das Semantic Web ist ein sehr großes Themenfeld und reicht von Themen wie Linked Open Data bis hin zu Fragestellungen der Künstlichen Intelligenz.

### Linked Open Data (LOD)

Linked Open Data ist eine Community-Bestrebung zur Veröffentlichung von großen Datensätzen. Linked Open Data definiert Regeln und Best Practices, um Daten auf Grundlage von Web-Standards zu veröffentlichen und mit Hilfe semantischer Technologien in Beziehung zu setzen. Der Begriff "offen" hat in diesem Zusammenhang zwei Bedeutungen: Daten sollen zum einen frei zugänglich sein und zum anderen ausschließlich über offene Standards veröffentlicht werden. Linked Open Data geht auf das Jahr 2006 zurück. Tim Berners-Lee veröffentlichte in diesem Jahr den Artikel *Design Issues: Linked Data*. Aus diesem Artikel ergeben sich folgende Grundprinzipien:

1. Verwende URIs, um Dinge zu identifizieren
2. Verwende HTTP URIs, um auf diese Dinge zugreifen zu können
3. URIs sollten auf nützliche Informationen verweisen, welche mit den Standards RDF und SPARQL bereitgestellt werden
4. Verwende Verweise auf andere URIs, sodass weiteres Wissen erreichbar wird

Linked Open Data ist auf die Nutzung offener Standards ausgelegt und baut auf der technischen Architektur des Internets auf. Das erste Prinzip besagt, dass ausschließlich URIs zur Identifikation von Ressourcen genutzt werden. Hiermit werden neben Web-Ressourcen und echten Objekten wie Personen auch abstrakte Dinge wie Beziehungen und Beschreibungen von und zwischen Objekten verstanden.

Das zweite Prinzip beschreibt die Auflösung von URIs über das Hypertext Transfer Protokoll (HTTP). Hierdurch können Konzepte über physische Grenzen hinweg referenziert werden. Neben Menschen kommen auch Maschinen wie Web-Crawler als Adressat in Frage. Hierfür beinhaltet die HTTP-Spezifikation mit Content Negotiation eine technische Umsetzung. Ein Webserver kann je nach anfragendem Client mit einer für Menschen optimierten HTML- bzw. einer maschinenlesbaren RDF-Repräsentation antworten.

Das dritte Prinzip definiert die Nutzung standardisierter Datenformate. Während HTML das bevorzugte Datenformat für von Menschen lesbare Dokumente ist, beschreibt dieses Prinzip die Nutzung von RDF. RDF erlaubt die formale Auszeichnung von jeglichen Inhalten und unterstützt die automatische Verarbeitung durch Maschinen.

Das vierte Prinzip beschreibt die Nutzung von Hyperlinks zur Verbindung von Daten. Im Linked Data Kontext werden diese Hyperlinks RDF-Links genannt. Diese RDF-Links haben im Vergleich zu klassischen Hyperlinks neben dem Verweis auch eine getypte, semantische Bedeutung. Ein RDF-Link zwischen einer Person und einer Zeichenkette kann beispielsweise beschreiben, dass es sich bei der folgenden Zeichenkette um eine Email-Adresse handelt.

### Resource Description Framework (RDF)

#### Model

Das Resource Description Framework (RDF) ist ein graphen-orientiertes Datenmodell zur Beschreibung beliebiger Dinge in Form von Ressourcen. RDF bietet eine formale Sprache für den Wissens- bzw. Informationsaustausch. Dinge bzw. Ressourcen werden per Uniform Resource Identifier (URI) identifiziert und mit Hilfe von Eigenschaften und konkreten Ausprägungen beschrieben. Jede RDF-Aussage ist in Form eines Tripels modelliert und besteht aus Subjekt, Prädikat und Objekt.

![RDF-Modell](../images/rdf-model.png)

Subjekt, Prädikat und Objekt werden durch URIs referenziert. Das Objekt kann wahlweise auch durch ein String-Literal mit optionalem Datentyp repräsentiert werden. Das Prädikat beschreibt die semantische Beziehung zwischen Subjekt und Objekt.

RDF verfolgt einen datengetriebenen Ansatz, d.h. es sind keine Klassen notwendig, um Instanzen zu bilden. Dieser Ansatz macht RDF sehr flexibel. RDF besteht aus dem RDF-Modell und der konkreten Syntax zur Serialisierung. Das RDF-Modell beinhaltet die Menge aller Tripel, bestehend aus Subjekten, Prädikaten und Objekten und spannt den Graphen auf. Mit RDF lässt sich aber keine Semantik ausdrücken, da lediglich Beziehungen zwischen Dingen hergestellt werden. Die semantische Beschreibung von Objekten und Beziehungen erfolgt über Ontologien. Ontologien nehmen bei der Verwendung die Rolle eines Vokabulars ein. Ein Vokabular bezeichnet im RDF-Kontext eine Menge von Bezeichnern für Individuen, Beziehungen und Klassen.

#### Serialisierung

RDF-Graphen lassen sich in mehrere Datenformate serialisieren. Der folgende Abschnitt thematisiert gängige RDF-Serialisierungen wie RDF/XML und die Terse RDF Query Language (Turtle).

Die konkrete Syntax soll anhand des folgenden Beispiels erläutert werden.

![RDF-Serialisierung Beispiel](../images/rdf-serialialisierung-example.png)

Das Beispiel zeigt die Modellierung der Person Max Mustermann durch Nutzung des Friend of a Friend (FOAF)-Vokabulars. Neben Vor- und Nachname wird ebenfalls eine Email-Adresse modelliert. Die Ovale dieser graphischen Notation beschreiben andere Ressourcen. Rechtecke visualisieren String-Literale.

##### RDF/XML

Eine weit verbreitete Art der RDF-Serialisierung ist RDF/XML. Dieses Serialisierungsformat nutzt die Extensible Markup Language (XML) als Meta-Sprache. Die Kodierung von Tripeln erfolgt hierarchisch. Durch die Flexibilität der XML-Meta-Sprache können RDF-Graphen auf verschiedene Weisen in RDF/XML serialisiert werden. Ein Vorteil dieser Serialisierung ist die weite Verbreitung und Akzeptanz von XML. Es existieren für nahezu jede Programmiersprache entsprechende Bibliotheken zur XML-Verarbeitung. Im Gegensatz zu moderneren Serialisierungsformaten ist RDF/XML für den Menschen schwerer lesbar.

Das oben genannte Beispiel würde in RDF/XML folgendermaßen serialisiert:

```xml
<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:foaf="http://xmlns.com/foaf/0.1/" xmlns="http://www.example.org/max/contact.rdf#">
  <foaf:Person rdf:about="http://www.example.org/max/contact.rdf#maxmustermann">
    <foaf:mbox rdf:resource="mailto:max.mustermann@example.org"/>
    <foaf:family_name>Mustermann</foaf:family_name>
    <foaf:givenname>Max</foaf:givenname>
  </foaf:Person>
</rdf:RDF>
```

Innerhalb des Wurzel-Knotens werden Namensräume durch Präfixe ersetzt. Präfixe erlauben eine kompaktere Syntax und tragen zur Lesbarkeit bei. Alle Tripel die eine FOAF-Klasse als Subjekt nutzen, werden hierarchisch in einem FOAF-Person-Element gruppiert.

##### Terse RDF Query Language (Turtle)

Turtle ist eine alternative RDF-Syntax, die den Schwerpunkt auf Lesbarkeit legt. Turtle geht auf eine Vereinfachung der durch Tim Berners-Lee 1998 vorgeschlagenen Notation 3 (N3) zurück.

N3 schreibt Tripel ebenfalls in beliebiger Reihenfolge hintereinander und enthält Operatoren für komplexere Ausdrücke wie Pfade und Regeln. Die Formate N-Triples und Turtle haben sich aus N3 entwickelt. N-Triples verzichten auf die zuvor erwähnten komplexeren Ausdrücke der N3-Syntax und beschränken sich auf die Beschreibung von RDF-Graphen. Die N-Triple-Serialisierung wurde im Anschluss um eine Kurzschreibweise erweitert und führte zur heute weit verbreiteten Turtle-Syntax.

Das oben genannte Beispiel stellt sich in Turtle folgendermaßen dar:

```turtle
@prefix foaf: <http://xmlns.com/foaf/0.1/> .
@prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
@prefix : <http://www.example.org/max/contact.rdf#> .

:maxmustermann a foaf:Person ;
  foaf:givenname "Max" ;
  foaf:family_name "Mustermann" ;
  foaf:mbox <mailto:max.mustermann@example.org> .
```

In Zeile 1-3 werden analog zur XML-Serialisierung Präfixe für eine kompaktere Schreibweise definiert. Der Punkt beendet die Sequenz eines RDF-Tripels. Die Turtle-Serialisierung beinhaltet einige Kurzschreibweisen. So kürzt ein `a` anstelle eines Prädikates das oft genutzte `rdf:type` ab. Durch das Semikolon beziehen sich die folgenden Prädikat/Objekt-Kombinationen auf das gleiche Subjekt. Die Prädikat/Objekt-Kombinationen aus Zeile 6-8 beziehen sich somit alle auf das Subjekt `:maxmustermann` aus Zeile 5.

### Simple Knowledge Organization System (SKOS)

Das Simple Knowledge Organization System (SKOS) ist ein W3C-Standard für die Wissensrepräsentation. SKOS bietet eine auf RDFS und OWL basierende formale Sprache für die Definition von Vokabularen, Taxonomien und Thesauri.

Während die Wissensrepräsentation innerhalb von Knowledge Organization System (KOS) seit geraumer Zeit praktiziert wird, ist die Verarbeitung sowie der Austausch innerhalb von Computernetzwerken noch nicht alltäglich. Zu diesem Zweck wurde SKOS entwickelt. SKOS basiert auf den Grundideen des Semantic Webs und sollte fortan die Modellierung von wiederverwendbaren Wissensrepräsentationen über das Internet unterstützen. Ein weiteres Kriterium bei der Entwicklung von SKOS war die einfache Transformation aus einem anderen Thesaurus-Standard.

Die SKOS-Spezifikation definiert semantische Beziehungen zur Definition von Hierarchien, Assoziationen und Verknüpfungen. Die Abbildung visualisiert die semantischen Beziehungen der Spezifikation:

![SKOS Semantische Beziehungen](../images/skos-semantic-relation.png)

Gerichtete Pfeile symbolisieren die `rdfs:subPropertyOf`-Beziehung. Auf oberster Ebene sind `skos:broaderTransitive`, `skos:narrowerTransitive`, `skos:mappingRelation` und `skos:related` als Sub-Typen von `skos:semanticRelation` definiert. Die Beziehung zwischen `skos:broaderTransitive` und `skos:narrowerTransitive` steht für `owl:inverseOf` aus der OWL-Spezifikation. Die Beziehung beschreibt die gegenteilige semantische Bedeutung zwischen den Elementen. Das Wissen über die Bedeutung solcher Beziehungen kann für die Bildung von Inferenzen genutzt werden.

Für diese Ausarbeitung sind die semantischen Beziehungen `skos:broaderTransitive` und `skos:narrowerTransitive` sowie deren jeweils direkt zugeordneter Sub-Typ relevant. Mit `skos:narrower` werden spezielle Typen von Entitäten modelliert (z.B. Laptop `skos:narrower` Computer). Die `skos:broader`-Beziehung beschreibt die gegenteilige Beziehung (Computer `skos:broader` Laptop).

## Anforderungen an einen Betriebsdienstleister

### Architektur und Skalierung

Die SNS-Anwendungen sollten auf einer eigenen virtuellen oder physischen Maschine deployed und betrieben werden. Die drei Anwendungen laufen alle als Docker-Container auf einer Container-Plattform. Die Datenhaltung muss logisch getrennt in einer eigenen Datenbank realisiert werden (die Datenbanken können auf einem gemeinsamen Datenbank-Host betrieben werden).

Vor den Anwendungen agiert ein Web-Server als Reverse-Proxy, der die Verteilung auf die jeweilige Anwendung übernimmt. Jede Anwendung wird von einer variablen Anzahl an Passenger-Worker-Prozessen betrieben (Passenger ist ein Ruby-Applikationsserver).

![SNS Architektur](../images/sns-architektur.png)

#### Software

* **Betriebssystem**: Als Server-Betriebssystem empfehlen wir die jeweils aktuelle Version von Ubuntu in der LTS-Version (Long Term Support).
* **Ruby**: Ruby (MRI) in der jeweils aktuellen Version (mindestens 3.0)
* **Datenbank**: Das SNS-System benötigt unterschiedliche Datenbankmanagementsysteme. Der Umweltthesaurus und die Umweltchronik basieren auf PostgreSQL.

#### Hardware

Die Hardware-Anforderungen gelten pro Maschine/VM:

* **CPU**: 8 Kerne, 64-Bit
* **RAM**: mindestens 16 GB RAM
* **Festplattenspeicher**: mindestens 80 GB, vorzugsweise SSDs

#### Monitoring

Alle Instanzen sollten durch den Dienstleister automatisiert überwacht werden. Das umfasst Standardmesswerte wie bspw. CPU-, RAM- und I/O-Auslastung als auch das Aufrechterhalten von applikationskritischen Prozessen. Hierzu gehören:

* Webserver
* Applikationsserver
* Datenbankserver

#### Backup

Es muss ein tägliches automatisches Backup der System- und Applikationsdatenbanken erfolgen. Den Entwicklern muss die Möglichkeit gegeben werden, Backup-Prozesse (Manuelles Auslösen, Wiederherstellen etc.) selbständig oder auf Ticket-Basis zu verwalten und anzufordern.

#### Deployment und Wartung

Für das Deployment von Anwendungssourcen sowie Wartungsaufgaben ist den Entwicklern ein vollwertiger SSH-Zugang über einen separaten Benutzer bereitzustellen, root-Rechte sind dazu nicht nötig. Die Entwickler müssen die Möglichkeit haben, selbständig:

* den Webserver und Docker-Container neu zu starten
* Jobs im Kontext des Anwendungsverzeichnisses auszuführen
* sich als jew. Anwendungsuser gegen die Datenbankkonsole zu verbinden

Der Datenbankbenutzer benötigt neben den normalen Lese-, Schreib- und Löschoperationen außerdem Berechtigungen, Schemaänderungen durchzuführen.

### Anforderungen an Dienstleister Wartung/Weiterentwicklung

Ein vom UBA auszuwählender, neuer SNS-Dienstleister bekommt sowohl den aktuellen Source-Code von SNS als auch eine Dokumentation von SNS zur Verfügung gestellt. Möglicherweise sind auch Einführungsworkshop(s) möglich/nötig.

#### Technologien

##### Must-have

* Langjährige Erfahrung in Software-Entwicklung und -Wartung
* Git und GitHub
* SQL, PostgreSQL und ActiveRecord
* Ruby on Rails
* Web-Technologien, insbesondere HTML und CSS
* JavaScript
* Rails-Hosting/Deployment

##### Should-have

* RDF
* Semantic Web Standards
* SKOS (https://www.w3.org/TR/skos-primer/)
* Rails Engines
* Linked Data

##### Nice-to-have

* Thesaurus/Vokabular Management Systeme
* iQvoc (http://iqvoc.net/)

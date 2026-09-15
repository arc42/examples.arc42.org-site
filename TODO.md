# TODO

## UBA-SNS translation: open vocabulary questions

The German originals live in `_systems/UBA-SNS/_originals/`. The English
translation made these choices; each line lists the chosen term first and the
alternatives that were considered. Decide, then apply the decision across all
twelve sections plus `index.md`.

- Verschlagwortung: chose "automatic keyword assignment". Alternatives:
  subject indexing (the library science term), tagging, keywording. The
  AutoClassify service assigns UMTHES descriptors to documents, so "descriptor
  assignment" would be most precise but least accessible.
- Umweltchronik: chose "Environmental Chronicle" as a proper name.
  Alternatives: environmental chronicle (lower case, generic), chronicle of
  environmental events.
- Verfahrensbetreuung (role in the participants table of section 01): chose
  "system stewardship". Alternatives: process ownership, application
  ownership, subject matter responsibility. No established English equivalent
  for this German public administration role.
- Begriff: "concept" where SKOS-technical, "term" where colloquial. SKOS
  distinguishes concepts from their labels, and the German text uses one word
  for both. Worth a pass by someone who knows the UMTHES editorial practice.
- Fachanwendungen: chose "specialist applications". Alternatives: domain
  applications, professional applications.
- Umweltbundesamt: rendered as "German Environment Agency (Umweltbundesamt,
  UBA)" on first mention per page, then "UBA". This is the agency's own
  official English name; confirm it matches how the UBA wants to be cited.
- The `domain:` value on the tile is "Environmental information". If the
  domain vocabulary is ever closed (see DESIGN.md, "Open decision: colour on
  tiles"), decide whether this term or a broader "public sector" carries the
  category.

Raised during the translation pass over sections 01 to 12:

- German data stays German, as a policy: descriptor titles (Seeschifffahrt,
  Wattenmeer), example search terms (Biosprit, Biokraftstoff), compound form
  labels and the article text in the AutoClassify walkthrough are data the
  system processes, not prose, and they match the linked German records.
  Confirm this policy or ask for English glosses in parentheses.
- Chronik as a subsystem name next to UMTHES and Portal: translated as
  "Chronicle". Alternative: keep the proper name "Chronik" untranslated the
  way UMTHES is kept.
- Zusammengesetzt-In-Zusammensetzungen (section 06): rendered literally as
  "compound-in compositions"; the source term itself is unclear. Someone who
  knows the UMTHES editorial model should name this relation.
- Wortgut (section 06): chose "text corpus". Alternatives: vocabulary, text.
- Zugangsvokabular: chose "access vocabulary". Alternatives: entry
  vocabulary, lookup vocabulary.
- Betriebsdienstleister (section 08): chose "operations provider".
  Alternatives: hosting provider, operations service provider.
- Datenhaltung vs. Datenbestand (section 08): "data storage" for the act,
  "data holdings" for the stock. Confirm the distinction reads correctly.
- The source expands Turtle as "Terse RDF Query Language"; the correct
  expansion is "Terse RDF Triple Language". The translation preserved the
  source's wording rather than silently correcting it. Decide whether to fix
  it with a translator's note.
- UBA-Bootstrap theme (section 11): rendered with the agency name expanded.
  Alternative: treat "UBA Bootstrap theme" as a compound product name and
  leave UBA unexpanded there.

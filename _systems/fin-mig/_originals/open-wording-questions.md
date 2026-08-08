# Open wording questions — M&M data migration

Raised while translating `Datenmigration-M+M.docx` (German) into the English
arc42 files in `_systems/fin-mig/`. Everything here is a **decision I made that
you may want to overrule**, not a blocker: the twelve section files are complete
and consistent with the choices below.

This file lives in `_originals/` and is excluded from the build, so it never
ships.

---

## P — Provenance (the one that is not about wording)

**P1. What licence covers this text?**
`index.md` deliberately carries **no `licence:` field**, unlike `mama` and
`htmlsc`. Those two are CC BY-SA 4.0 because their source is *arc42 by example*
on Leanpub, confirmed by you on 2026-08-07. This chapter comes from *Effektive
Softwarearchitekturen* (Hanser) instead, and a Hanser book chapter is not
automatically yours to relicense. `source_url` is currently set to
`https://esabuch.de`.

*Needed:* the licence to state, and the URL the "Original" link should point at.
Until then the overview page says who wrote it and where it came from, and
claims nothing further.

---

## A — Names and jokes that do not survive translation

**A1. "Fies und Teuer AG"** — the fictional client. In German this is a joke:
*fies* = nasty/mean, *teuer* = expensive. I **kept the German name** everywhere
and added a footnote in section 1 glossing it, so the joke is available to an
English reader without renaming a company that appears in every diagram and
about thirty times in the text.

*Alternative:* translate it — "Nasty & Pricey plc", "Grasp & Gouge Ltd" — and
retitle it consistently, including in the diagrams. Cheaper to do now than later.

**A2. "M&M" and its expansion.** M&M = *Migration von **M**assendaten*. The
initials only work in German. I kept **M&M** as the system name and translated
the expansion as "migration of mass data", noting the German in a footnote.

**A3. "VSAM ist grausam"** ("VSAM is gruesome") — a rhyming German quip in
footnote 3 of the original. I kept it in German with a translation, because the
rhyme is the whole point.

**A4. "KOUSYNE"** — appears once, unexplained, as the project that produced the
target object model. I added a footnote identifying it as the parallel project,
which is what the surrounding text implies. Confirm that reading, or tell me
what the acronym stood for.

---

## B — Recurring domain vocabulary (one choice, applied everywhere)

These are the words that appear over and over. Each one is translated
consistently throughout; changing your mind about one means one search-and-
replace, not a re-read.

| German | My choice | Alternatives considered | Note |
|---|---|---|---|
| *fachlich* | **business** ("business rules", "business context", "the business migration step") | domain-level, functional, professional | The hardest word in the document. "Business" reads naturally in every one of its ~20 occurrences; "domain" would collide with arc42's own use of the word. |
| *Buchung* | **posting** | booking, transaction, entry | Banking English. See B1 below for the one place this gets sharp. |
| *Bewegungsdaten* | **transaction data** | movement data | |
| *Stammdaten* | **master data** | base data | Standard. |
| *Satz* / *Datensatz* | **record** | data set | |
| *Satzart* | **record type** | record layout, record kind | Used as "FT record type 43". |
| *Fehlersatz* | **error record** | reject, failed record | "Reject" is the more idiomatic ETL word; "error record" tracks the German and matches "error database". |
| *Band* / *Bänder* | **tape** / **tapes** | reel, cartridge | LTO-1 cartridges, really, but the original says *Bänder* throughout. |
| *Sachbearbeiter* | **clerk** | case worker, back-office staff, agent | Appears twice (sections 1 and 8.3). "Clerk" is short and reads well in "a clerk can migrate 25 persons per day". |
| *Auftraggeber* | **client** | customer, contracting organization, principal | Note the original uses *Auftraggeber* and *Kunde* in the same decision table (see C2). |
| *revisionssicher* | **audit-proof** | audit-compliant, tamper-evident, legally verifiable | German compliance term with no exact English equivalent. |
| *Ablaufsteuerung* | **process control** (section 8.2 heading) | flow control, orchestration, scheduling | "Orchestration" is the modern word but is anachronistic for 2003. |
| *nichtnatürliche Person* | **non-natural person**, glossed as *legal entity* on first use | juridical person, legal person | Kept literal because the original explicitly contrasts *natürlich* / *nichtnatürlich* and the Person Mapper turns on the distinction. |
| *Verband* | **association** | federation, umbrella organization | Appears alongside *Verein* (club). |
| *Leistungsmerkmale* | **performance characteristics** | features, service characteristics | A blackbox-template field label. |
| *Ablageort/Datei* | **location / file** | storage location | Blackbox-template field label. |
| *Offene Punkte* | **open issues** | open points, TODOs | Blackbox-template field label. |
| *\<entfällt\>* | **not applicable** | omitted, n/a, — | |
| *\<Entfällt im Beispiel\>* | **"omitted in this example"** | not covered here | |

**B1. "Hin- oder Rückbuchung"** (section 11, the bit-4 example). Literally
"outward or return posting". I translated it as **"a posting or a reversal"**,
which is what the pair means in accounting. If it meant *debit or credit* in the
original system, the sentence should say so instead — it changes what the example
is demonstrating.

**B2. "Tarifklasse T13" → "Jährliche Zahlung ohne Skonto"**. I rendered *Skonto*
as **early-payment discount**, which is the standard English gloss. "Cash
discount" is the other common one. The full new tariff-class name reads "annual
payment without early-payment discount".

**B3. "Empfangsberechtigte"** (address data) → **authorized recipients**.
"Authorized representatives" would be a different meaning; the surrounding
context is postal addresses, so "recipients" is the reading I took.

**B4. "Gegenkonto"** → **contra account**. "Counter account" and "offset account"
are also current. The original pairs it with *Referenzkonto* (reference account).

**B5. "Einpersonengesellschaft" / "Mehrpersonengesellschaft"** →
**single-member company** / **multi-member company**. UK company-law wording. US
English would more likely say "sole-member" and "multi-member" LLC, but the
system is German so I stayed closer to the German construction.

**B6. "Vormunde und Pflegeeltern"** → **legal guardians and foster parents**.

**B7. "Nachweispflichten"** (in the closing notes) → **requirements for proof and
record-keeping**. A single English noun does not exist; "evidentiary obligations"
is the legal register but reads oddly in a project narrative.

**B8. "verklausuliert"** (section 11, describing how attributes were hidden by
storage optimizations) → **obfuscated**. The German is more like "wrapped in
convoluted provisos"; "obfuscated" is what a developer would actually say.

**B9. "Überstrukturierung"** (section 5.2.1) → **over-structuring**. I considered
"over-engineering", which is the phrase in current use, but the original is
specifically about splitting a building block into too many parts, which
"over-structuring" says and "over-engineering" does not.

**B10. "Benutzt-Beziehungen"** (section 5.2.1) → ***uses* relationships**, in
italics, since it is naming a UML dependency stereotype.

---

## C — Places where the original is unclear, wrong, or inconsistent

I made a call on each of these and flagged it in the shipped text with a
footnote. Say the word and I will change the call or drop the footnote.

**C1. The "5000 (= 20 * 25)" arithmetic, section 8.3.** The text says 200
person-days are available, that a clerk manages 25 persons a day, and therefore
that the error table may hold at most "5000 (= 20 * 25)". 20 × 25 is 500, not
5000; 200 × 25 is 5000. I treated **200 × 25 = 5000** as the intended sum and
noted the typo in a footnote. The alternative reading — that the limit is really
500 — would change a stated quality constraint, so I did not assume it.

**C2. Two different deciders for the same kind of thing, section 9.** The
decision table names *Auftraggeber* (client) for the dual-server decision and
*PL, Kunde* (project manager, customer) for the parallel rule processing. Client
and customer are presumably the same party. I translated both literally and
recorded the German in a footnote rather than harmonizing them.

**C3. "Leserkreis" names the wrong system, section 1.** The intended-audience
list says "all stakeholders of **MaMa** named in section 1.3 of this
documentation". MaMa is a *different* example in the same book. I translated it
as M&M and footnoted the discrepancy.

**C4. Sections 5.1.5 and 5.1.6.** The original heads 5.1.5 "Packager" and its
entire body is "See Rule Processor in the following section", where 5.1.6 is
"Rule Processor (and Packager)". I reproduced this faithfully. It is a small
documentation smell worth either fixing or leaving as a deliberate example of
one.

**C5. Figure 12.6 has a broken cross-reference in the source.** Its caption
renders as "Abbildung **Fehler! Kein Text mit angegebener Formatvorlage im
Dokument.**.6" — a Word field that failed to resolve. The intended caption is
"Figure 12.6 Internal structure of the Rule Processor".

**C6. Section numbering was remapped to current arc42.** The original uses an
older numbering: its section 11 is *Qualitätsszenarien*, 12 is *Risiken*, 13 is
*Glossar und Referenzen*. These became arc42 **10** (Quality Requirements), **11**
(Risks and Technical Debt) and **12** (Glossary). Sections 1–9 map straight
across. The original has no section 10 at all.

**C7. The closing "Anmerkungen zum System" had nowhere to go.** It is an
afterword about the real project, not an arc42 section. I split it: the framing
("this really happened, the client was called something else") went into
`index.md`, and the three concrete stumbling blocks went into
`11-risks-and-technical-debt.md`, which the original leaves empty. Section 11
says plainly where they came from. If you would rather section 11 stay empty and
honest, moving them back is one cut-and-paste.

**C8. Section 12 has a glossary that the original does not.** The original says
the glossary is omitted. I wrote one from terms already used in the text (EBCDIC,
VSAM, LTO-1, record type, segment, package, error record …) because a reader who
has never touched a mainframe cannot follow section 5 without it. Every entry is
derived from the document itself; nothing is invented. Delete it if you want the
example to preserve the original's gaps exactly.

**C9. The level-1 diagram sends every error to the *migration* database.** In
figure 12.4 the five error flows (*Konv-*, *Seg-*, *Pack-*, *Rule-*,
*Target-Fehler*) all point at the box labelled *Migrationsdatenbank*. The prose
in sections 3, 4 and 8.3 says errors go to the **error** database
(*Fehlerdatenbank* / *Fehlertabelle*), which section 3 explicitly calls an
internal interface. I redrew the figure faithfully, keeping "migration
database", on the assumption that the error tables live inside it. If they are
meant to be two separate stores, the redrawn figure needs a sixth box.

---

## D — Diagrams

The eight figures are embedded in the `.docx` as Windows metafiles — seven WMF,
one true EMF — and all of their labels are **in German**. Two of them also exist
as JPEGs in `_originals/images/` (figures 12.2 and 12.4).

**All eight have been redrawn in English** and all eight ship. Nothing from the
2007-era rasters is reused; every figure is regenerated from source that lives in
`_originals/diagrams-src/` and can be edited and re-rendered:

| Original | Now | Source | Rendered with |
|---|---|---|---|
| Fig. 12.1 | `images/01-purpose-of-the-system.png` | `01-purpose.dot` | graphviz |
| Fig. 12.2 | `images/03-business-context.png` | `03-context.dot` | graphviz |
| Fig. 12.3 | `images/03-deployment-context.png` | `03-deployment-context.dot` | graphviz |
| Fig. 12.4 | `images/05-building-block-level-1.png` | `05-bb1.dot` | graphviz |
| Fig. 12.5 | `images/05-vsam-reader-whitebox.png` | `05-vsam-reader.dot` | graphviz |
| Fig. 12.6 | `images/05-rule-processor-whitebox.png` | `05-rule-processor.dot` | graphviz |
| Fig. 12.7 | `images/06-runtime-load-phase.png` **and** `images/06-runtime-migrate-phase.png` | `06-runtime.py` → two `.svg` | hand-written SVG |
| Fig. 12.8 | `images/07-deployment-view.png` | `07-deployment.dot` | graphviz |

Re-render with `dot -Tpng -Gdpi=150 X.dot -o X.png`, or for the sequence diagrams
`python3 06-runtime.py && rsvg-convert -z 1.9 06-runtime-N.svg -o 06-runtime-N.png`.

**D0. Figure 12.7 became two figures, and figure 12.8 was re-laid-out — because
of the column width.** `.ex-prose` caps prose at `--measure` (68ch ≈ 636px) and
`img { max-width: 100% }` caps diagrams at the same 636px, so a figure's on-screen
label size is set by its *aspect*, not by the dpi it was rendered at: roughly
`font-pt × 636 / diagram-width-pt`. The original's seven-lifeline sequence
diagram lands at about **8px** in that column, and my first LR deployment layout
at about 8px too. Splitting the sequence diagram into a load phase (4 lifelines)
and a migrate phase (5 lifelines) gets them to ~12px and ~10px; stacking the
deployment nodes in two columns instead of four gets that one to ~16px.

Worth knowing, and your call: the comment above the `img` rule in
`_sass/_content.scss` says *"Diagrams are the point of an architecture
documentation, so they may take the wider ceiling"* — but the rule underneath it
is `max-width: 100%`, inside a container capped at `--measure`. The wider ceiling
is never actually granted; `pre` and `table` declare `max-width:
var(--measure-wide)` and are equally capped for the same reason. Either the
comment is wrong or the CSS is. Fixing it would let every example's diagrams
grow to ~1085px, which would also help mama and htmlsc. I did not touch shared
CSS for this import.

**Where the redrawn figures do not match the originals exactly.** They are UML-ish
box-and-line drawings, not tracings. Boxes, labels and connectors are faithful;
layout, the UML package and node glyphs, and the small "Legende" panels are not
reproduced — a legend explaining that a rectangle is a component earns its space
on paper, less so on a web page where the surrounding section says the same
thing. Say the word if you want the legends back.

**Label choices, applied across all eight** — *(altes) Mainframe-System* →
"(legacy) mainframe system", *Nachbarsystem* → "neighbouring system",
*Datenfluss* → "data flow", *Komponente (Blackbox)* → "component (blackbox)",
*externes System* → "external system", *Abhängigkeit* → "dependency", *liest* →
"reads", *schreibt* → "writes", *ruft auf* → "calls", *uebergibt* → "hands
over", *Konv-/Seg-/Pack-/Rule-/Target-Fehler* → "conversion / segmentation /
packaging / rule / target errors", *4 Bänder* → "4 tapes", *Bandlaufwerke* →
"tape drives", *Zielsystem* → "target system", *Zieldatenbank* → "target
database", *Migrationsdatenbank* → "migration database", *Nat/NichtNat Person
Reader/Mapper* → "Natural / Non-natural Person Reader / Mapper", *Ehegatten
Mapper* → "Spouse Mapper", *Konto Reader/Mapper* → "Account Reader / Mapper",
*Bankdaten Reader/Mapper* → "Bank Data Reader / Mapper", *phys. Kanal* → "phys.
channel", *Infrastruktursoftware* → "infrastructure software" (shown as the
green fill on *EJB container* and *Oracle 9i database*), and in the sequence
diagram *lese/schreibe …* → "read / write …", *segmentiere* → "segmentize",
*migriere Package* → "migrate package", *parallel und wiederholt* → "parallel
and repeated", *wiederhole, bis alle Daten migriert* → "repeat until all data
has been migrated".

**D1. "System under Design"** appears in the original legend in English already,
inside an otherwise German diagram. I dropped the legend, so the question is
moot — but if legends come back, note that the phrase is a Starke-ism and you may
want "system under design" lower-cased, or arc42's own "system under
consideration".

**D2. The graffle is the real master.** `_originals/images/
esa5-kap12-beispiel-batchmigration.graffle` (OmniGraffle Pro, 2007-10-25) turns
out to be an uncompressed XML plist holding **all nine sheets** with full
geometry, colours and connectors — it parses with Python `plistlib` directly.
Its RTF strings are Mac Roman, so umlauts need `mac_roman` decoding
(`4 B‰nder` = *4 Bänder*). If the redrawn figures ever need to be checked against
the originals, that file is the authority, not the rasters.

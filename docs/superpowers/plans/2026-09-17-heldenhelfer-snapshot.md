# Heldenhelfer snapshot: implementation plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Move Heldenhelfer from the `/in-the-wild/` reading list to a hosted, snapshotted example under `_systems/heldenhelfer/`, reproduced as-is from the archived openCode repository.

**Architecture:** One new directory under `_systems/`, built with `make new-system`, holding twelve Markdown sections converted by hand from the fourteen AsciiDoc chapter files, the ten diagram files copied unchanged into `images/`, and every source file kept in `_originals/`. The only edit outside that directory removes the entry from `_data/in-the-wild.yml`, because the reading list and the hosted corpus are disjoint by definition (the file header says so). Nothing is translated: the original is written in English.

**Tech Stack:** Jekyll 4 on GitHub Pages, kramdown Markdown, POSIX `sh` checks via `make check`, Docker for `make check-links` and `make dev`.

**Spec:** none. This plan is the spec. The permission to snapshot is the email quoted under *Provenance* below; the conventions come from `CONTRIBUTING.md`, `_systems/_TEMPLATE/index.md` and the precedent `_systems/UBA-SNS/`.

## Provenance

Permission to host a snapshot was given by email in September 2026 by Hendrik Herschlein, Projektmanager Heldenhelfer, Smarte Region Würzburg:

> Sie können gerne einen Snapshot der Dokumentation vorhalten. [...] Das Repo steht bei OpenCode auf "archiviert", da - zumindest durch uns - nicht mehr aktiv daran weiter entwickelt wird. An Code und Dokumentation wird sich also von unserer Seite aus nichts mehr ändern.

The repository is MIT licensed, copyright 2025 Smarte Region Würzburg. The documentation was written by smart and public GmbH on behalf of Smarte Region Würzburg. The snapshot is version 1.5.0 of 1 July 2024, the last revision in the document history; the repository's last commit is `b36958260577625c1fb6da66a4acdcb597ae6750` of 2026-04-22.

## Source

Clone: `git clone --depth 1 https://gitlab.opencode.de/wuerzburg/heldenhelfer.git` into a scratch directory outside the repo (referred to below as `$SRC`). Everything needed lives under `$SRC/architecture_doc/src/docs/`:

| Path under `src/docs/` | What | Goes to |
|---|---|---|
| `arc42/Architecture_HELD_WUE.adoc` | master document, includes the chapters | `_originals/` |
| `arc42/chapters/00_history.adoc` | document history table, not an arc42 section | `_originals/` only |
| `arc42/chapters/01_…12_*.adoc` | the twelve sections | converted to `NN-name.md` |
| `arc42/chapters/about-arc42.adoc`, `config.adoc`, `.asciidoctorconfig.adoc` | boilerplate | `_originals/` |
| `structurizr/workspace.dsl`, `workspace.json` | diagram model | `_originals/` |
| `images/structurizr-1-*.svg` (8 files) | rendered C4 diagrams | `images/` unchanged |
| `images/runtime_view_club_creation_new.svg` | drawio export | `images/` unchanged |
| `images/runtime_view_club_creation_new.drawio` | drawio source | `_originals/` |
| `images/01_2_iso-25010-topics-EN.drawio.png` | quality overview | `images/` unchanged |
| `images/spg_long.svg` | smart and public logo, title page only | not copied; it is the developer's logo, not part of the documentation |

## Global Constraints

- **As-is reproduction.** The Markdown is a snapshot of someone else's writing. Do not correct grammar, spelling, wording or facts. Do not add content the original does not have. Do not drop content it has. The only permitted edits are the format conversion itself and the front matter.
- **Keep the arc42 section titles** exactly as `_systems/_TEMPLATE/NN-*.md` has them: Introduction and Goals · Architecture Constraints · Context and Scope · Solution Strategy · Building Block View · Runtime View · Deployment View · Cross-cutting Concepts · Architecture Decisions · Quality Requirements · Risks and Technical Debt · Glossary. The original's own H2 (`== Risks and Technical Debts`, `== Concepts`) is not repeated in the body; the layout prints the title.
- **Section file front matter** is exactly `title:` and `order:`, the `order` being the arc42 section number 1–12. Nothing else, no permalink, no layout.
- **Images** are referenced relatively: `![Alt text](../images/file.svg)`. The AsciiDoc caption line (`.Caption`) becomes the alt text. Nothing else about the image files changes.
- **No file outside `_systems/heldenhelfer/` changes** except `_data/in-the-wild.yml` (Task 6) and this plan.
- **No em dash in new prose** (`CLAUDE.md`). This applies to `index.md` and to nothing else, because the section bodies are the authors' prose and are reproduced as written.
- **`_originals/` keeps its leading underscore.** Jekyll publishes everything in a directory without it.
- **`make check` must pass after every task that commits section files**, and `make check-links` before the pull request.

## AsciiDoc to Markdown conversion rules

Apply these uniformly; they are the whole difference between the two formats in this document.

| AsciiDoc | Markdown |
|---|---|
| `:jbake-*:`, `:filename:`, `:toc:`, `:sectnums:`, `ifndef::imagesdir[...]`, `[[section-…]]` anchors on the H2 | drop |
| `== Title` (the section's own H2) | drop; the layout prints `title:` |
| `=== Sub` / `==== Sub` | `## Sub` / `### Sub` |
| `==== Actors [[actors]]` | `### Actors {#actors}` (kramdown header id, one level under `## Business Context`; section 12 links to it) |
| `.Caption` line followed by `image::…/images/f.svg[]` | `![Caption](../images/f.svg)` |
| `image::…[ "Alt" ]` with explicit alt | use the explicit alt |
| `// comment` lines (including the `// plantuml::` lines) | drop |
| `*bold*`, `_italic_`, `` `code` `` | `**bold**`, `*italic*`, `` `code` `` |
| `https://url[Text]` | `[Text](https://url)` |
| bare `https://…` inside parentheses | `<https://…>`; kramdown GFM does not autolink bare URLs, Asciidoctor does, and the angle-bracket form keeps the URL as the link text |
| `<<actors>>` | `[Actors](../03-context-and-scope/#actors)` |
| `<<EVS>>` or `[[EVS]]` inline anchor | drop the anchor; keep the text |
| numbered list `1.` `2.` | `1.` `2.` (kramdown renumbers) |
| `* item` | `- item` |
| `\|===` table with `options="header"` or a first row of `*bold*` cells | Markdown pipe table; the first row is the header row either way |
| `a\|` cell containing a bullet list | one cell, items joined with `<br>` and a leading `•`, as `_systems/nfdi4earth/05-building-block-view.md` does |
| `[source,json]` + `----` block | fenced ```` ```json ```` block |
| `[cols="…"]` width hints | drop; pipe tables have no widths |

Pipe tables need every `|` inside a cell escaped as `\|`. Check each converted table renders with the right column count before committing.

## File Structure

| File | Responsibility |
|---|---|
| `_systems/heldenhelfer/index.md` | Dashboard tile front matter, provenance, and the overview prose |
| `_systems/heldenhelfer/01-introduction-and-goals.md` … `12-glossary.md` | The twelve sections, one per file |
| `_systems/heldenhelfer/images/` | The ten published diagram files, copied unchanged |
| `_systems/heldenhelfer/_originals/` | Every AsciiDoc, DSL, JSON and drawio source, never published |
| `_data/in-the-wild.yml` | Loses the Heldenhelfer entry |

---

### Task 1: Scaffold the directory, copy sources and images

**Files:**
- Create: `_systems/heldenhelfer/` (via `make new-system`)
- Create: `_systems/heldenhelfer/_originals/**`
- Create: `_systems/heldenhelfer/images/*`

- [ ] **Step 1: Clone the source into a scratch directory**

```bash
SRC=/tmp/heldenhelfer-src   # or the session scratchpad
git clone --depth 1 https://gitlab.opencode.de/wuerzburg/heldenhelfer.git "$SRC"
git -C "$SRC" log -1 --format='%H %ad' --date=short
```
Expected: `b36958260577625c1fb6da66a4acdcb597ae6750 2026-04-22`. A different hash means the repository moved after this plan was written; stop and report it, because the email says nothing will change.

- [ ] **Step 2: Scaffold**

```bash
make new-system SLUG=heldenhelfer
ls _systems/heldenhelfer
```
Expected: `index.md`, twelve `NN-*.md` files, `images/`, `_originals/`, and `permalink: /systems/heldenhelfer/` in `index.md`.

- [ ] **Step 3: Copy the sources into `_originals/`, keeping the tree**

```bash
D=$SRC/architecture_doc/src/docs
mkdir -p _systems/heldenhelfer/_originals/arc42/chapters _systems/heldenhelfer/_originals/structurizr _systems/heldenhelfer/_originals/images
cp "$D"/arc42/Architecture_HELD_WUE.adoc "$D"/arc42/.asciidoctorconfig.adoc _systems/heldenhelfer/_originals/arc42/
cp "$D"/arc42/chapters/*.adoc "$D"/arc42/chapters/.asciidoctorconfig.adoc _systems/heldenhelfer/_originals/arc42/chapters/
cp "$D"/structurizr/workspace.dsl "$D"/structurizr/workspace.json _systems/heldenhelfer/_originals/structurizr/
cp "$D"/images/runtime_view_club_creation_new.drawio _systems/heldenhelfer/_originals/images/
cp "$SRC"/LICENSE _systems/heldenhelfer/_originals/LICENSE
```
Also write `_systems/heldenhelfer/_originals/README.md`:

```markdown
# Heldenhelfer: original sources

Snapshot of `architecture_doc/src/docs/` from
https://gitlab.opencode.de/wuerzburg/heldenhelfer at commit
b36958260577625c1fb6da66a4acdcb597ae6750 (2026-04-22), documentation
version 1.5.0 of 1 July 2024. The repository is archived on openCode.

- `arc42/` the AsciiDoc master document and its chapter files, including
  `00_history.adoc` (the document history, which has no arc42 section and
  is summarised in `../index.md`)
- `structurizr/` the C4 model the `structurizr-1-*.svg` diagrams were
  exported from
- `images/` the drawio source of the runtime view diagram
- `LICENSE` MIT, Smarte Region Würzburg

Rendered diagrams are in `../images/`. The Markdown sections were converted
by hand from these files; the original is English and nothing was
translated.
```

- [ ] **Step 4: Copy the published images**

```bash
cp "$D"/images/structurizr-1-*.svg "$D"/images/runtime_view_club_creation_new.svg "$D"/images/01_2_iso-25010-topics-EN.drawio.png _systems/heldenhelfer/images/
rm -f _systems/heldenhelfer/images/.gitkeep 2>/dev/null; ls _systems/heldenhelfer/images | wc -l
```
Expected: 10 files (8 Structurizr SVGs, the runtime SVG, the PNG). Do not copy `spg_long.svg`.

- [ ] **Step 5: Run the structure check**

```bash
make check-structure
```
Expected: a *warning* that `heldenhelfer` is untracked and skipped. No error.

- [ ] **Step 6: Commit the scaffold**

```bash
git add _systems/heldenhelfer
git commit -m "heldenhelfer: scaffold example, import sources and diagrams

Snapshot of the archived openCode repository at b36958260577, documentation
v1.5.0 (2024-07-01). Permission by email from Smarte Region Würzburg,
September 2026.

Co-Authored-By: Claude Fable 5.1 <noreply@anthropic.com>"
```
`make check` will now fail on this directory until Task 5 is done, because twelve template sections are committed under their placeholder text. That is expected between Tasks 1 and 5; do not skip the commit to avoid it.

---

### Task 2: `index.md`, the tile and the overview

**Files:**
- Modify: `_systems/heldenhelfer/index.md` (replace the whole file)

Write the file below. Every value is derived from the source chapters: the goal from the platform description and section 1, the decisions from section 4 items 4, 8 and 3, the scale from section 2's organisational constraints.

```markdown
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
  - Kafka events and one sidecar per third-party tool
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

scale: 5 self-built services beside Nextcloud and Discourse · team of 7 · half a year · pilot 2024

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

The architecture is small and easy to hold in one view. Five services are
written for the project: a Next.js web UI, a FastAPI backend, and three small
sidecars. Nextcloud, Discourse and Keycloak are open source products
configured at runtime: when a club is created, the backend publishes an event
to Kafka, and the Nextcloud and Discourse sidecars pick it up and configure
their product through its API. Section 6 walks through exactly that flow.

Two things make it worth reading. The quality requirements in section 10 are
thirty-five scenarios sorted by priority. The decision log in section 9 gives
each entry a date and the people who took it, and two entries settle for the
simpler storage during the pilot and postpone the switch on purpose.

This is a snapshot of documentation version 1.5.0, dated 1 July 2024, the
last of seven revisions listed in the original's document history. Development
stopped in August 2024 and the repository on openCode is archived, so the
snapshot is also the final state. The sources, including the Structurizr model
the diagrams were exported from, are kept in this site's repository.
```

- [ ] **Step 1: Write the file** as above.

- [ ] **Step 2: Check the tile fields**

```bash
sh scripts/check-system-fields.sh
sh scripts/check-sections.sh
```
Expected: both pass (check-sections verifies that highlights 10, 9 and 8 exist; the template files from Task 1 are present so they do).

- [ ] **Step 3: Commit**

```bash
git add _systems/heldenhelfer/index.md
git commit -m "heldenhelfer: dashboard tile, provenance and overview

Co-Authored-By: Claude Fable 5.1 <noreply@anthropic.com>"
```

---

### Task 3: Sections 1 to 4

**Files:**
- Modify: `_systems/heldenhelfer/01-introduction-and-goals.md`, `02-architecture-constraints.md`, `03-context-and-scope.md`, `04-solution-strategy.md` (replace the template text wholesale)

Source: `$SRC/architecture_doc/src/docs/arc42/chapters/01_introduction_and_goals.adoc`, `02_…`, `03_…`, `04_…`. Apply the conversion rules. Section-specific notes:

- **01.** Three H2s: Requirements Overview, Quality Goals, Stakeholders. The `// Todo add Link of file` comment is dropped. The stakeholder table has a header row (`options="header"`) and three columns; the bare URLs in the Contact column stay bare. The five quality goals are an ordered list.
- **02.** Two H2s, each introduced by one sentence and a table whose first row is bold cells. The table caption (`.Technical Constraints`) is not a Markdown construct; drop it, the H2 already names it.
- **03.** H2 *Business Context*, then H3 *Actors* with id `actors`, H3 *External Systems*. The original has no Technical Context subsection. Do not add one and do not add a line saying it is missing; the section is not empty.
- **04.** H2 *Software*, H2 *Organization*, each an ordered list of bold-lead items. The intro sentence stays.

Front matter for each:

```markdown
---
title: Introduction and Goals
order: 1
---
```
(and `Architecture Constraints`/2, `Context and Scope`/3, `Solution Strategy`/4).

- [ ] **Step 1: Convert the four files.**

- [ ] **Step 2: Diff word counts against the source** to catch dropped paragraphs:

```bash
for n in 01 02 03 04; do
  a=$(sed -e '/^:/d' -e '/^\/\//d' -e '/^ifndef/d' -e '/^\[\[/d' -e '/^|===/d' "$SRC"/architecture_doc/src/docs/arc42/chapters/${n}_*.adoc | wc -w)
  b=$(awk 'f>=2{print} /^---$/{f++}' _systems/heldenhelfer/${n}-*.md | sed '/^|---/d' | wc -w)
  echo "$n adoc=$a md=$b"
done
```
Expected: the two counts within about 5% of each other for every section. A larger gap means content was lost; find it.

- [ ] **Step 3: Commit**

```bash
git add _systems/heldenhelfer/0[1-4]-*.md
git commit -m "heldenhelfer: sections 1 to 4

Co-Authored-By: Claude Fable 5.1 <noreply@anthropic.com>"
```

---

### Task 4: Sections 5 to 8

**Files:**
- Modify: `05-building-block-view.md`, `06-runtime-view.md`, `07-deployment-view.md`, `08-crosscutting-concepts.md`

Source chapters `05_building_block_view.adoc`, `06_runtime_view.adoc`, `07_deployment_view.adoc`, `08_concepts.adoc`. Notes:

- **05.** Six images, every one preceded by a `.Caption` line that becomes the alt text: *Over All Building Block View* (`structurizr-1-SystemContext-001.svg`), *Level 1 - HELD Application View* (`Container-001`), *Level 2 - Hero Portal Backend View* (`Component-001`), *Level 2 - Digital Office View* (`Component-002`), *Level 2 - Club Forum View* (`Component-003`), *Level 2 - IAM SCH Realm View* (`Component-004`). H3s (`=== Level 1 …`) become H2s. `[[EVS]]` after `*EVS*` is an anchor; drop it. The Collabora link `https://www.collaboraoffice.com[Collabora]` becomes `[Collabora](https://www.collaboraoffice.com)`.
- **06.** One H2 *Create Club Workflow*, one image (`runtime_view_club_creation_new.svg`, alt *Create Club for digital office runtime view*), three paragraphs.
- **07.** One H2 *Overall Deployment View*, one image (`structurizr-1-Deployment-001.svg`, no caption line: use the heading as the alt text), and one closing paragraph about the Open Telekom Cloud. That is the whole section, and it stays that short.
- **08.** Two H2s, *Logging Concept* and *REST Security*. The first contains a JSON log example in a `----` block: fence it as ```` ```json ````. The second uses `` `Authorization` `` inline code; keep it.

Front matter titles: `Building Block View`/5, `Runtime View`/6, `Deployment View`/7, `Cross-cutting Concepts`/8.

- [ ] **Step 1: Convert the four files.**

- [ ] **Step 2: Verify every image reference resolves**

```bash
grep -ho '\.\./images/[^)]*' _systems/heldenhelfer/0[5-8]-*.md | sort -u | while read p; do
  test -f "_systems/heldenhelfer/${p#../}" && echo "ok  $p" || echo "MISSING $p"
done
```
Expected: 8 lines, all `ok`, no `MISSING`.

- [ ] **Step 3: Word-count diff** as in Task 3, Step 2, for `05 06 07 08`. Section 08's JSON block inflates the count equally on both sides.

- [ ] **Step 4: Commit**

```bash
git add _systems/heldenhelfer/0[5-8]-*.md
git commit -m "heldenhelfer: sections 5 to 8

Co-Authored-By: Claude Fable 5.1 <noreply@anthropic.com>"
```

---

### Task 5: Sections 9 to 12

**Files:**
- Modify: `09-architecture-decisions.md`, `10-quality-requirements.md`, `11-risks-and-technical-debt.md`, `12-glossary.md`

Source chapters `09_architecture_decisions.adoc`, `10_quality_requirements.adoc`, `11_technical_risks.adoc`, `12_glossary.adoc`. Notes:

- **09.** One three-column table, header row *Decision | Date & Key Person | Reasons, consequences, alternatives*, seven rows. The second row's third cell is an `a|` cell holding a three-item bullet list: render as `• With separate repository …<br>• If the HELD application …<br>• HELD specific Keycloak …`. Multi-line cells in the source are one cell each; join their lines with a space.
- **10.** One image (`01_2_iso-25010-topics-EN.drawio.png`, alt from the source: *Categories of Quality Requirements*), then the scenario table: three columns *Characteristic | Scenario | Prio*, thirty-five rows. Count them after conversion.
- **11.** One four-column table *ID | Problem/Risk | Impact | Description*, two rows (R1, R2). The first row's cells are split across source lines; join them.
- **12.** Two-column table *Term | Definition*, twenty-four rows. Five rows contain `<<actors>>` (Club Admin, Club Member, HELD Admin, HELD Member, Unknown); each becomes `[Actors](../03-context-and-scope/#actors)`. The German glosses (Verein, Maßnahme, Unbekannt) are the authors' text and stay.

Front matter titles: `Architecture Decisions`/9, `Quality Requirements`/10, `Risks and Technical Debt`/11, `Glossary`/12.

- [ ] **Step 1: Convert the four files.**

- [ ] **Step 2: Count table rows**

```bash
for n in 09 10 11 12; do printf '%s ' "$n"; grep -c '^|' _systems/heldenhelfer/${n}-*.md; done
```
Expected (header + separator + data): `09 9`, `10 37`, `11 4`, `12 26`.

- [ ] **Step 3: Run the full check**

```bash
make check
```
Expected: every check passes, including `check-structure` reporting heldenhelfer among the complete systems and `check-review` unaffected (no review file exists for it).

- [ ] **Step 4: Commit**

```bash
git add _systems/heldenhelfer/09-*.md _systems/heldenhelfer/1[0-2]-*.md
git commit -m "heldenhelfer: sections 9 to 12

Co-Authored-By: Claude Fable 5.1 <noreply@anthropic.com>"
```

---

### Task 6: Retire the in-the-wild entry

**Files:**
- Modify: `_data/in-the-wild.yml` (the `- title: Heldenhelfer` entry, currently lines 279–306)

The reading list is for documentation "we link to but do not host"; its header says everything under `_systems/` has been read end to end and everything on the list has not. An entry cannot be both, so the entry goes, note and all. The note's substance (what the platform is, that development stopped in 2024) has moved into `index.md`.

- [ ] **Step 1: Delete the entry**

Remove from the line `- title:       Heldenhelfer` through the blank line after `group:       real-systems`, leaving exactly one blank line between the `group:       start-here` line of the entry above and `- title:       geOrchestra Gateway` below.

```bash
grep -n -i heldenhelfer _data/in-the-wild.yml
```
Expected: no output.

- [ ] **Step 2: Run the in-the-wild checks**

```bash
make check-wild-groups check-wild-fields
```
Expected: pass.

- [ ] **Step 3: Confirm no other reference**

```bash
grep -rn -i heldenhelfer --exclude-dir=_site --exclude-dir=.git --exclude-dir=_systems --exclude-dir=docs .
```
Expected: no output. (`search.json` is generated from the collections and needs no edit.)

- [ ] **Step 4: Commit**

```bash
git add _data/in-the-wild.yml
git commit -m "in-the-wild: retire Heldenhelfer, now hosted at /systems/heldenhelfer/

Co-Authored-By: Claude Fable 5.1 <noreply@anthropic.com>"
```

---

### Task 7: Build, look, and open the pull request

- [ ] **Step 1: Build and check links**

```bash
make check-links
```
Expected: html-proofer reports no failures. A failure on `../03-context-and-scope/#actors` means the header id in section 3 was not written as `{#actors}`.

- [ ] **Step 2: Look at it**

```bash
make dev
```
Open http://localhost:4230/ and check: the Heldenhelfer tile appears last in the grid with *Created by Smarte Region Würzburg*; `/systems/heldenhelfer/` renders the overview and a twelve-cell grid; each section page shows its diagrams. Specifically check `/systems/heldenhelfer/06-runtime-view/`: the drawio SVG uses a `foreignObject` for its labels, which some browsers render without text. If labels are missing in Chrome or Firefox, export a PNG from `_originals/images/runtime_view_club_creation_new.drawio` (drawio desktop, File > Export as > PNG, 2x) into `images/runtime_view_club_creation_new.png`, point section 6 at the PNG, and delete the SVG from `images/`. Otherwise keep the SVG.

Also check `/in-the-wild/`: the *Real systems, real compromises* run no longer lists Heldenhelfer and the entries above and below it sit with normal spacing.

- [ ] **Step 3: Commit any fix from Step 2**, then push and open the pull request against `main`:

```bash
git push -u origin heldenhelfer-snapshot
gh pr create --title "Host Heldenhelfer as a snapshotted example" --body "$(cat <<'PR'
Moves Heldenhelfer from /in-the-wild/ to _systems/heldenhelfer/, converted as-is from the archived openCode repository (documentation v1.5.0, 2024-07-01). Permission to host a snapshot was given by email from Smarte Region Würzburg in September 2026; the repository is archived and will not change.

- twelve sections converted by hand from AsciiDoc, nothing translated (the original is English)
- ten diagrams copied unchanged, Structurizr model and drawio source in _originals/
- in-the-wild entry retired
- make check and make check-links pass

Plan: docs/superpowers/plans/2026-09-17-heldenhelfer-snapshot.md

🤖 Generated with [Claude Code](https://claude.com/claude-code)
PR
)"
```

## Out of scope

- Review notes on this system (ADR-0009). They are a separate editorial act, done after the snapshot is live, with the `review-note` skill.
- Fixing the original's grammar or the dangling reference in section 1 to an internal modelling file. Snapshots reproduce.
- Any change to layouts, includes or styles. If a table or SVG renders badly, the fix belongs in the example's own files.

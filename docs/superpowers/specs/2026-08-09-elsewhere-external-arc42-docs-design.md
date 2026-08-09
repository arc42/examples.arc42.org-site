# Elsewhere — linking arc42 documentation we cannot host

Status: approved and built · 2026-08-09

## The problem

examples.arc42.org publishes complete arc42 documentations of real systems, in
full, on this site. That promise is narrow on purpose, and it excludes work that
is genuinely worth reading: documentation whose licence does not let us
republish it, documentation that lives on someone else's site and should stay
there, documentation that is partial.

There is currently nowhere to point at any of it. The site therefore looks like
it believes four examples are all that exist.

## What we are building

A page, `/elsewhere/`, holding an annotated list of links to arc42
documentation we cannot host. Expected size **10–40 entries**, growing slowly.
Each entry carries a neutral one-line description and **one short editorial note
in our own voice** saying what is worth looking at or what is thin.

## The decision that shapes everything: no tiles

The dashboard tile is not a card. It is the summary of a completed audit —
`domain`, `main_goal`, four `decisions`, six `technologies`, `scale`. Every one
of those fields can only be filled in by someone who has read all twelve
sections. For a link we have not audited, a tile would be either half-empty or
fabricated.

So the external list is not a grid of anything. It is set as a **bibliography**:
name, description, note, a hairline facts line, a rule between entries. A
bibliography is a different *genre* from a dashboard, and a reader decodes genre
instantly, without a legend — which matters here, because the site's own rules
forbid a purely visual distinction from carrying meaning alone.

Rejected alternatives, and why:

- **The same tiles, visually downgraded** (dashed border, no hover-lift, an
  "external" marker). Near-equivalence is what implies equivalence of quality. A
  dashed border is a weak signal most readers will not decode, and the
  half-empty-tile problem above applies regardless of styling.
- **A band at the bottom of the home page.** The juxtaposition argument is real
  — grid above, plain list below, on one page, is the strongest possible
  statement that these are different in kind. Rejected because the home page's
  filter box would then sit above a list it does not filter, and because at 40
  entries the dashboard becomes mostly link list. The pointer sentence
  (below) recovers most of the discoverability at none of the cost.

## Placement and naming

- Nav label **"Elsewhere"**. Page H1 **"Documented elsewhere"**. Permalink
  `/elsewhere/`.
- Nav becomes *Elsewhere · Contribute · About*, search still rightmost.
- `index.md` gains one sentence, directly after the existing docs.arc42.org
  line and in the same voice, naming **licensing** as the reason these are not
  hosted. That is true, and it is neutral: "we could not vet these" would read
  as a slight against the authors.

"Elsewhere" over "More examples": *more* implies these are more of the same
thing, which is the claim the page exists to avoid making.

## Data model

`_data/elsewhere.yml`, one file. Not a collection — entries have no body and
need no page of their own, and one file is one reviewable diff.

```yaml
- title:       Name of the documentation
  url:         https://example.org/arch/
  author:      Who wrote it
  description: One neutral sentence — what the system is.
  note:        Our sentence — what is worth looking at, or what is thin.
  language:    German          # omit when it is English
  year:        2019            # when it was written, if knowable
  added:       2026-08         # when we added it
```

`title`, `url`, `author`, `description`, `note` and `added` are required for a
finished entry; `language` and `year` are optional.

`note` is required *of the entry*, not of the contributor. A pull request
supplies `title`, `url`, `author` and `description`; a maintainer writes the
note after looking at the link. That split is the whole reason the note is
worth having — notes written by the documentation's owner turn into blurbs, and
a reading list of blurbs helps nobody choose. Both `_pages/contribute.md` and
`CONTRIBUTING.md` say so explicitly.

**Deliberately absent:** `domain`, `technologies`, `decisions`, `scale`,
`licence`. Each is an audit output. Leaving them out is the mechanism that stops
this list drifting back into being a tile grid — there is nothing to put in the
tile.

`added` earns its place: it lets a reader discount a three-year-old note without
us re-checking every entry.

## Rendering

```
Fizzbuzz Enterprise Platform
A logistics scheduling system for a mid-sized freight operator.

Sections 1–6 only, but section 4 is unusually candid about the
strategy that was abandoned. Worth reading for that alone.

Marie Fischer · German · 2019 · added 2026-08 · beispiel-firma.de
────────────────────────────────────────────────────────────────
Another Documented System
An order-management system for a regional retailer.
…
```

Title in Caslon at h3 size (it must not compete with the page H1), description
in body text, note in Caslon and `--muted` — the same trick the tile uses to
separate its main goal from its tagline without spending pigment — facts line
smaller and muted.

The hairline rule sits **between** entries (`& + &`), not around them. A border
on four sides is a card, and a card is a tile with the label filed off.

New component `.ex-elsewhere` — site-local `ex-` prefix per the Same-Name Rule —
in a new `_sass/_elsewhere.scss`, imported after `_dashboard`.

Markup is an `<ol>` of `<li>`, with exactly **one real `<a>` per entry**, on the
title. That is the same one-link-per-item discipline the tiles already keep, for
the same reason: two links per entry announces every entry twice.

Explicitly not used: border, background fill, hover-lift, stretched link,
catalogue number, chips, filter box. Every one of those is a tile affordance.

**Links open in the same tab.** This breaks with the site footer, which forces
`target="_blank"` on external links. Thirty forced tabs is hostile, and WCAG
3.2.5 prefers not to open new windows without warning. Instead the target host
is shown in the facts line, so the reader knows where they are going before
clicking.

Empty state: if `_data/elsewhere.yml` has no entries, the page says so plainly
rather than rendering an empty `<ol>`, matching the home page's existing
"No examples yet" treatment.

## The framing paragraph

Above the list, in prose, **not** in a warning box:

> These are arc42 documentations we cannot host — usually because their licence
> does not allow it. We link them because they are useful, not because we have
> checked them. Nobody here has read every one of these end to end, several are
> partial, and the note under each is one person's opinion on the date it was
> added. Everything on the home page, by contrast, has been read in full and
> carries its provenance.

The disclaimer appears **once**, not per entry. Repeating "not reviewed" thirty
times is noise; the genre and this paragraph carry it.

## Contribute page

A third destination now exists, so the boundary needs restating:

| What you have | Where it goes |
|---|---|
| Complete, and you may republish it | An example directory (`make new-system`) |
| Complete, but not republishable here | `_data/elsewhere.yml` |
| A fragment of one section | docs.arc42.org |

Plus the field list and the one rule that keeps the notes honest: **submit a
link and a description; we write the note.** Author-supplied notes become
blurbs.

## Link rot

This is the running cost, and it is the only new operational burden.
`make check-links` runs html-proofer with `--disable-external`, so nothing
checks these today. A dead link on a page whose entire content is links is
worse than no page.

`scripts/check-external-links.sh` reads `_data/elsewhere.yml`, requests each
URL, and reports anything that is not 2xx. A dedicated script rather than
html-proofer's external mode: it is precise, fast, needs no build, and can run
on a schedule without slowing the normal one.

Wired as `make check-external`, and **deliberately not part of `make check`** —
a build must not fail because someone else's server is down.

No scheduled CI job in this change. A monthly GitHub Action that opens an issue
is the obvious follow-up, but the manual target is worth having first, and
automation needs an owner before it is added.

## Files

New:

- `_pages/elsewhere.md`
- `_data/elsewhere.yml`
- `_sass/_elsewhere.scss`
- `scripts/check-external-links.sh`

Edited:

- `assets/css/style.scss` — one `@import`, after `dashboard`
- `_includes/masthead.html` — nav entry, first in the list
- `index.md` — pointer sentence
- `_pages/contribute.md` — the three destinations; H1 becomes "Contribute"
  rather than "Contribute an example", since the page now covers two kinds of
  contribution, and the existing sections drop one heading level under a new
  "Contribute an example" H2
- `CONTRIBUTING.md` — the same three destinations, for people arriving via the
  repository rather than the site
- `Makefile` — `check-external` target, and `.PHONY`
- `README.md` — the data file, the script, and the new target
- `DESIGN.md` — record the no-tiles decision and its reasoning, so it is not
  "simplified" into a tile grid later

## Out of scope

No filter, no tags, no per-entry pages, no screenshots, no ratings, no automatic
import, no grouping. At 10–40 entries, alphabetical order on one page is enough.
Grouping by language is the first thing to add if it outgrows that.

## Seeding

The list ships **empty**, and `_data/elsewhere.yml` is the schema plus `[]`.
Real external documentation and its URLs have to come from someone who knows
they are real; `make check-external` verifies that a URL resolves, not that the
thing behind it is what we claim. Until the first entry lands, `/elsewhere/`
renders its empty state and points at Contribute.

## How this was verified

- `make check` (brand) and `make check-links` (html-proofer, 71 files) pass.
- `make check-external` was exercised against a live 200 and a live 404 and
  returned the right exit code for each; against the shipped empty file it
  reports "nothing to check" and exits 0.
- The page template was rendered against two temporary seed entries to confirm
  alphabetical sort, host extraction from the URL, and clean omission of the
  optional `language` and `year` fields. The seed data was then removed.

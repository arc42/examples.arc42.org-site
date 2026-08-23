# Cross-system section views: linking docs.arc42.org into the examples

Status: approved 2026-08-23, not built

Spans two repositories. The page family is built here; docs.arc42.org-site
gains the links that point at it. Build this side first, because the routes
have to exist before anything links to them.

This makes good on the deferral recorded in `DESIGN.md`:

> A `/sections/03-context/` page listing every system's section 3, the "all
> context views together" idea, is **not built**. [...] It was left out of the
> first version because it is worth building once there are enough examples for
> a comparison to say something.

Eight systems are published and two more are scaffolded. That condition is met.

## The problem

docs.arc42.org explains what belongs in each of the twelve arc42 sections. A
reader who has just read what a building block view is for wants to see one.
The site can currently offer two things, and neither is what they want:

- its own `_examples` collection, which holds excerpts, single sections lifted
  out of a document and shown alone;
- a single link to `examples.arc42.org`, added 2026-08-21, which lands on a
  grid of whole systems and leaves the reader to find section 5 themselves.

Linking docs section 5 straight to one chosen system's section 5 was considered
and rejected. The corpus here changes in both size and depth, so any such link
encodes a judgement ("this is the section 5 worth reading") in a repository that
cannot see when it stops being true.

## What we are building

A page family on this site, `/sections/05-building-block-view/` and eleven
siblings, each answering one question: how do the documented systems handle this
arc42 section?

Each page carries two bands:

1. **Worth starting with.** One or two systems, each with a short line saying
   why this particular section of that particular system repays a reader's time.
   Maintainers' voice.
2. **All systems.** Every system that has this section, generated.

docs.arc42.org then needs to know exactly one thing per section: a URL. Which
systems exist, how deep they go, which are worth reading first, all of that
lives here and changes here.

## The decision that shapes everything: the link target absorbs the churn

The alternative designs all put knowledge about this site into the other one.

- **Deep links to a chosen system per section.** Twelve editorial judgements
  stored in a repository with no way to revisit them. Rejected: this is the
  problem, not a solution.
- **A JSON feed.** This site publishes `/api/sections.json`; docs.arc42.org
  pulls it on a schedule and renders system names itself. The family already
  does exactly this for training dates, so the pattern is proven and the cost is
  known. Rejected because a feed only earns its keep if the consumer renders
  something that varies, and docs deliberately renders nothing that varies: no
  system names, no counts, no depth. It would be machinery in service of a
  static string.
- **A URL contract and nothing else.** Chosen. Twelve stable routes. No data
  crosses the boundary. The failure mode is a rename here silently 404-ing
  there, and that is addressed by a guard (below) rather than by coupling.

## Routes and naming

Twelve routes, plus a parent:

```
/sections/                             the twelve, listed
/sections/01-introduction-and-goals/
/sections/02-architecture-constraints/
...
/sections/12-glossary/
```

The slugs are the section filenames in `_systems/_TEMPLATE/`, unchanged. That
template is what forces every system to use identical section slugs, so reusing
it here means the route and the thing it indexes cannot drift apart.

GitHub Pages runs no custom plugins, so twelve pages cannot be generated from a
loop. Each is a stub in `_pages/sections/` carrying only front matter:

```yaml
---
layout: section-index
permalink: /sections/05-building-block-view/
title: Building Block View
section: 5
slug: 05-building-block-view
---
```

These twelve stubs are the only place the route list is written down. They are
not a registry of systems and do not violate the modularity contract: adding a
system still touches nothing outside its own directory.

`_config.yml` includes `_pages`. If the nested `_pages/sections/` directory
turns out not to be picked up, the stubs flatten to `_pages/section-index-NN.md`
with no change to any route: the permalinks drive the URLs, not the paths.

**Not added to the masthead nav.** The nav is currently *In the Wild ·
Contribute · About* plus search, and it is a designed surface. `/sections/` is
reached from the home page and from sibling links on the twelve pages
themselves. If it earns a nav slot later, that is a separate decision with its
own layout consequences.

## Data model: highlights

The curated band is declared by each system, in its own landing page front
matter, because `_includes/system-context.html` states the contract this site
runs on:

> one directory IS one system: adding an example is `cp -r _TEMPLATE myslug`,
> removing it is `rm -rf`, and NO FILE OUTSIDE THE DIRECTORY IS EVER EDITED. No
> central registry, no nav config, no list to keep in sync.

A central `_data/section-picks.yml` was considered and is exactly the registry
that contract forbids. It would also be the file nobody remembers to revisit
when a system is added, which is the failure this whole design is avoiding.

```yaml
# _systems/htmlsc/index.md
highlights:
  - section: 5
    why: small, one whitebox, three levels
  - section: 9
    why: ADRs kept short and dated
```

A list of maps, not a map keyed by section number: Liquid's `where` filter works
on the former and integer keys read back awkwardly in the latter.

Fields:

- `section` required, 1 to 12, must be a section the system actually has.
- `why` required, one line, lower case, no closing full stop. It completes an
  implied "read this one because...". Keep it under about sixty characters so
  the band stays scannable.

`highlights` is optional. A system with none appears in the second band only.
This matters for imports: a system can ship complete without anyone having
decided what it is exemplary at.

## Rendering

`_layouts/section-index.html`, one layout for all twelve.

The loop runs over **systems**, not over section documents, and in the tile
order the home page already uses:

```liquid
{%- assign fragment = '/' | append: page.slug | append: '.' -%}
{%- assign landings = site.systems | where_exp: 'd', 'd.layout == "system"' | sort: 'order' -%}
```

then for each landing page, find that system's document for this section by path
fragment and skip the system if it has none.

Two details behind that:

- **Do not select section documents with `where: 'order', 5`.** Landing pages
  carry `order` too, for tile placement. They are 10, 20, 30 and up today, so
  the filter would work by accident and break the first time a system is
  ordered below 12.
- Systems with no section files yet, currently `rgcat` and `UBA-SNS`, fall out
  of both bands with no special case, and appear the day their sections land.

Band one lists systems whose `highlights` name this section: system title,
domain, and the `why` line. Band two lists every system that has the section:
title and domain, linking to the section itself, not to the system landing page.

Both bands link to `/systems/<slug>/<NN-slug>/`, which is where the reader
wanted to go.

If a section has no highlights at all, band one is omitted entirely rather than
rendered empty. Twelve pages with a permanently empty band would teach readers
to ignore it.

Copy carries **no counts**. "Eight systems" dates the moment it is written and
this page exists precisely because the corpus grows. Same rule as the pointer
added to docs.arc42.org on 2026-08-21, and the same rule the home page tagline
already follows (`_config.yml`, the dropped live example count).

## The docs.arc42.org side

Changes live in `docs.arc42.org-site`. Every section page there already carries
`number:` in its front matter, and `_data/sections.yml` is already declared the
single source of truth for the twelve sections, so nothing needs a new parameter
at a call site.

- `_config.yml` gains `examples_url: https://examples.arc42.org`, matching the
  existing `imageurl` and `exampleimages` habit.
- `_data/sections.yml` gains one `examples_slug:` field per section.
- `_includes/examples-link.html` is new. It resolves the URL from `page.number`
  against `site.data.sections` and renders one of two variants.
- `_includes/further-info.md` calls it once with `variant="block"`, producing a
  third labelled block beside "Related Questions". Its twelve call sites are
  unchanged.
- Each `_pages/section-N.md` gains one `variant="inline"` call, placed after the
  `</div>` that closes the `.arc42-help` box. Outside the box on purpose:
  `_sass/_callouts.scss` reserves cool blue for arc42's own guidance and warm
  terracotta for somebody's actual documentation, and a link to real
  documentation is not guidance.

The URL scheme therefore lives in one file and the copy in one file. A rename
here is one word per section in `sections.yml`.

## Guards

Both are cheap and both fail loudly. This site has a `scripts/` habit already.

1. **Route slugs match the template.** Assert that the twelve `slug:` values in
   `_pages/sections/` equal the section filenames in `_systems/_TEMPLATE/`,
   exactly and in order. This is what makes the docs links safe: the routes
   cannot drift from the thing they index without failing a check here.
2. **Highlights name real sections.** Assert that every `highlights` entry in
   every system points at a section file that system actually has. A typo'd
   `section: 13` should fail the build, not vanish silently from a band.

On the docs side, a check that every entry in `_data/sections.yml` carries an
`examples_slug`. The twenty-four outbound links are external and html-proofer
runs there with `--disable-external`; that stays as it is. Guard 1 is what
stands behind them, and turning on external link checking is part of the CI
question deliberately deferred on 2026-08-23.

## Files

New, here:

```
_pages/sections/index.md
_pages/sections/01-introduction-and-goals.md   (and 02 through 12)
_layouts/section-index.html
scripts/check-sections.sh
```

Changed, here:

```
_systems/*/index.md        highlights: added where a system has one
index.md                   one sentence linking /sections/
Makefile                   check-sections wired into the check target
DESIGN.md                  "Deferred: cross-system section views" replaced by
                           what was built
_sass/                     a partial if the two bands need one, registered
                           the way the existing partials are
```

Changed, in docs.arc42.org-site:

```
_config.yml                examples_url
_data/sections.yml         examples_slug x12
_includes/examples-link.html   (new)
_includes/further-info.md      one include call
_pages/section-1.md ... section-12.md   one include call each
scripts/check-site.sh          examples_slug presence check
```

## Out of scope

- **`/in-the-wild/` entries in the bands.** Their `sections` field is free prose
  ("All 12", "All but 4 and 9", "Varies by team") and deliberately so: the
  schema header argues at length that the page must not acquire audit-output
  metadata. Making it machine-readable is a separate decision about that page,
  not a detail of this one.
- **Review notes on the section pages.** `_data/reviews/` is per-section and
  signed, so "this section carries a review note" is a plausible third signal.
  One system has notes so far. Not enough to design against.
- **A JSON feed.** Rejected above, and nothing here forecloses it.
- **CI.** Deferred separately on 2026-08-23. The guards run in `make check`.

## Build order

1. This site: routes, layout, guards, `highlights` on the systems that warrant
   them, home page sentence, `DESIGN.md` updated.
2. Verify all twelve routes build and resolve.
3. docs.arc42.org-site: config, data, include, twelve call sites.

The `why` lines are maintainers' voice about other people's documentation, and
`CLAUDE.md` sets the standard for that. Draft them, then have Gernot edit.

## How this will be verified

- `make check` here passes, including both new guards.
- Both new guards fail when deliberately broken: rename a stub slug, and add a
  `section: 13` highlight.
- All twelve routes render, and every link in both bands resolves.
- A section with no highlights renders band two alone, with no empty heading.
- `make check` in docs.arc42.org-site passes, and its rail check still holds.
- Spot-check one docs section page for both link sites, and confirm the inline
  one sits outside the `.arc42-help` box.

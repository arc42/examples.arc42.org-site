# examples.arc42.org — site design

Status: initial · 2026-08-06

This file documents the **site-local** design system. It must stay reconciled
with the code — a stale design document is worse than none, because people
trust it.

## Family

The family definition is [meta.arc42.org](https://github.com/arc42/meta.arc42.org):
`DESIGN.md` (the model, the named rules, shared component specs) and `BRAND.md`
(tokens, hues, assets). Both are normative here. This site inherits every
family constant: the Libre Caslon Text / Atkinson Hyperlegible Next pair, the
masthead band, flat-paper surface language, the three-step wash ladder, the
pinned-note shadow, light-only, WCAG 2.2 AA with measured ratios recorded at the
declaration site, and the 65–75ch reading measure.

It departs from the family in exactly one place, and by ADR: **it has no
signature hue.**

## The spine — this site's device

Registered by [ADR-0008](https://github.com/arc42/meta.arc42.org/blob/main/adr/0008-examples-owns-a-device-not-a-hue.md).

A 6px rule under the masthead, tiling six **shared family tokens** edge to edge:

| | 1 | 2 | 3 | 4 | 5 | 6 |
|---|---|---|---|---|---|---|
| token | teal | coral-deep | amber | green-ink | coral | maroon |
| hex | `#5fb49c` | `#c22b47` | `#ffc95c` | `#1b5e20` | `#ff5c7c` | `#8a2e2e` |

Definition and measurements: `_data/spine.yml`. Styling: `_sass/_spine.scss`.

Three properties are load-bearing and must not be "tidied":

1. **Shared tokens only.** No site's signature hue appears, so ADR-0001's
   Imprint Rule holds literally rather than by argument. `make check` enforces
   this.
2. **Non-spectral order.** Lightness alternates instead of advancing round the
   wheel. Weakest adjacent pair 30.1 ΔE00, against the family's 18.8 bar. A
   spectral order would make the device a rainbow, which it must not be.
3. **Decorative.** It encodes nothing and is `aria-hidden`. This is why WCAG
   1.4.11 does not apply to the segments. *If a segment is ever made to mean
   something — a category, a filter, the current example — it stops being
   decorative and every segment then needs 3:1 against its neighbours.*

This site is also the family's strongest **Visible-Token Rule** proof point:
all six shared tokens have a named, visible job here, in one place, on screen
at once.

**The home page carries no spine** (2026-08-07, re-examined and upheld
2026-08-12 — the critique that day raised the cost out loud: the site's one
identifying mark is missing from the page most visitors ever see, and below the
hero the home page is ~1850px of achromatic ledger. Both were weighed and the
original argument won. Two alternatives were considered and rejected with it:
the spine under the hero as well, which is the doubling the 2026-08-07 decision
removed, and the spine below the grid as a closing rule, which makes the device
a page ornament instead of a mark and puts it where nothing needs marking).
The hero band there is a row
of fourteen coloured specimens, and six colour blocks immediately under it read
as a second statement of the same idea rather than as the site's mark. Colour
and spine divide the site between them: the hero carries the variety on the one
page that has a hero, the spine carries it on every other page, where it is the
only colour on screen. ADR-0008 is unaffected — the device is still this site's
answer to having no signature hue — but the ADR should be annotated, because
"the device appears under the masthead" is no longer true without exception.
Reverting is one `unless` in `_includes/masthead.html`.

## The ground

`--ground #3a332b` (umber graphite), `--ground-deep #2f2922`.

A neutral, making no hue claim — the same position status.arc42.org's slate
occupies. Measured 13.9 ΔE00 from that slate and 19.3 from the masthead navy,
i.e. better separated from slate than slate is from navy (8.9).

White on the ground measures **12.44:1**; secondary on-band text `--tint-soft
#dcdad9` measures **8.93:1**. Full token set and every measured pair:
`_sass/_tokens.scss`, which is the only file allowed to contain a hex literal.

## Links, without a hue

A site with no signature hue has no link colour to spend. Links are ink-dark
(`--link` = `--ground-deep`, 14.12:1 on paper) and carry a **persistent
underline**, which is what actually distinguishes them. Hover thickens the
underline and adds a wash; it never introduces a hue.

An umber link ramp (`#6a5439`, 7.02:1 on paper) was measured and rejected: at
12.4 ΔE00 from pdfminion's sienna it read as a quotation of another site's
signature hue, which the Imprint Rule forbids in any role.

## The hero band

The home page hero carries a **herbarium frieze**: a row of fourteen botanical
specimens, no two alike, drawn in one flat illustrative hand — the metaphor for
what this site is, many different specimens under one identical documentation
format. Brief and export pipeline: `docs/hero-herbarium-prompt.md`.

It is **in full colour** (2026-08-07). The first version was monochrome warm
grey, so that the spine kept the site's only pigment; the hero and the spine
have since swapped jobs (see *The spine*, above). Two rules make it safe:

1. **The art never sits under text, and that is now load-bearing.**
   `.ex-masthead__band` paints an opaque `--ground` scrim from the left edge to
   50px past the H1's longest line, then ramps to clear over the next 260px.
   Every glyph is over flat `--ground`, so the recorded 12.44:1 stays a
   measurement.

   The stop is expressed in **fixed pixels below `--shell-max` and as a calc()
   off the centre from 1400px up**, because that is where the heading itself
   changes what it is anchored to. A percentage stop anywhere below 1400px is a
   bug, not a simplification: it tracks the window while the heading tracks the
   window's left edge, so narrowing the window *grows* the gap between the text
   and the first specimen.

   With saturated art there is no ink ceiling underneath as a second line of
   defence — white over the yellows in this frieze would read at under 2:1.
   The scrim is the whole guarantee, which is why its stops are derived from
   the tagline's **measured** width in the shipped font rather than estimated,
   with the table recorded at the declaration in `_sass/_masthead.scss`. The
   tagline's length is therefore a layout constraint; `_config.yml` says so.

2. **The art's ground is the site's ground.** The export remaps the
   generator's background to `--ground`, so the scrim and the image meet with
   no seam. Measured on the shipped file: `#3c322a` against the token's
   `#3a332b`, one WebP quantisation step.

**Below 700px the art comes out from behind the text** and sits under it as a
140px frieze (`.ex-masthead__band::after`), between the heading and the page
body. The scrim treatment cannot work down there — the text column is the full
width, so an opaque scrim would cover the whole picture — but that is an
argument against putting the art *behind* the text, not against showing it.

The frieze has no scrim and must never grow one: nothing is set over it, which
is the only reason it is safe. Its height is derived rather than chosen.
`background-size: auto 100%` ties the art's rendered width to its height at the
file's 5.505:1, so covering the widest viewport this rule sees (699px) needs at
least 127px; 140px clears that with room. The pay-off is that **the specimens
never shrink**: a 320px phone shows about six of them at full size and a 699px
tablet about thirteen of the same size, where scaling the whole strip to the
width would fit all fourteen at 28px each and read as coloured noise.

It is the same file at both sizes on purpose. At 140 CSS px on a 3× phone the
frieze wants roughly 420 × 2100 device pixels, which is close enough to the
shipped 2560 × 465 that a second asset would save nothing and add a second
export to keep in step with the brief.

The same export appears a third time as an inline figure on `/about/`
(2026-08-12), where the herbarium metaphor is explained in words. There it is
content rather than chrome: nothing sits over it, so it needs no scrim, and
the prose figure styles in `_sass/_content.scss` govern it like any other
image.

The H1 is deliberately **tall and narrow** — three short lines capped at `15ch`,
at up to 2.5rem — and sits at the top of the band rather than centred in it.
Both follow from the scrim: the heading's *width* is the width of ground that
has to be painted over the art, so a heading set across the band buys its own
size out of the specimens. Three lines make the block ~337px wide where one
line was 603px, and the type is 54% larger at the same time.

The **lockup** is the `arc42` mark plus the word *Examples*, in the bar, in
sans (Two Voices Rule — it sits inside a link in the chrome). It moved there
from the hero on 2026-08-07. The word is sized off the mark, not off the nav:
the logo renders 28px of cap height, Atkinson's cap height is 0.67em, so
2.375rem sets the two at the same visual size. The hero's H1 is the
**tagline**, this page's only H1 and its actual subject line; the site name is
not repeated below the wordmark that already says it.

Brand left, then **search and nav pushed to the right end** of the bar by an
auto margin on the lockup. The search `<form>` is last in the DOM and last on
screen, so the tab order still runs the way the eye does.

## What the home page owes the fold

The band is the site's best asset and it is staying at full height. What could
not stay is what sat between it and the examples. Measured before 2026-08-12:
the grid began **672px** down at 1440×900 and **1060px** down at 390×844, so
**no tile was fully above the fold at any width** — a page whose entire job is
handing over six examples opened with a claim, then two paragraphs that sent the
reader to two other sites.

So the page is now ordered by what a visitor came for. Above the grid: one
sentence saying what the things below it are. Below the grid: everything that
points away from this page — `docs.arc42.org` for section-sized illustrations,
`/in-the-wild/` for what we may not host. They live in an `endnotes:` front
matter block on `index.md` and render through `markdownify` into a slot in
`_layouts/home.html`, because they are content and content belongs in the page
file, not the template. They are set at `--muted` and one step down in size:
they are footnotes now, and the only reader they are for is one who has already
scrolled past six examples and still wants something else.

The grid top moved 672px → **528px** at 1440×900 and 1060px → **804px** at
390×844, and the document got 275px shorter, without touching the hero. Three
tiles then stood ~94% visible on a 1440×900 first screen.

Removing the filter and trimming the stacked shells (2026-08-12, see *The
filter is gone* and *The field*) moved it again: **512px** at 1440×900 and
**728px** at 390×844, on a 4164px document. The first row's tiles end at
909px against the 900px fold — three tiles 98% visible, nine pixels short.
Those nine are not coming out of the frieze either.

## The field

The dashboard sits on a full-bleed `--wash-calm` band (2026-08-12): paper
intro, wash field, paper endnotes. A tile's fill is `--paper` and so is the
page's — 1.00:1 — so the tile's border was the only thing making it an object,
and six outlines drawn on one continuous sheet read as a single grey area,
which is why the grid squinted into nothing after the hero's burst of colour.
Paper on the field is 1.15:1: not a recorded contrast claim, a figure-ground
step — six sheets of paper lying on a desk.

Full-bleed and not a box at the grid's width, because a wash box wrapped
around the tiles is one more card, and this family does not nest cards in
cards. The band forced the home layout from one shell to three (the field must
sit outside any shell to run edge to edge); the stacked shells trim their
facing edges — declarations in `_sass/_base.scss` and `_sass/_dashboard.scss`
— or every seam would carry 96px of doubled padding.

The field is what moved the edge tier from 55% to 60%: see *Surfaces*.

## Announced examples

An example may go on the dashboard before it is written: `upcoming: true` in
its `index.md` (2026-08-14, first used by RGCAT). The tile is real, in the
real grid, at its own `order` — not a placeholder card appended after the
others, because a separate rail for "soon" would be a second dashboard, which
is the mistake `/in-the-wild/` exists to avoid making twice.

It is marked three ways, and the reason there are three is that each one alone
is deniable:

- **Recessed fill and a dashed border.** The fill mixes `--paper` 60% toward
  the field; the border keeps its weight and colour and changes only its
  *style*. Both are deliberate alternatives to `opacity`, which was the first
  instinct and fails the site's own floor: `--ink` at 60% over `--paper` lands
  near 4.3:1 and the `--muted` eyebrow near 2.9:1, so the two rows a reader
  most needs — what it is, and who is building it — would be the two that stop
  passing. Stepping the surface keeps every foreground token exactly as
  computed elsewhere: 12.3:1 and 5.1:1, both still AA. The tile reads as
  recessed because it is recessed, not because its text is half erased.
- **A diagonal `COMING SOON` band**, `--ground` with `--tint` on it (12.44:1),
  rotated −8°, clipped to the tile. **No new hue**: the obvious colour for
  "not ready" is amber, and amber is spoken for by the pinned-annotation voice
  — a second meaning on the same pigment is how a palette stops meaning
  anything. The ground is already this family's "chrome, not content" signal,
  which is what a stamp is. It is real text in the flow, not generated
  content: a reader who cannot see the band must still be told, and it sits
  after the title so it reads as "RGCAT — coming soon".
- **The goal clamped to three lines.** Unclamped, the band cut a line in half
  and the tile shipped a sliced word, which reads as a broken render rather
  than a stamp. The clamp is also what makes the band's position predictable:
  capped goal above, bottom-anchored scale below, band in the space left.

Two consequences elsewhere, both load-bearing. The catalogue numeral is
hidden — an unwritten example has a place in the order but nothing catalogued.
And the intro sentence counts announced tiles **separately** (`index.md`),
because it calls everything it counts "a complete architecture documentation"
and an announced tile has no sections at all; folding it into the number made
the page's first claim false.

`decisions` and `keywords` are not owed, and `scripts/check-system-fields.sh`
exempts an upcoming system from both rather than inviting invented ones — but
it still reports supplying one without the other. The four tile fields are
owed either way: an announced tile that says nothing about what is coming is
just a gap in the grid.

## The filter is gone

The dashboard filter (label, search input, live count, empty state,
`filter.js`) was removed on 2026-08-12, answered by one question: what did it
do that ⌘K does not? It substring-matched a hidden front-matter haystack;
`search.json` indexes the **full body text of every section**, where the words
a reader actually types — "Drools", "template method" — live. The filter's
reach was a strict subset of the search's, it carried a standing trap (it
matched `technologies`, which appear nowhere on the tile, so a hit could look
like a false positive), and its own header comment set its ceiling at ~15
examples. At six, the eye narrows a visible grid faster than typing does.

Two things replaced it, neither optional: the tile front matter it used to
match moved into `search.json`'s landing records, so nothing stopped being
findable; and the intro sentence now states the collection's size from a
computed count (`index.md`) — at rest, the old page never said six examples
existed until you typed. If the corpus ever approaches the old ceiling, the
thing to build is a row of domain facets — which needs the closed vocabulary
below — not a text box.

## In the wild — a bibliography, not a second dashboard

`/in-the-wild/` lists arc42 documentation we link to but do not host, from
`_data/in-the-wild.yml`. Expected size 10–40 entries. Component `.ex-wild`,
styles in `_sass/_in-the-wild.scss`.

**The name is load-bearing** (renamed from "Elsewhere", 2026-08-09). The home
page hero is a *herbarium*: specimens collected, pressed and mounted in one
identical format. *In the wild* is the exact complementary category — the same
plants, where they actually grow, uncollected by us. The site's own metaphor
therefore carries the distinction this page has to make, before the disclaimer
says a word. Nothing else on the site depends on the word, but a rename back to
something inert would cost that.

**It has no tiles, and that is the design.** A dashboard tile is not a card, it
is the summary of a completed audit: `domain`, `main_goal`, three `decisions`,
three `technologies`, `scale`. Every one of those fields can only be filled in by
someone who has read all twelve sections. For a link nobody here has audited, a
tile would be either half-empty or fabricated — so the data file deliberately
has no field to put in one.

What the page uses instead is **genre**. Name, byline, description, note, a
column of labelled facts, a rule between entries: that is a bibliography, and a
reader identifies it as a different kind of thing from a dashboard before
reading a word of the disclaimer. This matters because the Visible-Token Rule's
sibling constraint applies here too — a purely visual distinction must never be
the only signal. "The same tile with a dashed border" was considered and
rejected for exactly that reason: near-equivalence is what implies equivalence
of quality.

**The list is grouped into runs** (2026-08-11), named and ordered in
`_data/in-the-wild-runs.yml`, with each entry naming its run in `group`. The
order is editorial and roughly easiest-first, and nothing is sorted at render
time. A run is marked by space and a Caslon heading, pointedly not by a rule:
there is already a rule between entries, and two breaks on one axis leave only
weight to tell them apart. An entry whose `group` matches no run renders
unheaded at the foot of the page and fails `make check`.

**Every entry is addressable.** Its `<li>` carries the slugified title as an
`id`, `search.json` emits one record per entry pointing at that anchor rather
than one record for the whole page, and from eight entries up the page renders a
contents block listing every title under its run. Below eight, every run heading
is already on screen and an index would print each title twice for nothing.

**The facts are a labelled `<dl>`, not a hairline facts line** (2026-08-11).
Four rows in a fixed order, Sections first because it is the question every
visitor has. An absent licence prints "not stated" and an absent language prints
"English", so the first three rows always render and only `year` can be missing;
that fixed order is what lets a reader compare a value to the same value one
entry below. Above 1040px the `<dl>` is a 200px rail beside the reading column,
with one continuous rule per run; below that its rows wrap into a single line
under the entry.

`sections` is the one value printed twice, and deliberately: in the rail, where
it can be compared down the page, and beside the kind chip above the title,
where it arrives *before* the decision it informs. On a phone the rail lands
after 150 words of our opinion, which is the same fault this page already fixed
by moving the destination host up to the byline.

Two smaller departures, both deliberate:

- **Links open in the same tab**, unlike the external links in the footer. A
  page whose entire content is off-site links would spawn one tab per click,
  and WCAG 2.2 §3.2.5 asks us not to open windows without warning. The
  destination host is printed under the title beside the author; showing where a
  link goes *is* the warning, and that only works while it is visible at the
  moment the reader decides to click. For the same reason these links carry no
  `rel="noopener noreferrer"`: see `_includes/in-the-wild-entry.html`.
- **The disclaimer appears once**, in the framing paragraph, not per entry.
  Thirty repetitions of "not reviewed" is noise.

**An entry may now carry more than one link** (2026-08-15). It could not until
then, and the rule was inherited rather than reasoned: one link per *tile* is
the stretched-link invariant of `.ex-system-tile`, and `.ex-wild` has no
stretched link, so nothing structural was ever at stake here. What is at stake
is the same-tab rule above, and each of the three link sites answers it its own
way:

- The **title link** is the documentation, always, and prints its host on the
  byline beneath it. An entry whose title link points at a project's home page
  instead has become an advertisement.
- **`links:`** is up to three labelled rows at the foot, under the note's
  signature, for where the project lives: its own site, its source, its
  maintainer. The link text *is* the bare host, so the warning is the link. A
  `<dl>`, so the `<dt>` supplies the accessible name that "swcode.io" alone
  cannot. The labels are a closed vocabulary for the same reason `kind` is: the
  block earns its place only if a value can be compared to the same value one
  entry below. Never funders or commissioning bodies, which are provenance and
  belong in the note.
- **The note is markdown** and may link inline. Here there is no host to print,
  so the schema requires the *link text* to name the destination. The case that
  bought this was "openCode, the German public sector's Platform for Digital
  Sovereignty", where the useful part is the aside that it is not `opencode.ai`.
  A labelled row cannot make that remark; a sentence can.

Link rot is the page's one running cost, and it grew with the above:
`check-external-links.sh` now reads markdown link targets out of notes as well
as `url:` keys, because a dead link inside a sentence is worse than a dead one
in the rail. The sentence goes on asserting whatever it claimed about the
destination. `make check-external` reads the data
file and requests every URL; it is **not** part of `make check` or
`make check-links`, because a build must not fail over somebody else's server.

## Site-local components

All prefixed `.ex-`, never `.arc42-`. Per the **Same-Name Rule**, a family class
name is a published interface; a component that deviates from the family spec
takes a different name rather than shipping a second incompatible design under
a shared one.

- **`.ex-tile`** — dashboard tile. Neutral paper, hairline border, flat at rest,
  hover-lift (the one sanctioned dynamic shadow). Stretched link: one real `<a>`
  expanded by a pseudo-element, so exactly one link per tile reaches the tab
  order and the accessibility tree. Its boundary is `--wash-edge` (4.00:1 on
  its own paper, 3.48:1 on the field), not a hairline: the border and the
  field step are together the entire difference between an object and a sheet
  of paper.

  **No pills at all** (2026-08-11): `decisions` is a plain list of at most three
  clauses, and `technologies` — the last chip row to survive on the dashboard —
  no longer renders on the tile. The chips were a fourth texture, the loudest
  one, repeating what the decisions had usually just said in words. They render
  in full on the system's own page and are indexed on the landing record in
  `search.json`.

  **And no tagline** (2026-08-12). Removing the chips took away the tile's
  newest information and left its most redundant: `tagline` and `main_goal` were
  two paragraphs saying one thing on half the corpus — "Broken-link checker for
  generated HTML documentation" directly above "Find broken links and missing
  images in generated HTML". The goal is the sentence that tells one example
  apart from another, so the goal is the one that stayed. The second paragraph
  also cost the row its alignment: two blocks wrapping to different depths put
  the decision list at a different `y` in every tile, and comparing across a row
  is the one thing a dashboard is for. A tile is now domain, number, title,
  goal, three decisions, scale — and the six titles sit on one baseline.

  **A creator byline, on third-party tiles only** (2026-08-12). A third-party
  system — `contributed: true` in its front matter, a dedicated boolean
  because `imported:` is a date every system carries — closes its tile with
  one muted line, "Created by Umweltbundesamt (UBA)", derived from the
  `attribution` field the overview page already prints. Site-authored tiles
  show nothing: the line credits the creator on the page most visitors see,
  it does not caption every tile. The verb is "Created", not "Contributed"
  (2026-08-12): the corpus holds both an actively contributed documentation
  (UBA, by Freigabe) and a licence-based import (docToolchain, MIT), and only
  creation is true of both. It is plain text, never a link — one
  link per tile is the stretched-link invariant — set a step below the scale
  line at 0.8125rem `--muted`. The placement is the alignment argument: title,
  goal and decisions are what a reader compares across a row, and a
  variable-height line anywhere above the bottom tier would push all of them
  off the shared baseline on exactly the tiles that carry it. So it renders
  last, under the scale line's hairline, where it costs only its own height.

  The grid itself is capped at `--measure-wide` (2026-08-12). It had no
  `max-width` at all, so it ran the full shell: 4 × 320px at 1440 *and* at 1920,
  six tiles landing 4 + 2 with half an empty row before the footer, and a track
  narrow enough to wrap three of the six domain eyebrows onto two lines. The
  cap was already written for this element in `_sass/_tokens.scss` and had never
  been applied to it.
- **`.ex-chip`** — the kind label on `/in-the-wild/`, and since 2026-08-12 the
  only chip on the site, styled in `_sass/_in-the-wild.scss` where its only
  user lives. Deliberately *not* `arc42-tag`: the family spec for that is
  "site-hue wash, always links", and this is neither. **A value earns a pill
  only if it can recur.** The dashboard carried 58 chips across six tiles with
  55 singleton values and lost them all (2026-08-11); the system facts block
  kept its three chip rows a day longer and lost them on two counts. The
  count this rule asks for: `technologies` measured 15-of-17 singletons,
  `keywords` 3-of-3, and `decisions` are one-off clauses by definition. And a
  second fault the dashboard never had: the facts chips were non-interactive
  bordered rounded boxes one scroll above the section grid's 24 bordered
  rounded cells that really are links, so the one shape that page teaches to
  mean "click me" was worn by things that do nothing. The facts block now
  prints decisions as the same plain list the tile uses and technologies and
  keywords as middot-separated plain text, the way `/in-the-wild/` prints its
  facts. The surviving chip passes both halves of the law: `kind` is a closed
  three-value vocabulary that recurs by construction, and nothing box-shaped
  on its page is a link. The `--tech` mono variant died with the facts chips.
- **`.ex-wild`** — the external reading list. Defined as much by what it
  omits as by what it has: no border, no fill, no radius, no hover-lift, no
  stretched link, no catalogue number, and **exactly one chip** — `kind`, from a
  closed vocabulary (`Production system` · `Invented subject` ·
  `Student coursework`), above the title with section coverage printed beside it
  as plain text (2026-08-11). Everything else that was a chip is one line of
  plain text under the byline. Eighteen pills across five entries were the most
  clickable-looking things on a page where the title was then the only link, and
  at one weight they gave a reader nothing to rank. Since 2026-08-15 an entry
  may also carry inline links in its note and a `.ex-wild__also` block of up to
  three at the foot; the chip argument is unchanged, because none of those are
  box-shaped either. See the section above.
- **`.ex-review`** — an arc42 review note (2026-08-14): a subjective remark by
  a named arc42 maintainer, pinned into a section's prose at the passage it
  discusses, the way a comment lands in an architecture-documentation review.
  The corpus imports documentation **as-is**, so the one voice on a section
  page that is ours must never be mistakable for the content it interrupts —
  the note wears the pinned-annotation treatment (`--wash-calm`, hairline,
  offset shadow), two devices apart from the blockquote-with-rule the imported
  originals use for their own asides. It also sits **off the prose grid**:
  stepped in from the left at every width, and from 1250px up overhanging the
  column's right edge into the empty paper beside the measure (budget measured
  at the declaration in `_sass/_review.scss`) — aligned flush, it read as one
  more text box in the document's own flow, the opposite of its job. It opens
  with a head row: the **review
  pin** glyph (`_includes/review-pin.html`, the ball-head pin the shadow
  metaphor implies, `aria-hidden`), the uppercase kind label, and the
  reviewer's name. The note also carries the site's one content-page dose of
  colour (2026-08-14): the pin's ball-head and a 4px strip along the card's
  top edge are `--arc42-amber` — the family's sticky-note colour, which is
  what the pinned-annotation metaphor says this card is. That is amber's
  registered second surface job (declared with measurements at
  `_sass/_tokens.scss`); the disclaimer wears the same strip, the
  source-and-licence note pointedly does not — the accent belongs to the
  review voice, not to pinned annotations in general. All of it decorative:
  amber is 1.3:1 on the wash, so the hairline, shadow and labelled head row
  carry the boundary, and the label carries the meaning — a visual mark is
  never the only signal. Authoring is **sidecar** (ADR-0009, 2026-08-14,
  superseding the first day's inline-capture model): note texts live in one
  review report per system, `_data/reviews/<slug>.yml` — deliberately
  outside the author's directory, because the review is the maintainers'
  voice, not part of the contributed work — and the section `.md` carries a
  one-line marker, `{% include review-note.html id="…" %}`, at the commented
  passage, while `_originals/` stays the untouched as-is proof. Each note has
  a `title` (the finding's headline) and an anchor. The framing — these are
  our subjective opinions, the original is unchanged — appears **once per
  system** on the overview, per the in-the-wild precedent that a disclaimer
  repeated per instance is noise; it is **derived from the report file's
  existence**, not flagged, so a stale flag cannot exist. Beneath it, the
  **findings list**: one line per note — location, headline, reviewer —
  linked to the note's anchor; the full text renders solely at the passage,
  never twice. `check-review.sh` in `make check` holds the marker⇔entry
  bijection both ways, entry completeness, signatures, and orphaned reports.
  Styles: `_sass/_review.scss`, ratios recorded at the declarations.
- **`.ex-spine`**, **`.ex-rail`**, **`.ex-stepper`**, **`.ex-sectiongrid`**,
  **`.ex-facts`**, **`.ex-pinned`**.

The **pinned-note shadow** (`3px 3px 0 0 var(--ground-deep)`, zero blur, zero
spread) has exactly one genre here: annotations pinned onto the page, which is
what the family reserves it for. Until 2026-08-14 that meant one element, the
source-and-licence note on a system overview; it now also marks the arc42
review notes and their overview disclaimer — the same genre, our voice pinned
onto somebody else's document, never headings and never cards at rest.

## Surfaces

Three tinted surfaces plus the code wash, each with one job — the family cap:

| Token | Job |
|---|---|
| `--wash-calm` | the kind chip, facts block, pinned note, code — and the dashboard field |
| `--wash-active` | the current row in the rail |
| `--wash-hover` | every interactive hover fill |
| `--wash-border` | hairlines and `::marker`s — decorative, 1.98:1 |
| `--wash-edge` | component boundaries — **4.00:1** on paper, **3.48:1** on the field; the tier that must be seen |

**The edge tier is new (2026-08-12) and it exists because the old table was
wrong.** `--wash-border` was described here as "the border tier that must be
seen" and measures **1.98:1** on `--paper` — two thirds of the 3:1 WCAG 1.4.11
asks of anything that identifies a component. It was drawing decorative
hairlines and `::marker`s *and* the outline of the dashboard tile, whose fill is
`--paper` on a `--paper` page: **1.00:1**, so that one line was the only thing
making a tile a tile. Six examples read as a single grey field, and the filter
input's border — the filter has since left, see above — failed outright with
no decorative argument available.

`--wash-edge` is 60% of the ladder, `#827d78`, measured — resolved and read
back from a canvas in headless Chromium, which reproduces the recorded 55%
literal byte for byte by the same route. It was 55% for part of one day: the
50% step was rejected because it resolves to `#95918e` at 3.07:1, a pass one
rounding step wide, and this site does not record ratios it would not defend —
and then the dashboard gained its `--wash-calm` field, against which the 55%
step is 3.04:1, the same one-rounding-step pass one surface later. At 60% the
edge clears both of its neighbours with room: 4.00:1 on paper, 3.48:1 on the
field, against ~1.25:1 for the divider inside the tile — two tiers apart
enough to read as two.

The tier holds every whole-surface click target's boundary, and that is now
two components: the dashboard tile, and (2026-08-12, later than the tile and
by the tile's own argument) the section grid's twelve cells, which had been
left at `--wash-border` — the same 1.98:1 fault on the site's other
whole-cell target. The grid sits on paper with paper-filled cells, so its one
measured pair is 4.00:1; its hover state needed no matching change, because
the hover border is `--ground-deep` (14.12:1 on paper) over a `--wash-calm`
fill, still tiers above the new rest state.

## Measure and breakpoints

Prose caps at `--measure: 68ch`. Non-prose blocks (tables, diagrams, code) may
take `--measure-wide` (~116ch) and scroll inside their own container — the page
body never scrolls sideways.

**1ch is 11.016px**, measured from the shipped woff2 and not estimated. CSS
defines `ch` as the advance of `0`, which Atkinson Hyperlegible Next sets at
648/1000 em, so at the 17px body size it is 11.016px and `--measure` renders at
749.1px. The 9.35px this section used to quote is the advance of `n` (550/1000):
a different letter, and 0.85 of the right number.

`/in-the-wild/` has exactly one breakpoint, **1040px**, and the shell has two
widths either side of it: the measure plus its own padding below (797.1px), the
measure plus the 200px rail and its gap above (1029.1px). The reading column is
68ch on both sides. The derivation is in `_sass/_in-the-wild.scss` at the
declarations.

The systems rail collapses at **1040px**, and it collapsed at 940px until
2026-08-11, which was wrong by one letter. `_sass/_rail.scss` put 1ch at 9.35px
and attributed it to the `0` advance; 9.35px is the advance of `n`. At the real
11.016px the railed layout gives 1056px → 68.1ch, 1040px → 66.6ch, 1022px →
65.0ch and 940px → 57.6ch, so the old breakpoint sat 7ch below the floor the
same comment invoked. 1022px is where the prose breaks and 1040px is the
nearest step that clears it with room. 1024px was rejected: it clears by 0.18ch,
and it is a tablet width.

**Both rails on this site now collapse at 1040px** — the systems rail and the
one on `/in-the-wild/` — by different arithmetic and to the same answer.

940px survives as the **masthead's** own breakpoint, which is where the brand,
the nav and the search field stop fitting on one line. It is no longer the same
number as the rail, and `_sass/_masthead.scss` says so at the declaration.

Below the rail breakpoint the rail becomes a horizontal scrolling strip rather
than disappearing: a twelve-part document must stay navigable on a phone.

## Open decision: colour on tiles

Tiles are currently **neutral**, and the domain is carried as text. This was a
deliberate choice at design time, and it has a cost worth restating: the site's
subject is variety across domains, and none of that variety is expressed in
colour — the spine is the only colour on the page.

The hook for changing it is already in the markup: every tile carries
`data-domain="<slugified domain>"`. Turning that into quality.arc42.org's
`--cat` mechanism is one attribute selector setting one custom property, with no
template edit and no content migration.

If it is ever taken up, two things must come with it, not after it: a **legend**
(colour must never be the only category signal) and a **fixed domain
vocabulary** (today `domain:` is free text).

That second condition is stronger than it sounds, and it is now measured: the
six `domain` values are six distinct strings for six systems, so the mechanism
would today produce **six colours for six single-member categories**, plus a
legend of six entries with one item each. That is not a category system, it is a
colour-coded list. Two of the values also carry two axes in one slash
("Personal / fitness tracking" is audience plus domain, "Embedded / law
enforcement" is platform plus sector), and three of six wrap to two lines at
1440px and push their tile titles out of alignment across a row.

So the vocabulary has to close **before** the hook is switched on, not with it:
terms that can recur, at most 18 characters (the eyebrow track is ~174px after
the catalogue number's 3rem clearance), no "/" in a value, and a
`check-system-fields.sh` beside the existing wild-fields check to hold it.

**Decided against closing it, for now (2026-08-12).** The taxonomy question
was put directly — close `domain` into a fixed vocabulary, or go loose the way
docs.arc42.org tags its tips — and the answer was keywords. `domain` stays
free text on the eyebrow, and the corpus gains an optional `keywords:` axis
instead (`_systems/_TEMPLATE/index.md`): loose like blog tags, reusing the
docs.arc42.org tip vocabulary where it fits, so the two sites stay searchable
in the same words. The two are different axes and must not be conflated — the
domain says what the *system* is, keywords say what the *documentation
demonstrates*. Keywords render as plain text on the system's own page, are
indexed by the site search, and never appear on the tile.

**Keywords adopted corpus-wide (2026-08-12, follow-up).** The optional
`keywords:` axis is no longer optional in practice: all seven systems now
carry 3–5 values from one deliberately small shared vocabulary — ten terms,
every one taken verbatim from docs.arc42.org's tip keyword index, every one
used by at least two systems (median recurrence 3). The axis means what the
template says it means — what the *documentation* demonstrates, never what
the system is — and its first use, which had conflated it with `domain`, was
repaired to match. The owed `check-system-fields.sh` now exists beside the
wild-fields check and is wired into `make check`: it holds the five tile
fields present, the silent `limit: 3` on decisions honest, and every keyword
lowercase-kebab, without closing the vocabulary. An "all keywords" index page
stays deferred, on the same precedent as the cross-system section views: it
is worth building once recurrence makes it more than a table of contents.

**UBA-SNS parked (2026-08-12).** The UBA-SNS example is temporarily off main
— branch `uba-sns-review` holds its latest state — while the Umweltbundesamt
takes a final look before publication. Counts in this file that say seven
systems include it; the live corpus is six until the branch merges back, and
no tile currently sets `contributed:`, so the byline renders nowhere.

The consequence for this section is honest bookkeeping: the precondition for
colour is now unmet by decision, not by omission. The `data-domain` hook stays
in the markup at zero cost, but the tint stays off until someone reopens the
vocabulary question — and the site's colour story below the hero is the wash
ladder (see *The field*), not hues.

## Deferred: cross-system section views

A `/sections/03-context/` page listing every system's section 3 — the "all
context views together" idea — is **not built**. The structure already supports
it: every section file carries `order`, so the page is a short Liquid loop over
`site.systems` grouped by `order`. It was left out of the first version because
it is worth building once there are enough examples for a comparison to say
something.

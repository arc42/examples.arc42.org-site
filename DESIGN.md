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

**The home page carries no spine** (2026-08-07). The hero band there is a row
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
auto margin on the lockup. The nav is last in the DOM as well as last on
screen, so the tab order still runs the way the eye does.

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
is the summary of a completed audit: `domain`, `main_goal`, four `decisions`,
six `technologies`, `scale`. Every one of those fields can only be filled in by
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

Link rot is the page's one running cost. `make check-external` reads the data
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
  order and the accessibility tree.
- **`.ex-chip`** — keyword label. Deliberately *not* `arc42-tag`: the family
  spec for that is "site-hue wash, always links", and these are neither.
- **`.ex-wild`** — the external reading list. Defined as much by what it
  omits as by what it has: no border, no fill, no radius, no hover-lift, no
  stretched link, no catalogue number, and **exactly one chip** — `kind`, from a
  closed vocabulary, above the title (2026-08-11). Everything else that was a
  chip is one line of plain text under the byline. Eighteen pills across five
  entries were the most clickable-looking things on a page where only the title
  is a link, and at one weight they gave a reader nothing to rank. See the
  section above.
- **`.ex-spine`**, **`.ex-rail`**, **`.ex-stepper`**, **`.ex-sectiongrid`**,
  **`.ex-facts`**, **`.ex-pinned`**.

The **pinned-note shadow** (`3px 3px 0 0 var(--ground-deep)`, zero blur, zero
spread) has exactly one job here: the source-and-licence note on a system
overview. That is an annotation pinned onto the page, which is what the family
reserves it for.

## Surfaces

Three tinted surfaces plus the code wash, each with one job — the family cap:

| Token | Job |
|---|---|
| `--wash-calm` | chips, facts block, pinned note, code |
| `--wash-active` | the current row in the rail |
| `--wash-hover` | every interactive hover fill |
| `--wash-border` | the border tier that must be seen |

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

The systems rail collapses at **940px**, and that number is wrong. At 11.016px a
ch, the railed layout gives 1024px → 65.2ch, 940px → 57.6ch and 900px → 53.9ch,
so 940px is already 7ch below the 65ch floor this section invokes; the floor is
crossed at 1022px and the breakpoint belongs at 1024px. Correcting it moves a
breakpoint on every system page, so it is a change of its own and is **not done
yet**: `_sass/_rail.scss` still carries the old number and the `n` advance it
was derived from.

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

## Deferred: cross-system section views

A `/sections/03-context/` page listing every system's section 3 — the "all
context views together" idea — is **not built**. The structure already supports
it: every section file carries `order`, so the page is a short Liquid loop over
`site.systems` grouped by `order`. It was left out of the first version because
it is worth building once there are enough examples for a comparison to say
something.

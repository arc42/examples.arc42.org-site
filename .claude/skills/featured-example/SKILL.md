---
name: featured-example
description: Change, extend, or retire the featured example on the examples.arc42.org home page, the one system shown first in the grid as a two-cell tile with a figure and an "Our pick." sentence. Use when the user wants to feature a different example, extend or end the current feature, reword its sentence, swap its figure, or asks how featuring works.
---

# The featured example

One system, chosen by a maintainer, is moved to the head of the dashboard
grid until a date passes. Rationale and constraints: `DESIGN.md`, section
*Recently added and featured*. Mechanics: the comment block above
`featured:` in the front matter of `index.md`, and the `THE FEATURED
EXAMPLE` comment in `_layouts/home.html`.

## The model (do not deviate)

- **Everything lives in one block**: `featured:` in the front matter of
  `index.md` at the repository root. Changing the feature means rewriting
  that block. There is no other registry, flag or file to edit.
- The featured system **keeps its catalogue number**; `order` in the
  system's `index.md` is never touched. Do not renumber anything.
- The featured tile shows the *Featured* tab only. A recently imported
  system loses its *Added* tab while featured; that is intended, not a bug.
- A name that matches no system, a system with `upcoming: true`, or an
  `until` in the past all fail quietly: the grid falls back to plain
  `order`. So a typo does not break the build, and you must check the
  result yourself (step 6).

## Changing the feature

1. **The system.** `system:` is the directory name under `_systems/`
   (`wirschiffendas`, not the title). It must be a complete example, not an
   announced one.
2. **The date.** `until:` is the last day it is shown, `YYYY-MM-DD`. Ask the
   user if they did not say. The first feature ran about five weeks; when
   asked for a default, propose the end of the following month.
3. **The sentence.** `why:` is printed after a bold "Our pick." It is the
   maintainers' voice, the same voice as an `/in-the-wild/` note, so the
   *Prose style* and *In the wild: be generous* rules in `CLAUDE.md` apply
   in full: no em dash, none of the listed sentence shapes, and nothing that
   would make the author regret publishing. Two sentences, about 40 words,
   as in the earlier features. Lead with what makes the documentation worth
   a reader's hour and name sections by number ("Section 6 lists …").
   Read the system's `index.md` and the sections you cite before writing;
   never praise what you have not read. Use a `>-` folded scalar.
4. **The figure.** `image:` is a path relative to the system's directory,
   e.g. `images/building-block-view-level2.png`. It is shown at roughly one
   tile width (about 300px) and only where the grid has two columns, so pick
   a diagram that is near square or landscape and still legible when small.
   Very wide sequence diagrams and tall deployment views read badly. Look at
   the candidates before choosing. `image` may be left out entirely (see
   the open point in DESIGN.md); drop `alt` with it.
5. **The alt text.** `alt:` says what the figure shows, in a sentence or
   two, not what kind of file it is.
6. **Verify.** Run `make check`, then `make site` and confirm in
   `_site/index.html` that the tile carries `ex-tile--featured` and the
   right title, and that the image path resolves. Remember the quiet
   fallback: a missing featured tile means a wrong `system:` or a past
   `until:`.
7. **Commit** only when the user asks, with a message in the style of the
   history, e.g. `dashboard: feature WirSchiffenDas until 2026-11-30`.

## Extending, rewording, retiring

- Extend: change `until:` only.
- Reword or swap the figure: edit `why:`, `image:`, `alt:`; the rules above
  still apply.
- Retire with no successor: letting `until` pass is enough, but deleting
  the block (and nothing else) keeps the front matter honest. Leave the
  comment block above it in place, so the next feature knows how it works.

## Do not touch

The tile markup (`_includes/system-tile.html`), the placement logic
(`_layouts/home.html`) and the styling (`_sass/_dashboard.scss`) are design
decisions recorded in DESIGN.md. Choosing a new featured example is not a
reason to change them.

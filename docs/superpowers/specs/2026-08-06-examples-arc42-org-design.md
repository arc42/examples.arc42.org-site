# examples.arc42.org — design spec

2026-08-06

## Purpose

A new arc42 family site collecting **complete architecture documentations of
real systems**, each written along the twelve arc42 sections. The home page is
a dashboard of tiles; each tile carries the system's domain, main goal,
strategic decisions and technologies as keywords, so a reader can choose an
example in seconds.

Expected scale: 2–5 examples at launch, 12–15 at maturity. Individual systems
do not evolve — each is a snapshot.

Repository: `examples.arc42.org-site` (local now; GitHub deferred).

## Decisions taken

| Question | Decision |
|---|---|
| Content source | Existing public arc42 examples first, community contributions after; user supplies the first set |
| Source format | Markdown canonical, converted once; source material archived per system in `_originals/` |
| Nav colour | Family-token spine on a neutral ground |
| Boundary vs docs.arc42.org | Deliberate duplication, no coupling — same contract as arc42.org / arc42.de |
| Colour semantics | Decoration only; tiles neutral, domain as text |
| File granularity | One file per arc42 section |
| In-example navigation | Left rail + prev/next stepper + breadcrumb |
| Governance | ADR-0008 + BRAND.md/DESIGN.md updates + site DESIGN.md + CONTRIBUTING |
| URLs | `/systems/<slug>/<NN-section>/` |
| Scope of first build | Design doc + local repo + working scaffold with one placeholder |

## The finding that shaped the design

The arc42 hue registry is **full**. Sweeping the colour space at family chroma
(HSL S 28–65%, L 30–62%) under both family bars — 7:1 white-on-band, and 18.8
ΔE00 separation from every registered hue and shared token — exactly one region
survives: dark brass near hue 51° (`#8c7c22` / band `#635718`).

- Green is closed by faq's band `#1b5648` and `--arc42-green-ink` (best green
  candidate 10.4 ΔE00).
- Violet/indigo is closed by the hub navy (best 9.5 ΔE00).
- Warm is closed by sienna, rose and amber.

BRAND.md's own note — "a future satellite will need greens… or a cooler violet
away from quality's plum" — is therefore optimistic; both escape routes are
already blocked.

**Chosen instead:** examples owns a *device, not a hue*, following the precedent
ADR-0007 set for status.arc42.org. Ground `#3a332b` umber graphite (white
12.44:1), 13.9 ΔE00 from status' slate and 19.3 from the masthead navy — more
separation than slate has from navy (8.9), so the precedent holds a fortiori.

The device is the **spine**: six shared family tokens tiled edge to edge in a
6px rule under the masthead, in deliberately non-spectral order (weakest
adjacent pair 30.1 ΔE00). It uses no site's signature hue, so ADR-0001 holds
literally, and it is not status' spectrum rim — discrete family tokens, a
straight rule, on the masthead rather than the favicon ring.

## Architecture

### The modularity contract

One directory *is* one system. Adding an example is `make new-system SLUG=…`;
removing it is `rm -rf`. **No file outside the directory is ever edited** — no
navigation config, no index, no registry.

This holds because the slug is derived from the directory name in
`_includes/system-context.html`:

```liquid
{% assign sys_slug = page.path | remove_first: '_systems/' | split: '/' | first %}
```

so section files carry only `title` and `order`. The single exception is the
`permalink:` in each system's `index.md`, which `make new-system` rewrites.

Two conventions are load-bearing rather than cosmetic:

- `_originals/` keeps its leading underscore — Jekyll's `EntryFilter` skips any
  path segment beginning with `_`. Renaming it publishes every source file.
  Same mechanism excludes `_systems/_TEMPLATE/`.
- Images live in each system's `images/` and are referenced relatively.
  *Verified at build*: collection static files are published to
  `/systems/<slug>/images/…`, exactly where `../images/…` from a section page
  resolves.

### Units

| Unit | Does | Depends on |
|---|---|---|
| `system-context.html` | Resolves slug → system doc + ordered sections | `page.path`, `site.systems` |
| `home.html` + `system-tile.html` | Dashboard from `index.md` front matter | the collection |
| `system.html` | Overview: facts, prose, 12-cell grid, attribution | `system-context` |
| `system-section.html` | One section: rail, breadcrumb, prose, stepper | `system-context` |
| `spine.html` + `_data/spine.yml` | The device | data only |
| `filter.js` | Progressive-enhancement dashboard filter | nothing; tiles pre-rendered |
| `check-brand.sh` | ADR-0003 mechanical floor | none |

### Front matter contract

`_systems/<slug>/index.md` **is** the tile: `title`, `tagline` (≤60 chars),
`domain`, `main_goal`, `decisions` (≤4), `technologies` (≤6), optional `scale`,
`order`, and the required provenance trio `attribution` / `licence` /
`source_url`.

Section files: `title` and `order` (1–12) only.

### Accessibility

Light-only, AA minimum, every text-bearing pair measured and recorded at its
declaration in `_sass/_tokens.scss`. Colour never carries meaning alone: the
current rail item uses weight + rule + fill; links rely on a persistent
underline, not colour; the spine is `aria-hidden` because it means nothing.
Two focus rings, one per surface. Full `prefers-reduced-motion` coverage.

## Verification performed

- `jekyll build` clean; URLs render at `/systems/sample-system/<NN-section>/`
- `_TEMPLATE` and `_originals` confirmed absent from `_site`
- collection images confirmed published to `/systems/<slug>/images/`
- 12 rail items, current marked, stepper prev/next, spine order correct
- html-proofer: 21 internal links, 17 files, passing
- `check-brand.sh`: passes clean; **and verified to fail** on an injected
  retired hex and an injected foreign signature hue
- dev server serves every route (tested on :4001 — :4000 was occupied by
  another arc42 site)

## Deliberately not built

- **Cross-system section views** (`/sections/03-context/`). Enabled by the
  structure — every section carries `order` — but not worth building before
  there are enough examples for the comparison to say anything.
- **Search.** At ≤15 examples the dashboard filter is enough.
- **GitHub repo, push, Pages, DNS.** Outward-facing; awaiting explicit
  go-ahead.
- **Per-domain tile colour.** Hook left in place (`data-domain`); requires a
  legend and a fixed domain vocabulary if ever taken up.

## Open items before launch

1. ADR-0008 and the BRAND.md / DESIGN.md updates must land in
   `meta.arc42.org` before the site is public.
2. Replace the placeholder on-band logo
   (`assets/images/brand/arc42-logo-on-band.svg`) with the family asset.
3. Real examples; delete `_systems/sample-system/`.
4. DNS for `examples.arc42.org`, then GitHub repo + Pages + CNAME.

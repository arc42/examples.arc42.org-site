# Cross-system section views — implementation plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build twelve `/sections/NN-slug/` pages on examples.arc42.org that show how every documented system handled one arc42 section, and point each of the twelve docs.arc42.org section pages at the matching one.

**Architecture:** Twelve front-matter-only stub pages pin the routes; one Jekyll layout renders both bands by looping over system landing pages and resolving each system's file for this section by path. The curated band is declared per system in its own `index.md` front matter (`highlights:`), so the modularity contract holds. docs.arc42.org learns exactly one URL per section from `_data/sections.yml` and renders no data from this site.

**Tech Stack:** Jekyll 4 on GitHub Pages (no custom plugins), Liquid, SCSS, POSIX `sh` guard scripts, Docker for local build, html-proofer.

**Spec:** `docs/superpowers/specs/2026-08-23-cross-system-section-views-design.md` (in examples.arc42.org-site)

## Global Constraints

- **Two repositories.** Tasks 0–7 are in `/Users/gernotstarke/projects/arc42/examples.arc42.org-site` on a new branch `feat/section-index`. Tasks 8–11 are in `/Users/gernotstarke/projects/arc42/docs.arc42.org-site` on a new branch `feat/section-example-links`. Task 12 crosses both. Every task states its repo. Never commit one repo's work from the other.
- **Build examples first.** The routes must exist before anything links to them. Do not start Task 8 until Task 7 is committed.
- **No counts in copy, ever.** Never write how many systems, examples or sections exist. The corpus grows; a number dates the sentence the day it is written. This applies to both repositories.
- **No em dash (`—`) in new prose** in examples.arc42.org-site. En dash (`–`) is allowed in numeric and date ranges only. Use a colon, a comma or a full stop instead. (`CLAUDE.md` in that repo.)
- **Comment density matches the repo.** Both repos comment the *why*, at length, in block comments above the thing. A new Liquid file opens with a `{%- comment -%}` header; a new SCSS partial opens with a `// ====` header. Copy the register of `_includes/system-context.html` and `_sass/_in-the-wild.scss`.
- **No plugins.** GitHub Pages builds these sites. Nothing may need a gem outside the `Gemfile`.
- **Outbound links from docs.arc42.org** carry `target="_blank" rel="noopener noreferrer nofollow"`, matching the two links added on 2026-08-21.
- **The twelve section slugs**, in order, are exactly the section filenames in `_systems/_TEMPLATE/`:
  `01-introduction-and-goals`, `02-architecture-constraints`, `03-context-and-scope`, `04-solution-strategy`, `05-building-block-view`, `06-runtime-view`, `07-deployment-view`, `08-crosscutting-concepts`, `09-architecture-decisions`, `10-quality-requirements`, `11-risks-and-technical-debt`, `12-glossary`.

---

## File Structure

**examples.arc42.org-site** (branch `feat/section-index`)

| File | Responsibility |
|---|---|
| `_pages/sections/index.md` | The parent route `/sections/`. Copy plus the twelve-cell grid. |
| `_pages/sections/01-…md` … `12-…md` | Twelve stubs. Front matter only. The one place the route list is written down. |
| `_includes/section-grid.html` | The twelve-cell jump grid over section-index pages. Used by the parent page and by the foot of each section page. |
| `_layouts/section-index.html` | Renders the two bands for one section. One layout, twelve pages. |
| `_sass/_sections.scss` | Styling for the two bands. Registered in `assets/css/style.scss`. |
| `scripts/check-sections.sh` | Both guards: route slugs match `_TEMPLATE/`, and every `highlights` entry names a section its system has. |
| `Makefile` | `check-sections` target, wired into `check`. |
| `_systems/*/index.md` | `highlights:` added. One edit per system, inside that system's directory. |
| `index.md` | One endnote sentence pointing at `/sections/`. |
| `DESIGN.md` | The "Deferred: cross-system section views" section replaced by what was built. |

**docs.arc42.org-site** (branch `feat/section-example-links`)

| File | Responsibility |
|---|---|
| `_config.yml` | `examples_url`. |
| `_data/sections.yml` | `examples_slug:` per section. The URL scheme, in one file. |
| `_includes/examples-link.html` | Resolves `page.number` to a URL and renders one of two variants. The copy, in one file. |
| `_includes/further-info.md` | One call, `variant="block"`. Its twelve call sites are untouched. |
| `_pages/section-1.md` … `section-12.md` | One call each, `variant="inline"`, after the first `.arc42-help` box. |
| `_sass/_examples-link.scss` | Styling for the inline variant. Registered in `assets/css/style.scss`. |
| `scripts/check-site.sh` | A check that every `sections.yml` entry carries an `examples_slug`. |

---

# Part A — examples.arc42.org-site

Repo: `/Users/gernotstarke/projects/arc42/examples.arc42.org-site`

### Task 0: Branch

- [ ] **Step 1: Confirm a clean tree on `main` at the spec commit**

```bash
cd /Users/gernotstarke/projects/arc42/examples.arc42.org-site
git status --short
git log --oneline -1
```

Expected: `git status --short` prints nothing except possibly `?? _systems/UBA-SNS/` (an untracked work-in-progress directory that `check-structure.sh` deliberately skips — leave it alone). The last commit is `ac05d5f docs: spec for cross-system section views`.

- [ ] **Step 2: Create the branch**

```bash
git checkout -b feat/section-index
```

---

### Task 1: The twelve routes exist and build

The riskiest unknown in the whole plan is whether Jekyll picks up pages nested inside `_pages/`. `_config.yml` has `include: - _pages`, and every existing page sits flat in that directory. This task answers the question before anything is built on top of it.

**Files:**
- Create: `_pages/sections/index.md`
- Create: `_pages/sections/01-introduction-and-goals.md` through `_pages/sections/12-glossary.md`
- Create: `_layouts/section-index.html` (a stub in this task; the bands land in Task 4)

**Interfaces:**
- Produces: twelve pages carrying `layout: section-index`, `section:` (integer 1–12), `slug:` (the `_TEMPLATE` filename stem), `title:`, `blurb:` and `permalink:`. Task 2's guard reads `slug:`. Task 3's include selects on `layout == "section-index"` and sorts on `section`. Task 4's layout reads `page.section`, `page.slug`, `page.title` and `page.blurb`.

- [ ] **Step 1: Write the stub layout**

It renders nothing but the title and blurb yet. That is deliberate: this task proves the routes, and nothing else.

Create `_layouts/section-index.html`:

```liquid
---
layout: default
---
{%- comment -%}
  One arc42 section, across every documented system.

  TWELVE PAGES, ONE LAYOUT. The twelve stubs in _pages/sections/ carry nothing
  but front matter; everything on the rendered page is built here from
  `page.section` and `page.slug`.

  Stub for now. The two bands land in the task that follows this one.
{%- endcomment -%}
<div class="ex-shell ex-shell--prose">
  <h1>{{ page.section }}. {{ page.title }}</h1>
  <p>{{ page.blurb }}</p>
</div>
```

- [ ] **Step 2: Write the twelve stubs**

Each carries a header comment saying what the file is for, because a file that is nothing but front matter invites deletion.

Write this script to a scratch file and run it — twelve near-identical files are worth generating rather than hand-typing, and the generator is the clearest record of what they have in common:

```bash
cd /Users/gernotstarke/projects/arc42/examples.arc42.org-site
mkdir -p _pages/sections

write_stub() {
  num="$1"; slug="$2"; title="$3"; blurb="$4"
  cat > "_pages/sections/$slug.md" <<EOF
---
# A ROUTE, NOT A PAGE. Everything rendered at this URL is built by
# _layouts/section-index.html from the two fields below; there is no body.
#
# \`slug\` is the section's filename inside every system directory, and it is
# the same string as this file's own name. scripts/check-sections.sh asserts
# that the twelve slugs here are exactly the section files in
# _systems/_TEMPLATE/, in order — which is what makes the twelve links on
# docs.arc42.org safe to point here.
layout: section-index
permalink: /sections/$slug/
title: $title
section: $num
slug: $slug
blurb: >-
  $blurb
---
EOF
}

write_stub 1  01-introduction-and-goals   "Introduction and Goals" \
  "What the system does, who wants it, and what it must be good at."
write_stub 2  02-architecture-constraints "Architecture Constraints" \
  "Anything that limits freedom of design."
write_stub 3  03-context-and-scope        "Context and Scope" \
  "The system boundary and its communication partners, business context first."
write_stub 4  04-solution-strategy        "Solution Strategy" \
  "The handful of fundamental decisions that shaped everything else."
write_stub 5  05-building-block-view      "Building Block View" \
  "Static decomposition, level by level, whitebox then the parts worth expanding."
write_stub 6  06-runtime-view             "Runtime View" \
  "How the building blocks interact, for the scenarios that are actually interesting."
write_stub 7  07-deployment-view          "Deployment View" \
  "The technical infrastructure, and the mapping of building blocks onto it."
write_stub 8  08-crosscutting-concepts    "Cross-cutting Concepts" \
  "Concepts that show up in many places."
write_stub 9  09-architecture-decisions   "Architecture Decisions" \
  "Important decisions with their context, options and consequences, worst first."
write_stub 10 10-quality-requirements     "Quality Requirements" \
  "The quality tree, and the concrete scenarios that make the goals testable."
write_stub 11 11-risks-and-technical-debt "Risks and Technical Debt" \
  "Known problems, ordered by how much they hurt."
write_stub 12 12-glossary                 "Glossary" \
  "Domain and technical terms, so everyone means the same thing."
```

- [ ] **Step 3: Write the parent page**

Create `_pages/sections/index.md`. The include it calls does not exist yet; add it in Task 3. For now the page lists the twelve with a plain loop, so this task can be verified on its own.

```liquid
---
layout: default
title: The twelve sections
permalink: /sections/

# Not indexed as a page: search.json already carries a record for every
# section of every system, and this page's body is a list of twelve titles
# that all of them share. A hit here would displace the real one.
search_body: false
---
{%- comment -%}
  The parent route. Every documented system here follows the same twelve arc42
  sections, so the corpus can be read the other way round: pick a section, and
  see how each system handled it.

  The list is built from the twelve stubs in this directory, not written out
  here, so renaming a section is one edit in one file.
{%- endcomment -%}
{%- assign section_pages = site.pages | where_exp: 'p', 'p.layout == "section-index"' | sort: 'section' -%}

<div class="ex-shell ex-shell--prose">
  <nav class="ex-breadcrumb" aria-label="Breadcrumb">
    <ol>
      <li><a href="{{ '/' | relative_url }}">Examples</a></li>
      <li aria-current="page">The twelve sections</li>
    </ol>
  </nav>

  <div class="ex-prose">
    <h1>The twelve sections</h1>
    <p>Every documentation here follows the same arc42 structure, which means
    the corpus can be read across as well as down. Pick a section and see how
    each system handled it: what a building block view looks like when the
    system is small, and what it looks like when it is a federation.</p>
    <p>The template itself, and what belongs in each section, is at
    <a href="https://docs.arc42.org">docs.arc42.org</a>.</p>
  </div>

  <ol class="ex-sectiongrid">
    {%- for s in section_pages -%}
    <li class="ex-sectiongrid__cell">
      <a href="{{ s.url | relative_url }}">
        <span class="ex-sectiongrid__num">{{ s.section }}</span>
        <span class="ex-sectiongrid__name">{{ s.title }}</span>
      </a>
    </li>
    {%- endfor -%}
  </ol>
</div>
```

- [ ] **Step 4: Build, and verify all thirteen routes exist**

```bash
make site
ls _site/sections/
for s in 01-introduction-and-goals 02-architecture-constraints 03-context-and-scope \
         04-solution-strategy 05-building-block-view 06-runtime-view \
         07-deployment-view 08-crosscutting-concepts 09-architecture-decisions \
         10-quality-requirements 11-risks-and-technical-debt 12-glossary; do
  test -f "_site/sections/$s/index.html" && echo "ok  $s" || echo "MISSING  $s"
done
test -f _site/sections/index.html && echo "ok  /sections/" || echo "MISSING  /sections/"
```

Expected: thirteen `ok` lines and no `MISSING`.

**If any are missing**, the nested `_pages/sections/` directory is not being read. The spec records the fallback, and it costs nothing: move the thirteen files to `_pages/` flat, renaming them `section-index.md` and `section-index-01.md` … `section-index-12.md`. **No permalink changes and no URL changes** — the `permalink:` in each file drives the route, not the path. Re-run this step. Then, in the file-path list at the top of this plan and in Task 2's guard, read the stubs from `_pages/` instead of `_pages/sections/`.

- [ ] **Step 5: Verify the grid on the parent page actually listed twelve**

```bash
grep -c 'ex-sectiongrid__cell' _site/sections/index.html
```

Expected: `12`. A `0` means `site.pages` is not seeing the stubs even though their permalinks rendered, which is the same fallback as Step 4.

- [ ] **Step 6: Commit**

```bash
git add _pages/sections _layouts/section-index.html
git commit -m "feat: twelve /sections/ routes and their parent page"
```

---

### Task 2: The route-parity guard

Guard 1 from the spec. This is the thing that makes the twenty-four links from docs.arc42.org safe: the routes cannot drift away from the section files they index without failing a check here.

**Files:**
- Create: `scripts/check-sections.sh`
- Modify: `Makefile` (the `.PHONY` line, the `check` target, and a new `check-sections` target)

**Interfaces:**
- Consumes: the `slug:` front matter written in Task 1.
- Produces: `sh scripts/check-sections.sh`, exit 0 on success, exit 1 with a report on stderr. Task 5 extends the same script with the second guard.

- [ ] **Step 1: Write the guard**

Create `scripts/check-sections.sh`. It follows `scripts/check-system-fields.sh`: POSIX `sh`, no YAML library, a header that argues for the check.

```sh
#!/bin/sh
# ============================================================================
# The cross-system section views (/sections/NN-slug/) and the files they index.
#
# 1. THE ROUTES MUST MATCH THE TEMPLATE. Every system's twelve section files
#    are named by _systems/_TEMPLATE/, which is what makes every system's
#    section 5 live at the same filename. The twelve stubs in _pages/sections/
#    carry a `slug:` that must be exactly those filenames, in order.
#
#    This is the check that makes the outbound links from docs.arc42.org safe.
#    That site hard-codes twelve URLs into _data/sections.yml and renders
#    nothing else from here — deliberately, so no data crosses the boundary.
#    The price of that decision is that a rename here 404s there silently. This
#    is where the noise gets made instead.
#
# Parsed with grep and sed rather than a YAML library so it has no dependency
# beyond a POSIX shell, matching scripts/check-system-fields.sh.
#
# Exit codes: 0 everything lines up, 1 something does not.
# ============================================================================
set -eu

TEMPLATE_DIR="${1:-_systems/_TEMPLATE}"
STUB_DIR="${2:-_pages/sections}"

[ -d "$TEMPLATE_DIR" ] || { echo "check-sections: $TEMPLATE_DIR not found" >&2; exit 1; }
[ -d "$STUB_DIR" ]     || { echo "check-sections: $STUB_DIR not found" >&2; exit 1; }

FAILED=0

# ---- 1. Route slugs vs the template ----------------------------------------
#
# The template's section files are every .md in it except index.md. Sorted by
# filename, which for NN-name.md is the arc42 order.
expected=$(ls "$TEMPLATE_DIR"/*.md \
           | sed 's|.*/||; s|\.md$||' \
           | grep -v '^index$' \
           | sort)

# The stubs' declared slugs, from front matter only. `sort` on both sides means
# the comparison is about the SET and each member's spelling; the numeric
# prefix is what carries the order, and it is part of the string.
actual=$(grep -h '^slug:' "$STUB_DIR"/*.md 2>/dev/null \
         | sed 's/^slug:[[:space:]]*//' \
         | sort)

if [ "$expected" != "$actual" ]; then
  echo "check-sections: the /sections/ routes do not match _systems/_TEMPLATE/" >&2
  echo "" >&2
  echo "  Only in $TEMPLATE_DIR (a section with no route):" >&2
  comm -23 <(printf '%s\n' "$expected") <(printf '%s\n' "$actual") | sed 's/^/    /' >&2
  echo "  Only in $STUB_DIR (a route with no section):" >&2
  comm -13 <(printf '%s\n' "$expected") <(printf '%s\n' "$actual") | sed 's/^/    /' >&2
  echo "" >&2
  echo "Every system's section files are named by the template, and the twelve" >&2
  echo "stubs' slug: values must be exactly those names. docs.arc42.org points" >&2
  echo "twelve hard-coded URLs at these routes (its _data/sections.yml," >&2
  echo "examples_slug:), so a slug that drifts here is a 404 there that nothing" >&2
  echo "else would report." >&2
  FAILED=1
fi

if [ "$FAILED" -eq 0 ]; then
  count=$(printf '%s\n' "$expected" | wc -l | tr -d ' ')
  echo "check-sections: $count routes, each matching its section file in $TEMPLATE_DIR."
fi

exit "$FAILED"
```

Note the two `<(...)` process substitutions. They are `bash`, not POSIX `sh`. **Run the file with `sh` on macOS and it will fail**, so replace those two `comm` lines with temp files:

```sh
  exp_f=$(mktemp); act_f=$(mktemp)
  printf '%s\n' "$expected" > "$exp_f"
  printf '%s\n' "$actual"   > "$act_f"
  echo "  Only in $TEMPLATE_DIR (a section with no route):" >&2
  comm -23 "$exp_f" "$act_f" | sed 's/^/    /' >&2
  echo "  Only in $STUB_DIR (a route with no section):" >&2
  comm -13 "$exp_f" "$act_f" | sed 's/^/    /' >&2
  rm -f "$exp_f" "$act_f"
```

Use the temp-file version. The `<(...)` version above is shown only so the intent is unambiguous.

- [ ] **Step 2: Run it — expect a pass**

```bash
sh scripts/check-sections.sh
```

Expected: `check-sections: 12 routes, each matching its section file in _systems/_TEMPLATE/.` and exit 0.

- [ ] **Step 3: Break it deliberately, and confirm it fails**

A guard that has never failed is a guard nobody has tested.

```bash
sed -i.bak 's|^slug: 06-runtime-view$|slug: 06-runtime-vue|' _pages/sections/06-runtime-view.md
sh scripts/check-sections.sh; echo "exit=$?"
```

Expected: exit 1, with `06-runtime-view` listed under "Only in _systems/_TEMPLATE/" and `06-runtime-vue` under "Only in _pages/sections/".

- [ ] **Step 4: Restore, and confirm green again**

```bash
mv _pages/sections/06-runtime-view.md.bak _pages/sections/06-runtime-view.md
sh scripts/check-sections.sh; echo "exit=$?"
git status --short
```

Expected: exit 0, and `git status --short` shows only the new/modified files this task intends.

- [ ] **Step 5: Wire it into the Makefile**

In `Makefile`, add `check-sections` to the `.PHONY` list, add it to the `check` target's dependency list (last, after `check-review`), and add the target with its `##` help text so `make help` picks it up:

```make
check: check-brand check-wild-groups check-wild-fields check-structure check-system-fields check-review check-sections ## Run every check that does not need a build (brand deny-list, in-the-wild grouping and fields, example structure and provenance, system front matter, review notes, section routes)

check-sections: ## The twelve /sections/ routes match _systems/_TEMPLATE/, and every highlight names a real section
	sh scripts/check-sections.sh
```

- [ ] **Step 6: Run the whole check suite**

```bash
make check
```

Expected: every check passes, ending with the `check-sections` line.

- [ ] **Step 7: Commit**

```bash
chmod +x scripts/check-sections.sh
git add scripts/check-sections.sh Makefile
git commit -m "feat: guard that the /sections/ routes match the section template"
```

---

### Task 3: The twelve-cell grid, shared

Task 1 wrote the grid loop inline on `/sections/`. The layout needs the same loop at the foot of each of the twelve pages, so it moves into an include before it is duplicated.

**Files:**
- Create: `_includes/section-grid.html`
- Modify: `_pages/sections/index.md` (replace the inline `<ol>` with the include)

**Interfaces:**
- Produces: `{% include section-grid.html %}` renders the twelve-cell `<ol class="ex-sectiongrid">`. Optional parameter `current` — an integer section number — marks that cell with `aria-current="page"` and renders it as plain text rather than a link. Task 4 calls it with `current=page.section`.

- [ ] **Step 1: Write the include**

Create `_includes/section-grid.html`:

```liquid
{%- comment -%}
  The twelve-cell jump grid over the /sections/ pages.

  It is the SAME component as the one on a system's landing page
  (_layouts/system.html, .ex-sectiongrid) and deliberately so: on that page it
  jumps between the twelve sections of one system, and here it jumps between
  the twelve views across all of them. A reader who has learned the shape once
  does not have to learn it twice, and the twelve oversized numerals are the
  site's one piece of typographic character.

  The list is built from the stubs' own front matter, so a renamed section is
  one edit in one file. Sorting on `section` and not on `title` or on the
  page's URL: the arc42 sequence is the only order this grid may ever be in.

  Parameters
    current  optional — the section number of the page doing the including.
             That cell renders as plain text with aria-current, because a link
             to the page you are already on is a dead end for a keyboard user
             and a lie to a screen reader.

  Include it as:  {% include section-grid.html current=page.section %}
{%- endcomment -%}
{%- assign section_pages = site.pages | where_exp: 'p', 'p.layout == "section-index"' | sort: 'section' -%}
<ol class="ex-sectiongrid">
  {%- for s in section_pages -%}
  {%- if include.current and s.section == include.current -%}
  <li class="ex-sectiongrid__cell ex-sectiongrid__cell--current" aria-current="page">
    <span class="ex-sectiongrid__num">{{ s.section }}</span>
    <span class="ex-sectiongrid__name">{{ s.title }}</span>
  </li>
  {%- else -%}
  <li class="ex-sectiongrid__cell">
    <a href="{{ s.url | relative_url }}">
      <span class="ex-sectiongrid__num">{{ s.section }}</span>
      <span class="ex-sectiongrid__name">{{ s.title }}</span>
    </a>
  </li>
  {%- endif -%}
  {%- endfor -%}
</ol>
```

- [ ] **Step 2: Use it on the parent page**

In `_pages/sections/index.md`, delete the `{%- assign section_pages … -%}` line and the whole `<ol class="ex-sectiongrid"> … </ol>` block, and put in their place:

```liquid
  {% include section-grid.html %}
```

- [ ] **Step 3: Build and verify nothing changed on `/sections/`**

```bash
make site
grep -c 'ex-sectiongrid__cell' _site/sections/index.html
grep -c 'aria-current' _site/sections/index.html
```

Expected: `12` cells, and `0` aria-current (the parent page passes no `current`).

- [ ] **Step 4: Commit**

```bash
git add _includes/section-grid.html _pages/sections/index.md
git commit -m "refactor: extract the section jump grid into an include"
```

---

### Task 4: The two bands

The heart of it. One layout, both bands, styling.

**Files:**
- Modify: `_layouts/section-index.html` (replacing the Task 1 stub entirely)
- Create: `_sass/_sections.scss`
- Modify: `assets/css/style.scss` (one `@import` line)

**Interfaces:**
- Consumes: `page.section`, `page.slug`, `page.title`, `page.blurb` from the stubs (Task 1); `{% include section-grid.html current=… %}` (Task 3); `sys.highlights` from system front matter (Task 5 — absent for now, and the layout must render correctly without it).
- Produces: the rendered page. Task 5 verifies band one against it.

- [ ] **Step 1: Write the layout**

Replace `_layouts/section-index.html` entirely:

```liquid
---
layout: default
---
{%- comment -%}
============================================================================
  One arc42 section, across every documented system.

  TWELVE PAGES, ONE LAYOUT. The stubs in _pages/sections/ carry nothing but
  front matter; everything here is built from `page.section` and `page.slug`.

  TWO BANDS, AND THE ORDER MATTERS. "Worth starting with" is maintainers'
  voice: a system, and one line saying why this particular section of this
  particular document repays the time. "All systems" is generated and complete.
  The first band is an opinion and the second is a fact, and a reader who
  distrusts the opinion has the fact directly underneath it.

  THE LOOP RUNS OVER SYSTEMS, NOT OVER SECTION DOCUMENTS, and in the same tile
  order the dashboard uses. Selecting section documents directly with
  `where: 'order', 5` is the trap: system LANDING pages carry `order` too, for
  tile placement. They are 10, 20, 30 and up today, so that filter works by
  accident and breaks the first time a system is ordered below 12.

  NO COUNTS IN THE COPY. Not "eight systems", not "all twelve". This page
  exists precisely because the corpus grows, so a number here dates the
  sentence the day it is written. Same rule as the home page tagline
  (_config.yml) and as the pointer added to docs.arc42.org on 2026-08-21.
============================================================================
{%- endcomment -%}

{%- comment -%}
  Landing pages, in dashboard order. The same triple filter _layouts/home.html
  and search.json use, so the three views cannot disagree about what a system
  is.

  An ANNOUNCED system (`upcoming: true`, currently rgcat) passes this filter —
  it has a title and a tagline — and then falls out below when it turns out to
  have no file for this section. That is the right outcome and it needs no
  special case: an announced example appears here the day its sections land.
{%- endcomment -%}
{%- assign landings = site.systems
      | where_exp: 'd', 'd.url contains "/systems/"'
      | where_exp: 'd', 'd.title'
      | where_exp: 'd', 'd.tagline'
      | sort: 'order' -%}

{%- comment -%}
  BAND ONE, captured rather than counted. The heading may only be emitted if
  something ends up under it, and Liquid cannot look ahead — so the band is
  rendered into a string first and the heading is emitted only if that string
  has anything in it. Twelve pages with a permanently empty "Worth starting
  with" would teach readers to ignore the band, which costs more than it saves.

  Each pick is resolved through the same section lookup band two uses, so a
  `highlights` entry naming a section its system does not have renders nothing
  rather than a dead link. scripts/check-sections.sh should have caught that
  before the build; this is the belt to its braces.
{%- endcomment -%}
{%- capture picks_html -%}
  {%- for sys in landings -%}
    {%- assign hit = sys.highlights | where: 'section', page.section | first -%}
    {%- if hit -%}
      {%- assign sys_slug = sys.path | remove_first: '_systems/' | split: '/' | first -%}
      {%- assign sec_prefix = '_systems/' | append: sys_slug | append: '/' | append: page.slug | append: '.' -%}
      {%- assign sec = site.systems | where_exp: 'd', 'd.path contains sec_prefix' | first -%}
      {%- if sec -%}
  <li class="ex-pick">
    {%- if sys.domain %}<p class="ex-pick__domain">{{ sys.domain }}</p>{% endif -%}
    <h3 class="ex-pick__title"><a href="{{ sec.url | relative_url }}">{{ sys.title }}</a></h3>
    <p class="ex-pick__why">{{ hit.why }}</p>
  </li>
      {%- endif -%}
    {%- endif -%}
  {%- endfor -%}
{%- endcapture -%}
{%- assign picks_html = picks_html | strip -%}

{%- comment -%}
  BAND TWO. Every system that has a file for this section, picks included.
  Leaving the highlighted ones out would make the band incomplete, and a
  reader who scanned band one and then could not find that system in the full
  list would reasonably conclude the list was broken.

  The link goes to the SECTION, not to the system's landing page. A reader on
  this page has already chosen the section; landing them one click short of it
  is the thing this whole page family exists to fix.
{%- endcomment -%}
{%- capture all_html -%}
  {%- for sys in landings -%}
    {%- assign sys_slug = sys.path | remove_first: '_systems/' | split: '/' | first -%}
    {%- assign sec_prefix = '_systems/' | append: sys_slug | append: '/' | append: page.slug | append: '.' -%}
    {%- assign sec = site.systems | where_exp: 'd', 'd.path contains sec_prefix' | first -%}
    {%- if sec -%}
  <li class="ex-syslist__item">
    <a class="ex-syslist__link" href="{{ sec.url | relative_url }}">{{ sys.title }}</a>
    {%- if sys.domain %}<span class="ex-syslist__domain">{{ sys.domain }}</span>{% endif -%}
  </li>
    {%- endif -%}
  {%- endfor -%}
{%- endcapture -%}
{%- assign all_html = all_html | strip -%}

<div class="ex-shell ex-shell--prose">

  <nav class="ex-breadcrumb" aria-label="Breadcrumb">
    <ol>
      <li><a href="{{ '/' | relative_url }}">Examples</a></li>
      <li><a href="{{ '/sections/' | relative_url }}">The twelve sections</a></li>
      <li aria-current="page">{{ page.title }}</li>
    </ol>
  </nav>

  <header class="ex-sechead">
    <p class="ex-sechead__num">arc42 section {{ page.section }}</p>
    <h1 class="ex-sechead__title">{{ page.title }}</h1>
    <p class="ex-sechead__blurb">{{ page.blurb }}</p>
  </header>

  {%- if picks_html != '' -%}
  <section class="ex-band" aria-labelledby="ex-picks-h">
    <h2 class="ex-h2" id="ex-picks-h">Worth starting with</h2>
    <ul class="ex-picks">{{ picks_html }}</ul>
  </section>
  {%- endif -%}

  {%- if all_html != '' -%}
  <section class="ex-band" aria-labelledby="ex-all-h">
    <h2 class="ex-h2" id="ex-all-h">This section in every documentation</h2>
    <ul class="ex-syslist">{{ all_html }}</ul>
  </section>
  {%- else -%}
  <div class="ex-note">
    <p><strong>Nothing here yet.</strong> No documented system has written this
    section. See <a href="{{ '/contribute/' | relative_url }}">Contribute</a>.</p>
  </div>
  {%- endif -%}

  {%- comment -%}
    The sibling nav, and the reason /sections/ needs no masthead slot: every
    one of the twelve reaches the other eleven, and the breadcrumb reaches the
    parent.
  {%- endcomment -%}
  <section class="ex-band">
    <h2 class="ex-h2">The other sections</h2>
    {% include section-grid.html current=page.section %}
  </section>

</div>
```

- [ ] **Step 2: Build and check band two rendered**

`highlights:` does not exist yet, so band one must be absent and band two must be complete.

```bash
make site
echo "--- picks heading (expect 0) ---"
grep -c 'Worth starting with' _site/sections/05-building-block-view/index.html
echo "--- systems in band two (expect 8) ---"
grep -c 'ex-syslist__item' _site/sections/05-building-block-view/index.html
echo "--- links point at the section, not the landing page ---"
grep -o 'href="/systems/[^"]*"' _site/sections/05-building-block-view/index.html | sort -u
```

Expected: `0` for the picks heading; `8` items in band two (the eight systems that have sections — `rgcat` is announced and `UBA-SNS` is untracked); every href of the form `/systems/<slug>/05-building-block-view/`, none of the bare form `/systems/<slug>/`.

- [ ] **Step 3: Check the glossary page too, as a different shape**

```bash
grep -c 'ex-syslist__item' _site/sections/12-glossary/index.html
grep -o 'href="/systems/[^"]*12-glossary/"' _site/sections/12-glossary/index.html | wc -l
```

Expected: `8` and `8`.

- [ ] **Step 4: Write the stylesheet partial**

Create `_sass/_sections.scss`:

```scss
// ============================================================================
// The cross-system section views — /sections/NN-slug/.
//
// TWO BANDS THAT MUST NOT LOOK ALIKE. The first is an opinion (a maintainer
// saying this section is worth your time and why); the second is a generated
// fact. If they render at the same weight the reader has to read both to find
// out which is which, and the first band's whole value is that it can be
// skimmed in three seconds.
//
// So: the picks get the serif title and a line of prose; the full list is a
// flat run of names, one per line, at body weight with the domain trailing in
// --muted. No cards, no fills, no radius on either. This page is not a
// dashboard, and .ex-tile's affordances make a promise about a full read that
// a section-level index does not make (the same argument _sass/_in-the-wild.scss
// makes at length for the reading list).
//
// The jump grid at the foot is .ex-sectiongrid, already defined in
// _system.scss. It is reused verbatim on purpose — see the comment in
// _includes/section-grid.html — and the only addition here is the --current
// modifier for the cell that points at the page you are on.
//
// Colour pairs, measured (ADR-0002):
//   --ground-deep on --paper   14.12:1   (pick title link, list link)
//   --ink         on --paper   13.41:1   (why line)
//   --muted       on --paper    5.50:1   (domain, eyebrow)
// ============================================================================

// ---- Page head --------------------------------------------------------------

.ex-sechead {
  margin: 0 0 var(--s7);
}

.ex-sechead__num {
  margin: 0 0 var(--s2);
  font-size: 0.8125rem;
  letter-spacing: 0.06em;
  text-transform: uppercase;
  color: var(--muted);
}

.ex-sechead__title {
  margin: 0 0 var(--s3);
  font-family: var(--serif);
}

.ex-sechead__blurb {
  margin: 0;
  max-width: var(--measure);
  color: var(--ink);
}

// ---- Bands ------------------------------------------------------------------

.ex-band {
  margin: 0 0 var(--s8);

  > :last-child {
    margin-bottom: 0;
  }
}

// ---- Band one: the picks ----------------------------------------------------
//
// A rule ABOVE each pick rather than a border around it: the bibliography
// treatment, for the same reason /in-the-wild/ uses it. The first pick keeps
// its rule — it separates the list from the h2, and without it the first entry
// reads as a subtitle of the heading.

.ex-picks {
  margin: 0;
  padding: 0;
  list-style: none;
  max-width: var(--measure);
}

.ex-pick {
  padding: var(--s4) 0;
  border-top: 1px solid var(--hairline);

  &:last-child {
    border-bottom: 1px solid var(--hairline);
  }
}

.ex-pick__domain {
  margin: 0 0 var(--s1);
  font-size: 0.8125rem;
  color: var(--muted);
}

.ex-pick__title {
  margin: 0 0 var(--s2);
  font-family: var(--serif);
  font-size: 1.25rem;
  line-height: 1.25;

  a {
    color: var(--link);
  }
}

// The one line of maintainers' voice. It is prose, not metadata, so it takes
// the body face at body size — the whole point of the band is that a reader
// reads this sentence rather than skipping it as a caption.
.ex-pick__why {
  margin: 0;
  color: var(--ink);
}

// ---- Band two: every system -------------------------------------------------
//
// A run of names. Multi-column above the point where a single column would
// leave two thirds of the row empty: at 17px the longest title in the corpus
// ("Traffic Pursuit Unit" plus its domain) is well under half of --measure, so
// one column wastes the width and makes the list look longer than it is.

.ex-syslist {
  margin: 0;
  padding: 0;
  list-style: none;
  max-width: var(--measure);
}

.ex-syslist__item {
  padding: var(--s3) 0;
  border-top: 1px solid var(--hairline);

  &:last-child {
    border-bottom: 1px solid var(--hairline);
  }
}

.ex-syslist__link {
  color: var(--link);
}

.ex-syslist__domain {
  margin-left: var(--s3);
  font-size: 0.875rem;
  color: var(--muted);
}

// ---- The jump grid's current cell -------------------------------------------
//
// Not a link, because it points at the page the reader is on. It keeps the
// cell's box so the grid does not develop a hole, and loses the affordance so
// nothing invites a click that does nothing.

.ex-sectiongrid__cell--current {
  background: var(--wash-active);
  color: var(--muted);
  cursor: default;
}
```

- [ ] **Step 5: Register the partial**

In `assets/css/style.scss`, add `@import "sections";` after `@import "system";` — the section views borrow `.ex-sectiongrid` from `_system.scss`, so they must be able to override it.

- [ ] **Step 6: Build and confirm the CSS compiled**

```bash
make site
grep -c 'ex-pick__why' _site/assets/css/style.css
grep -c 'ex-syslist__domain' _site/assets/css/style.css
```

Expected: `1` for each. A `0` means the `@import` did not land.

- [ ] **Step 7: Commit**

```bash
git add _layouts/section-index.html _sass/_sections.scss assets/css/style.scss
git commit -m "feat: render the two bands on each /sections/ page"
```

---

### Task 5: `highlights:` on the systems, and the guard that keeps them honest

Guard 2 from the spec, plus the data it guards. One edit per system, inside that system's own directory: the modularity contract holds.

**Files:**
- Modify: `_systems/biking/index.md`, `_systems/doctoolchain-v4/index.md`, `_systems/fin-mig/index.md`, `_systems/htmlsc/index.md`, `_systems/mama/index.md`, `_systems/nfdi4earth/index.md`, `_systems/status.arc42.org/index.md`, `_systems/tpu/index.md`
- Modify: `scripts/check-sections.sh`
- Modify: `_systems/_TEMPLATE/index.md` (document the optional field where a new system will find it)

**Interfaces:**
- Consumes: the layout written in Task 4 reads `sys.highlights` as a list of maps with keys `section` (integer) and `why` (string).
- Produces: `highlights` front matter on eight systems, and a second check in `scripts/check-sections.sh`.

**The `why` line, and its rules.** One line, lower case, no closing full stop. It completes an implied *"read this one because…"*. Under about sixty characters, or the band stops being scannable. It is about **that section of that document**, not about the system: "handles 4M requests a day" is a fact about the software and belongs on the tile; "twelve ADRs, one of them marked superseded" is about the section.

**The lines below are drafts.** They are maintainers' voice about other people's documentation, which `CLAUDE.md` in this repo sets the standard for. Write them in, then have Gernot edit them. Every one was drawn from the section's actual headings, not invented: check each against the file it names before committing.

- [ ] **Step 1: Add `highlights` to the eight systems**

Insert the block after the `domain:` line in each `index.md`, with a blank line either side. Exact content per system:

`_systems/biking/index.md`:
```yaml
highlights:
  - section: 2
    why: three kinds of constraint, kept apart
  - section: 8
    why: twelve concepts, each one short enough to finish
  - section: 12
    why: a plain table of terms, which is all a glossary needs
```

`_systems/doctoolchain-v4/index.md`:
```yaml
highlights:
  - section: 8
    why: crosscutting concepts opening with a STRIDE threat model
  - section: 9
    why: twelve ADRs, one of them marked superseded
  - section: 11
    why: technical debt listed beside the risks, and what got resolved
```

`_systems/fin-mig/index.md`:
```yaml
highlights:
  - section: 1
    why: quality goals with numbers in them, and non-goals
  - section: 5
    why: pipes and filters, named as the structural decision
```

`_systems/htmlsc/index.md`:
```yaml
highlights:
  - section: 5
    why: small enough to read at once, still three levels deep
  - section: 9
    why: two decisions, one of them a deliberate postponement
```

`_systems/mama/index.md`:
```yaml
highlights:
  - section: 1
    why: quality goals broken into aspects, then into scenarios
  - section: 6
    why: one import scenario, followed all the way down
```

`_systems/nfdi4earth/index.md`:
```yaml
highlights:
  - section: 3
    why: says what is out of scope, which most documents skip
  - section: 4
    why: strategy told as the set of services it produces
  - section: 7
    why: two infrastructure levels, from containers to domains
```

`_systems/status.arc42.org/index.md`:
```yaml
highlights:
  - section: 6
    why: four scenarios, including startup and a health probe
```

`_systems/tpu/index.md`:
```yaml
highlights:
  - section: 10
    why: a quality tree with the scenarios hanging off it
```

Add this comment above the block in **one** system (`_systems/htmlsc/index.md`, the first in dashboard order), so the argument is written down once where somebody will meet it:

```yaml
# The curated band on /sections/NN-slug/ — "worth starting with".
#
# Declared HERE, in the system's own directory, and not in a central
# _data/section-picks.yml: that file would be exactly the registry
# _includes/system-context.html forbids, and it would be the file nobody
# remembers to revisit when a system is added.
#
# Optional, per system and per section. A system with none appears in the full
# list on each page and is simply never a lead, which is what lets an import
# ship complete before anyone has decided what it is exemplary at.
#
# `why` completes an implied "read this one because...": one line, lower case,
# no closing full stop, under about sixty characters. It is about THIS SECTION
# of this document, not about the system — "4M requests a day" is a fact about
# the software and belongs in `scale`.
```

- [ ] **Step 2: Document the field in the template**

In `_systems/_TEMPLATE/index.md`, add the same field commented out, so `make new-system` scaffolds a system whose author can see the option:

```yaml
# Optional. The curated band on /sections/NN-slug/ — one line per section this
# documentation is worth reading for. See _systems/htmlsc/index.md for the
# rules; scripts/check-sections.sh checks that each `section` is one this
# system actually has.
#
# highlights:
#   - section: 5
#     why: small enough to read at once, still three levels deep
```

- [ ] **Step 3: Add the second guard to `check-sections.sh`**

Insert this before the final `if [ "$FAILED" -eq 0 ]` block, and extend the header comment with a matching numbered paragraph:

```sh
# ---- 2. Highlights name sections their system actually has ------------------
#
# A `highlights: - section: 13` entry, or one naming a section a system has not
# written, renders NOTHING: _layouts/section-index.html resolves the section
# file first and skips the pick if it is missing, so a typo does not produce a
# dead link — it produces a pick that silently is not there. That is the worst
# kind of failure, so it is caught here instead.
#
# The front matter block only: a `section:` in body prose is not front matter,
# and the awk below stops at the closing ---.
SYS_DIR="${3:-_systems}"

highlight_problems=$(
  for f in "$SYS_DIR"/*/index.md; do
    [ -f "$f" ] || continue
    name=$(basename "$(dirname "$f")")
    [ "$name" = "_TEMPLATE" ] && continue

    # Every section number this system declares a highlight for.
    nums=$(awk '
      NR == 1 && /^---[[:space:]]*$/ { infm = 1; next }
      !infm { next }
      /^---[[:space:]]*$/ { infm = 0; next }
      /^highlights:[[:space:]]*$/ { inh = 1; next }
      inh && /^[a-z_]+:/ { inh = 0 }
      inh && /^[[:space:]]+-[[:space:]]*section:[[:space:]]*[0-9]+/ {
        line = $0
        sub(/^.*section:[[:space:]]*/, "", line)
        sub(/[^0-9].*$/, "", line)
        print line
      }
    ' "$f")

    for n in $nums; do
      # Zero-padded, because the files are 01-… through 12-….
      pad=$(printf '%02d' "$n")
      if ! ls "$SYS_DIR/$name/$pad"-*.md >/dev/null 2>&1; then
        echo "$name|highlights names section $n, but $SYS_DIR/$name/ has no $pad-*.md"
      fi
    done
  done
)

if [ -n "$highlight_problems" ]; then
  echo "check-sections: a highlight names a section its system does not have" >&2
  printf '%s\n' "$highlight_problems" | sed -E 's/^([^|]*)\|(.*)$/  \1:\n    \2/' >&2
  echo "" >&2
  echo "A highlight for a section a system has not written renders nothing at" >&2
  echo "all on /sections/NN-slug/ — the layout resolves the section file first" >&2
  echo "and skips the pick when it is missing. Fix the number, or write the" >&2
  echo "section." >&2
  FAILED=1
fi
```

Then change the closing success line so it reports both checks:

```sh
if [ "$FAILED" -eq 0 ]; then
  count=$(printf '%s\n' "$expected" | wc -l | tr -d ' ')
  picked=$(grep -l '^highlights:' "$SYS_DIR"/*/index.md 2>/dev/null | wc -l | tr -d ' ')
  echo "check-sections: $count routes matching $TEMPLATE_DIR, and every highlight on $picked systems names a section that exists."
fi
```

- [ ] **Step 4: Run it — expect a pass**

```bash
sh scripts/check-sections.sh
```

Expected: exit 0, reporting 12 routes and 8 systems with highlights.

- [ ] **Step 5: Break it deliberately, and confirm it fails**

```bash
sed -i.bak 's|^  - section: 10$|  - section: 13|' _systems/tpu/index.md
sh scripts/check-sections.sh; echo "exit=$?"
mv _systems/tpu/index.md.bak _systems/tpu/index.md
sh scripts/check-sections.sh; echo "exit=$?"
```

Expected: first run exits 1 naming `tpu` and section 13; second run exits 0.

- [ ] **Step 6: Build and verify band one renders**

```bash
make site
echo "--- section 5: expect the heading and two picks ---"
grep -c 'Worth starting with' _site/sections/05-building-block-view/index.html
grep -c 'ex-pick__why' _site/sections/05-building-block-view/index.html
grep -o 'ex-pick__why">[^<]*' _site/sections/05-building-block-view/index.html
echo "--- section 9: expect two picks ---"
grep -o 'ex-pick__why">[^<]*' _site/sections/09-architecture-decisions/index.html
echo "--- band two still complete everywhere ---"
for i in 01-introduction-and-goals 02-architecture-constraints 03-context-and-scope \
         04-solution-strategy 05-building-block-view 06-runtime-view \
         07-deployment-view 08-crosscutting-concepts 09-architecture-decisions \
         10-quality-requirements 11-risks-and-technical-debt 12-glossary; do
  printf '%-32s %s\n' "$i" "$(grep -c 'ex-syslist__item' "_site/sections/$i/index.html")"
done
```

Expected: `1` heading and `2` picks on section 5 (htmlsc, fin-mig); the two drafted `why` lines; two picks on section 9 (htmlsc, doctoolchain-v4); and `8` in band two on every one of the twelve.

- [ ] **Step 7: Verify the empty-band case, which the data no longer produces**

Every section now has at least one highlight, so the "band one omitted" path is unexercised. Prove it works, then put it back:

```bash
cp _systems/tpu/index.md /tmp/tpu-index.bak
sed -i '' '/^highlights:$/,/^$/d' _systems/tpu/index.md
sh scripts/check-sections.sh
make site
echo "--- section 10 should now have NO picks heading and NO empty ul ---"
grep -c 'Worth starting with' _site/sections/10-quality-requirements/index.html
grep -c 'ex-picks' _site/sections/10-quality-requirements/index.html
grep -c 'ex-syslist__item' _site/sections/10-quality-requirements/index.html
cp /tmp/tpu-index.bak _systems/tpu/index.md
git diff --stat _systems/tpu/index.md
```

Expected: `0` for the heading, `0` for `ex-picks` (the `<ul>` is inside the `{% if %}`, so nothing is emitted at all), and `8` for band two, which must be unaffected. After the restore, `git diff --stat` on that file prints nothing.

- [ ] **Step 8: Run the whole suite and the link checker**

```bash
make check
make check-links
```

Expected: every check passes. html-proofer reports no broken internal links, which is the real test that every href in both bands resolves.

- [ ] **Step 9: Commit**

```bash
git add _systems scripts/check-sections.sh
git commit -m "feat: curated highlights per system, and the guard that they name real sections"
```

---

### Task 6: The home page pointer and DESIGN.md

**Files:**
- Modify: `index.md` (the `endnotes:` front matter)
- Modify: `DESIGN.md` (the `## Deferred: cross-system section views` section)

- [ ] **Step 1: Add the endnote**

`/sections/` is reached from the home page and from the twelve pages themselves; the masthead nav is deliberately not touched (the spec says why). In `index.md`, add a paragraph to `endnotes:` as the **first** of the three — it points deeper into this site, and the two that follow point away from it.

The block is markdown rendered by `markdownify`, so **no Liquid runs in it**: use a plain root path, exactly as the existing In the Wild link does.

```yaml
endnotes: >-
  Reading for one arc42 section rather than for one system? Every section has
  a page of its own, gathering that section from each documentation here:
  [the twelve sections](/sections/).


  Looking for short, section-sized illustrations instead? Those live with the
  template documentation at [docs.arc42.org](https://docs.arc42.org).


  More arc42 documentation exists that cannot live here — other people's
  systems, on other people's sites, under licences that do not let us
  republish them. Those are listed under [In the Wild](/in-the-wild/).
```

(The em dash in the third paragraph is pre-existing prose. Leave it; the rule is about new prose.)

- [ ] **Step 2: Replace the deferral in DESIGN.md**

Find `## Deferred: cross-system section views` and replace the section with what was built. Keep the original deferral's reasoning as the "why now" — it named the condition, and the condition was met:

```markdown
## Cross-system section views

Built 2026-08-23. `/sections/` and twelve pages under it, one per arc42
section, each gathering that section from every documented system. The
deferral this replaces said the idea was worth building "once there are enough
examples for a comparison to say something", and that is the condition that
changed.

Each page carries two bands. **Worth starting with** is maintainers' voice: a
system, and one line saying why that section of that document repays the time.
**This section in every documentation** is generated and complete. The first is
an opinion, the second is a fact, and the fact sits directly under the opinion.

The curated band is declared per system, in `highlights:` in its own
`index.md`, because a central `_data/section-picks.yml` is exactly the registry
`_includes/system-context.html` forbids — and it would be the file nobody
remembers to revisit when a system is added.

docs.arc42.org links its twelve section pages here. It learns exactly one thing
per section: a URL, in its own `_data/sections.yml`. No data crosses the
boundary — not system names, not depth, and above all not a count. A JSON feed
was considered and rejected: the family already runs one for training dates, so
the pattern is proven, but a feed only earns its keep if the consumer renders
something that varies, and docs deliberately renders nothing that varies.

The price of that decision is that a renamed route here 404s there silently, so
`scripts/check-sections.sh` asserts the twelve route slugs are exactly the
section filenames in `_systems/_TEMPLATE/`. That check is what stands behind
the twenty-four outbound links.

Not in the masthead nav. The nav is a designed surface and `/sections/` is
reached from the home page and from sibling links on the twelve pages
themselves. If it earns a slot later, that is a separate decision with its own
layout consequences.
```

- [ ] **Step 3: Build and verify the endnote link resolves**

```bash
make site
grep -o 'href="/sections/"' _site/index.html
make check-links
```

Expected: the href is present, and html-proofer passes.

- [ ] **Step 4: Commit**

```bash
git add index.md DESIGN.md
git commit -m "docs: point the home page at /sections/, and record what was built"
```

---

### Task 7: Verify Part A end to end, and hand the routes over

Nothing in Part B can be checked until these routes are real, so this is the gate.

- [ ] **Step 1: Full clean build and every check**

```bash
cd /Users/gernotstarke/projects/arc42/examples.arc42.org-site
make clean
make check
make check-links
```

Expected: all green.

- [ ] **Step 2: Record the twelve URLs Part B will hard-code**

```bash
make site
for s in 01-introduction-and-goals 02-architecture-constraints 03-context-and-scope \
         04-solution-strategy 05-building-block-view 06-runtime-view \
         07-deployment-view 08-crosscutting-concepts 09-architecture-decisions \
         10-quality-requirements 11-risks-and-technical-debt 12-glossary; do
  test -f "_site/sections/$s/index.html" \
    && echo "https://examples.arc42.org/sections/$s/" \
    || echo "MISSING $s"
done
```

Expected: twelve URLs, no `MISSING`. These are exactly the values Task 9 writes into `_data/sections.yml`.

- [ ] **Step 3: Look at three of the pages in a browser**

```bash
make dev
```

Open `http://localhost:4042/sections/`, then `/sections/05-building-block-view/` (two picks), `/sections/10-quality-requirements/` (one pick) and `/sections/12-glossary/` (one pick). Check by eye: the two bands read as different things; the `why` lines read as sentences and not as captions; the jump grid's current cell is not a link; nothing says how many of anything there are.

Stop the server (`make stop`) when done.

- [ ] **Step 4: Push the branch**

```bash
git push -u origin feat/section-index
```

---

# Part B — docs.arc42.org-site

Repo: `/Users/gernotstarke/projects/arc42/docs.arc42.org-site`

**Do not begin until Task 7 is complete.**

### Task 8: Branch, and clear the landed handover

**Files:**
- Delete: `HANDOVER.md`

- [ ] **Step 1: Branch from a clean `main`**

```bash
cd /Users/gernotstarke/projects/arc42/docs.arc42.org-site
git status --short
git checkout -b feat/section-example-links
```

Expected before branching: only `?? HANDOVER.md`.

- [ ] **Step 2: Delete the handover**

It documents `feat/link-examples-site`, which merged on 2026-08-21, and it says itself that it should go once the branch lands. It was never tracked, so this is a plain `rm`, not a `git rm`.

```bash
rm HANDOVER.md
git status --short
```

Expected: nothing.

---

### Task 9: The URL scheme, in one file, with a guard

**Files:**
- Modify: `_config.yml`
- Modify: `_data/sections.yml`
- Modify: `scripts/check-site.sh`

**Interfaces:**
- Produces: `site.examples_url` (a string, no trailing slash) and `examples_slug:` on each of the twelve entries in `site.data.sections`. Task 10's include consumes both.

- [ ] **Step 1: Add `examples_url` to `_config.yml`**

Beside the existing `imageurl` / `exampleimages` pair, which is where this file keeps its URL constants:

```yaml
# deployment with github-pages on custom domain
url: https://docs.arc42.org
imageurl: /assets/images/sections
exampleimages: /assets/images/examples

# The sibling site carrying COMPLETE architecture documentation of real
# systems, one page per arc42 section. Absolute and without a trailing slash:
# _includes/examples-link.html appends the path.
#
# Everything that varies over there — which systems exist, how deep they go,
# which are worth reading first — stays over there. This site renders one
# thing: a link. That is the whole coupling, and it is deliberate: a count or
# a system name here would date the moment it was written.
examples_url: https://examples.arc42.org
```

- [ ] **Step 2: Add `examples_slug` to all twelve entries in `_data/sections.yml`**

Extend the `Fields` block in the header:

```
#   examples_slug  The matching page on examples.arc42.org, at
#                  <examples_url>/sections/<examples_slug>/. It is that site's
#                  own section filename, asserted against its template by
#                  scripts/check-sections.sh over there — which is what makes
#                  these twelve hard-coded strings safe. Renaming one is one
#                  word here.
```

Then one line per entry. Note where the names differ from `name:` — this site says "Constraints" where the other says "Architecture Constraints", and "Crosscutting Concepts" where the other says "crosscutting-concepts". Copy these verbatim:

| number | `examples_slug` |
|---|---|
| 1 | `01-introduction-and-goals` |
| 2 | `02-architecture-constraints` |
| 3 | `03-context-and-scope` |
| 4 | `04-solution-strategy` |
| 5 | `05-building-block-view` |
| 6 | `06-runtime-view` |
| 7 | `07-deployment-view` |
| 8 | `08-crosscutting-concepts` |
| 9 | `09-architecture-decisions` |
| 10 | `10-quality-requirements` |
| 11 | `11-risks-and-technical-debt` |
| 12 | `12-glossary` |

So entry 1 becomes:

```yaml
- number: 1
  name: Introduction and Goals
  blurb: Requirements, stakeholder, (top) quality goals
  category: requirements
  permalink: /section-1/
  examples_slug: 01-introduction-and-goals
```

- [ ] **Step 3: Add the guard to `scripts/check-site.sh`**

This one reads the source YAML, not the built site, because a missing `examples_slug` produces no output at all rather than broken output — the include renders nothing when it cannot resolve. Insert it after the `Check arc42 section pages` block and before `Check rail navigation items`:

```sh
section "Check every section carries an examples_slug"
# _includes/examples-link.html renders NOTHING when it cannot resolve a slug —
# no link, no error, no empty box. That is the right behaviour at runtime (a
# half-configured section should not ship a broken link) and it is exactly why
# the omission has to be caught here: adding a thirteenth section, or dropping
# the field in a merge, would silently remove a link from a page and tell
# nobody.
#
# The counterpart check lives in the other repository:
# examples.arc42.org-site/scripts/check-sections.sh asserts the twelve routes
# match its own section template. Between the two, these twelve URLs cannot rot
# without something going red.
sections_file="_data/sections.yml"
if [ ! -f "$sections_file" ]; then
    fail "Missing $sections_file"
else
    numbers=$(rg -o '^- number: [0-9]+' "$sections_file" | sed 's/^- number: //')
    slugs=$(rg -c '^  examples_slug: [0-9a-z-]+' "$sections_file" || true)
    numbers_count=$(printf '%s\n' "$numbers" | grep -c . || true)
    slugs_count=${slugs:-0}

    if [ "$numbers_count" -eq 0 ]; then
        fail "No sections found in $sections_file"
    elif [ "$slugs_count" -eq "$numbers_count" ]; then
        pass "All $numbers_count sections carry an examples_slug."
    else
        fail "$slugs_count of $numbers_count sections carry an examples_slug."
    fi
fi
```

- [ ] **Step 4: Run the check**

```bash
make check
```

Expected: the new block prints `PASS All 12 sections carry an examples_slug.`, and every other check still passes — including the rail check, which is unrelated but is the one that rotted before.

- [ ] **Step 5: Break it deliberately, and confirm it fails**

```bash
sed -i.bak '/^  examples_slug: 07-deployment-view$/d' _data/sections.yml
sh scripts/check-site.sh 2>&1 | grep -E 'examples_slug'
mv _data/sections.yml.bak _data/sections.yml
```

Expected: `FAIL 11 of 12 sections carry an examples_slug.`

- [ ] **Step 6: Confirm the restore and commit**

```bash
git status --short
git add _config.yml _data/sections.yml scripts/check-site.sh
git commit -m "feat: record the examples.arc42.org section URLs, and guard them"
```

---

### Task 10: The include, and the block variant

**Files:**
- Create: `_includes/examples-link.html`
- Create: `_sass/_examples-link.scss`
- Modify: `assets/css/style.scss`
- Modify: `_includes/further-info.md`

**Interfaces:**
- Consumes: `site.examples_url` and `site.data.sections[…].examples_slug` (Task 9); `page.number`, already on every `_pages/section-N.md`.
- Produces: `{% include examples-link.html variant="block" %}` and `{% include examples-link.html variant="inline" %}`. Both take **no other parameters** — the section is resolved from `page.number`. Task 11 calls the inline form twelve times.

- [ ] **Step 1: Write the include**

Create `_includes/examples-link.html`:

```liquid
{%- comment -%}
============================================================================
  The link from an arc42 section page to the same section on
  examples.arc42.org, where whole architecture documentations live.

  NO PARAMETERS BEYOND `variant`. The section resolves from `page.number`,
  which every _pages/section-N.md already carries, against _data/sections.yml,
  which is already this site's single source of truth for the twelve. That is
  why _includes/further-info.md gains a call without any of its twelve call
  sites changing.

  TWO SITES, TWO MEANINGS OF "EXAMPLE", and this copy has to keep them apart.
  This site's own _examples collection holds EXCERPTS: one section, lifted out
  of a document and shown alone, rendered in the warm .arc42-example box
  further up the page. examples.arc42.org holds COMPLETE documentation of real
  systems. The wording below always says which.

  NO COUNTS. Never how many systems are over there, never how many sections
  they have. The corpus grows; a number dates the sentence. Same rule as the
  two pointers added on 2026-08-21 (_pages/examples.md, _pages/home.md).

  RENDERS NOTHING IF IT CANNOT RESOLVE. A half-configured section ships no
  link rather than a broken one. scripts/check-site.sh is what makes sure the
  silence is never reached.

  Parameters
    variant  required — "block" or "inline".

    block    A labelled block for the foot of the page, beside "Related
             Questions" in _includes/further-info.md. Markdown, because that
             file is markdown and its headings feed the page outline.

    inline   One sentence directly under the guidance box near the top, for
             the reader who has just read what belongs in this section and
             wants to see one.

  OUTSIDE THE CALLOUT, both of them. _sass/_callouts.scss reserves cool blue
  for arc42's own guidance and warm terracotta for somebody's actual
  documentation, and the temperature pairing is load-bearing. A link to real
  documentation is neither: it is navigation, so it takes neither box.
============================================================================
{%- endcomment -%}
{%- assign ex_section = site.data.sections | where: 'number', page.number | first -%}
{%- if ex_section and ex_section.examples_slug and site.examples_url -%}
{%- assign ex_url = site.examples_url | append: '/sections/' | append: ex_section.examples_slug | append: '/' -%}
{%- assign ex_name = ex_section.name | downcase -%}
{%- if include.variant == 'block' -%}

### Complete Examples

See <a target="_blank" rel="noopener noreferrer nofollow" href="{{ ex_url }}">the {{ ex_name }} of real systems</a>, documented in full at examples.arc42.org.
{%- elsif include.variant == 'inline' -%}
<p class="examples-link">Want to see this section inside a whole document?
Read <a target="_blank" rel="noopener noreferrer nofollow" href="{{ ex_url }}">the {{ ex_name }} of real systems</a> at examples.arc42.org.</p>
{%- endif -%}
{%- endif -%}
```

A note on the copy, because the phrasing is doing work: "the *name* of real systems" was chosen because it is the one shape that stays grammatical across all twelve — "the glossary of real systems", "the building block view of real systems", "the risks and technical debt of real systems". Shapes like "how real systems document *name*" break on section 12.

- [ ] **Step 2: Call it from `further-info.md`**

Append to the end of `_includes/further-info.md`, after the "Related Questions" paragraph:

```liquid

{% include examples-link.html variant="block" %}
```

And extend that file's header comment, under `Parameters`:

```
  The block at the foot pointing at examples.arc42.org takes NO parameter from
  here — _includes/examples-link.html resolves the section from `page.number`
  against _data/sections.yml. That is on purpose: this include has twelve call
  sites and none of them had to change.
```

- [ ] **Step 3: Build and verify the block on three pages**

```bash
make check
grep -o 'href="https://examples.arc42.org/sections/[^"]*"' _site/section-5/index.html
grep -o 'Complete Examples' _site/section-5/index.html
grep -o 'the [a-z ]* of real systems' _site/section-12/index.html
grep -o 'the [a-z ]* of real systems' _site/section-11/index.html
```

Expected:
- section 5: `href="https://examples.arc42.org/sections/05-building-block-view/"`, and `Complete Examples` present
- section 12: `the glossary of real systems`
- section 11: `the risks and technical debt of real systems`

- [ ] **Step 4: Verify the heading landed in the outline, not inside a callout**

```bash
grep -n -B4 'Complete Examples' _site/section-5/index.html | head -20
```

Expected: an `<h3>` at the same level as `Related Questions`, and no enclosing `class="arc42-help"` or `class="arc42-example"`.

- [ ] **Step 5: Write the stylesheet partial for the inline variant**

The block variant needs no CSS — it is a heading and a paragraph inside the ordinary prose flow. The inline one does: it sits directly under a callout and must not read as part of it.

Create `_sass/_examples-link.scss`:

```scss
// ============================================================================
// .examples-link — the one-line pointer from a section page to the same
// section on examples.arc42.org.
//
// IT SITS DIRECTLY UNDER AN .arc42-help BOX AND MUST NOT LOOK LIKE ONE. The
// temperature pairing in _callouts.scss is load-bearing: cool blue means
// "arc42 is telling you what belongs here", warm terracotta means "here is
// somebody's actual documentation". This is neither — it is a signpost — so it
// takes no fill, no border, no icon and neither hue. A third box here would
// put a third temperature on the page and break the two-way reading the whole
// component depends on.
//
// What separates it from the box above is space and size, which is all a
// signpost needs: --s5 of air, one step down from body size, --text-muted.
// ============================================================================

.examples-link {
  margin: var(--s5) 0;
  max-width: var(--measure);
  font-size: 0.9375rem;
  color: var(--text-muted);

  a {
    // The link keeps full-strength ink. The sentence around it is quiet; the
    // thing to click is not.
    color: var(--link);
  }
}
```

**Before writing this, check the token names.** Run `grep -n '^\s*--' _sass/_tokens.scss` and use the names that actually exist for muted body text, link colour, the `--s5` step and `--measure`. If `--text-muted` is not among them, substitute the real one; do not invent a token.

- [ ] **Step 6: Register the partial**

In `assets/css/style.scss`, add `@import 'examples-link';` immediately after `@import 'callouts';` — it is defined against the callouts and must be able to sit next to them in the cascade.

- [ ] **Step 7: Build and confirm the CSS compiled**

```bash
make check
grep -c 'examples-link' _site/assets/css/style.css
```

Expected: at least `1`.

- [ ] **Step 8: Commit**

```bash
git add _includes/examples-link.html _includes/further-info.md _sass/_examples-link.scss assets/css/style.scss
git commit -m "feat: link each section page to the same section on examples.arc42.org"
```

---

### Task 11: The twelve inline call sites

**Files:**
- Modify: `_pages/section-1.md` through `_pages/section-12.md`

**Interfaces:**
- Consumes: `{% include examples-link.html variant="inline" %}` (Task 10).

**The insertion point is uniform across all twelve.** Every section page contains exactly one `{% include example.md category="…" %}` line, inside the first `.arc42-help` box, followed by a blank line and then the `</div>` that closes that box. Verified across all twelve. The new line goes **after** that `</div>`, with a blank line either side, so it sits outside the callout.

- [ ] **Step 1: Confirm the anchor is still uniform**

```bash
cd /Users/gernotstarke/projects/arc42/docs.arc42.org-site
for i in 1 2 3 4 5 6 7 8 9 10 11 12; do
  n=$(grep -n 'include example.md' "_pages/section-$i.md" | head -1 | cut -d: -f1)
  printf 'section-%-2s  example.md at %-4s next non-blank: %s\n' \
    "$i" "$n" "$(sed -n "$((n+1)),$((n+3))p" "_pages/section-$i.md" | grep -v '^$' | head -1)"
done
```

Expected: twelve lines, each ending `next non-blank: </div>`.

- [ ] **Step 2: Insert the call in all twelve**

```bash
for i in 1 2 3 4 5 6 7 8 9 10 11 12; do
  f="_pages/section-$i.md"
  n=$(grep -n 'include example.md' "$f" | head -1 | cut -d: -f1)
  # The </div> is the first non-blank line after the include.
  d=$(awk -v start="$((n+1))" 'NR >= start && $0 ~ /^<\/div>$/ { print NR; exit }' "$f")
  awk -v at="$d" 'NR == at { print; print ""; print "<!-- the same section, inside complete documentation of real systems -->"; print "{% include examples-link.html variant=\"inline\" %}"; next } { print }' "$f" > "$f.new"
  mv "$f.new" "$f"
done
git diff --stat _pages/
```

Expected: twelve files changed, three insertions each.

- [ ] **Step 3: Read two of the diffs**

A generated edit across twelve files is worth looking at, not just counting.

```bash
git diff _pages/section-1.md _pages/section-12.md
```

Expected in each: the `</div>`, a blank line, the HTML comment, the include, and then the original blank line and whatever followed. The include must be at column 0 and outside the `</div>`.

- [ ] **Step 4: Build and verify two links per page, on all twelve**

```bash
make check
for i in 1 2 3 4 5 6 7 8 9 10 11 12; do
  c=$(grep -c 'examples.arc42.org/sections/' "_site/section-$i/index.html")
  printf 'section-%-3s %s links\n' "$i" "$c"
done
```

Expected: `2 links` on every one of the twelve — the inline one and the block one.

- [ ] **Step 5: Verify the inline one is outside the callout**

```bash
python3 - <<'PY'
import re, pathlib
for i in range(1, 13):
    html = pathlib.Path(f"_site/section-{i}/index.html").read_text()
    m = re.search(r'<p class="examples-link">', html)
    before = html[:m.start()]
    # The last callout tag before the pointer must be a close, not an open.
    opens = [x.start() for x in re.finditer(r'<div class="arc42-(help|example)"', before)]
    closes = [x.start() for x in re.finditer(r'</div>', before)]
    ok = bool(closes) and (not opens or closes[-1] > opens[-1])
    print(f"section-{i:<3} inline pointer outside a callout: {ok}")
PY
```

Expected: `True` for all twelve.

- [ ] **Step 6: Verify each page points at its own section**

An off-by-one here would be invisible on the page and wrong on every click.

```bash
for i in 1 2 3 4 5 6 7 8 9 10 11 12; do
  printf 'section-%-3s -> %s\n' "$i" \
    "$(grep -o 'examples.arc42.org/sections/[^"]*' "_site/section-$i/index.html" | sort -u | tr '\n' ' ')"
done
```

Expected: each line shows exactly one distinct URL, and its leading number matches the section number — `section-1 -> …/01-introduction-and-goals/`, through `section-12 -> …/12-glossary/`.

- [ ] **Step 7: Commit**

```bash
git add _pages
git commit -m "feat: point each section page at its section on examples.arc42.org"
```

---

### Task 12: Verify both sides together

- [ ] **Step 1: Both check suites, clean**

```bash
cd /Users/gernotstarke/projects/arc42/examples.arc42.org-site && make clean && make check && make check-links
make clean && make check && make check-links
```

Expected: all green in both. `make check-links` runs with `--disable-external` in both repos, so it will **not** follow the twenty-four links to examples.arc42.org. That is by design; Task 2's route guard is what stands behind them. Step 2 does the crossing check by hand.

- [ ] **Step 2: Cross-check the twenty-four URLs against the routes that exist**

The one thing neither repo's checks can do on its own.

```bash
cd /Users/gernotstarke/projects/arc42/docs.arc42.org-site
grep -oh 'examples.arc42.org/sections/[^"]*' _site/section-*/index.html \
  | sed 's|.*/sections/||; s|/$||' | sort -u > /tmp/docs-wants.txt
cd /Users/gernotstarke/projects/arc42/examples.arc42.org-site
ls _site/sections/ | grep -v '^index.html$' | sort > /tmp/examples-has.txt
diff /tmp/docs-wants.txt /tmp/examples-has.txt && echo "MATCH: every docs link has a route"
```

Expected: no diff, and `MATCH: every docs link has a route`.

- [ ] **Step 3: Look at it**

Run both dev servers and click through:

```bash
cd /Users/gernotstarke/projects/arc42/examples.arc42.org-site && make dev   # :4042
# in another terminal
cd /Users/gernotstarke/projects/arc42/docs.arc42.org-site && make dev       # :4000
```

On `http://localhost:4000/section-5/`: the inline pointer sits under the first blue box and reads as a signpost, not as a third callout; the "Complete Examples" block sits beside "Related Questions" at the foot. The links go to the live site (they are absolute), which is correct and is the reason Step 2 exists.

On `http://localhost:4042/sections/05-building-block-view/`: both bands, the picks readable as sentences, the jump grid at the foot.

Stop both (`make stop`).

- [ ] **Step 4: Push**

```bash
cd /Users/gernotstarke/projects/arc42/docs.arc42.org-site
git push -u origin feat/section-example-links
```

- [ ] **Step 5: Report what needs a human**

Tell Gernot, in one message:

- both branches, pushed, and what is on each;
- **the eighteen `why` lines are drafts written from the sections' own headings, and they are the thing to edit** — they are maintainers' voice about other people's documentation, and the plan deliberately did not treat drafting them as finishing them;
- the order of merge: examples first, because the docs links 404 until its routes are live;
- what stayed out, and is still open: the masthead nav slot on examples.arc42.org, `/in-the-wild/` entries in the bands, review notes as a third signal, a JSON feed, and CI (deferred 2026-08-23, needs a `SKIP_BUILD=1` seam in `scripts/check-site.sh:33-49`).

---

## Notes for whoever executes this

**On the two `sed -i` dialects.** macOS `sed` needs `-i ''` (two arguments); GNU `sed` needs `-i` alone or `-i.bak`. The steps above use `-i.bak` and then move the backup back, which works on both. If you hit `sed: 1: "…": invalid command code`, that is this.

**On `rg`.** Both repos' check scripts use `rg` (ripgrep) rather than `grep`. It is installed here. The new guard in Task 2 uses plain `grep`/`sed` on purpose — `scripts/check-sections.sh` follows `check-system-fields.sh`, which has no dependency beyond a POSIX shell.

**On `_systems/UBA-SNS/`.** Untracked, with no `index.md`. `check-structure.sh` skips untracked directories as work in progress, and the section-index layout ignores it because it has no landing page. Leave it alone.

**On the two systems sharing `order: 30`.** `biking` and `status.arc42.org` both carry it. That is pre-existing, it affects the dashboard as much as these pages, and it is out of scope here. Do not "fix" it in this branch.

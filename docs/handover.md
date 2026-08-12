# Handover — 2026-08-11

`docs/` is excluded from the Jekyll build (`_config.yml:105`), so this never
publishes.

## Where the work is

**On `main`, not on `in-the-wild-deathstar`.** You merged the branch into main
mid-session (fast-forward at `6ca9783`) and everything after that landed on main
directly. `in-the-wild-deathstar` is now five commits behind and can be deleted.

**Five commits are unpushed.** `origin/main` is at `6ca9783`; local main is at
`5584886`.

```
5584886  make every recorded ratio the measured one
264f2c4  move the section rail to 1040px: 1ch is the 0, not the n
a2e8da9  make a pill mean something on both pages
4e1787c  spend the page's one pill on the fact that ranks first
4956d09  correct DESIGN.md on this component, and drop an inert rel
--- origin/main ---
6ca9783  stop ruling 232px of every separator across nothing
17dfc39  fail the build on a facet list YAML has taken apart
f1da314  give the masthead panel arc42.de's grouped rows
add05de  index /in-the-wild/ one record per entry, not one per page
```

Untracked and deliberately so: three `.impeccable/critique/` snapshots.

## What landed (do not redo)

- **Search**: one index record per `/in-the-wild/` entry, anchored at its `id`;
  records gained `type`; the masthead panel is arc42.de's, class for class —
  groups, marked prefixes, URL paths, a "Show all N results" row.
- **`make check`** grew `check-wild-fields.sh`: `kind` present and in the
  vocabulary, plus the `facets` comma trap and the five-item ceiling.
- **`/in-the-wild/` layout**: one shell width per layout, so the entry
  separators stop ruling 232px across empty space below 1040px.
- **Chips, both surfaces.** Dashboard went from 58 pills to 24: `decisions` is a
  plain list, `technologies` is four one-token chips. `/in-the-wild/` has one
  chip, `kind`, from `Production system` / `Invented subject` /
  `Student coursework`, with section coverage beside it as plain text.
- **The section rail** moved 940px → 1040px, and the unrailed shell now caps at
  the column, which was running to 90ch.
- **DESIGN.md** is reconciled with all of it. Five wrong contrast ratios fixed.

## Open, roughly by value

1. **Closed `domain` vocabulary on the dashboard** (deferred by decision). Six
   free-text values for six systems, two of them carrying two axes in one slash.
   The `--cat` colour hook must not be switched on before this: it would produce
   six colours for six single-member categories. Proposed terms and the
   reasoning are in DESIGN.md §"Open decision: colour on tiles" and in the
   critique snapshot. Wants a `check-system-fields.sh` beside the other checks.
2. **Classification is invisible to heading navigation** on both surfaces — the
   category is a `<p>` before the heading, so jumping by heading hears none of
   it. Fix by putting it in the link's accessible name with a hidden span. Only
   safe once `domain` is closed, or it announces "Personal slash fitness
   tracking".
3. **The dashboard filter placeholder** promises "domain, technology,
   decision…" against a vocabulary printed nowhere; typing `government` gets a
   bare empty state.
4. **No `<time>`** on `year` or `added` in `/in-the-wild/` entries.
5. **`:target` feedback** on entry anchors. Deliberately unresolved: every
   genre-safe treatment is a fill, and fill is the omission this page is built
   on. Wants a decision, not a default.
6. **The page ends in a hairline and the INNOQ logo.** A closing line at the
   foot of the list is the peak-end fix and the right home for a contextual
   Contribute invitation. `/contribute/` is already in the global nav.
7. **Eight removable em dashes** in entry copy (two Star Wars, two geOrchestra,
   two Oviedo, two DokChess). A ninth is in geOrchestra's own title and stays.

Not wanted: an automated contrast checker (asked and declined, 2026-08-11).

## Things that will otherwise be re-derived

**Build and verify.**

```sh
docker compose run --rm jekyll bundle exec jekyll build
make check                 # brand + wild groups + wild fields
make check-external        # hits real URLs; never wire into make check
docker compose run --rm jekyll bundle exec htmlproofer ./_site \
  --disable-external --allow-hash-href
```

`scripts/check-brand.sh` walks the whole tree including any `_site-*`
directory. Delete stress builds before running `make check`.

**Stress build** (the page's real questions only appear at twenty entries):

```sh
mkdir _stressdata      # copy both in-the-wild*.yml there, duplicate entries
printf 'data_dir: _stressdata\ndestination: _site-stress\n' > _config-stress.yml
docker compose run --rm jekyll bundle exec jekyll build \
  --config _config.yml,_config-stress.yml
rm -rf _stressdata _config-stress.yml _site-stress
```

**Screenshots.** Firefox only — no Chrome, no Playwright, no puppeteer, so the
impeccable detector's URL mode and any in-page overlay are unavailable.

```sh
/Applications/Firefox.app/Contents/MacOS/firefox -no-remote -profile <fresh dir> \
  --window-size=1440,900 --screenshot out.png http://localhost:8899/
```

- Both `--window-size` values captures the **viewport**; width alone captures
  the full document height.
- The shot is taken at `load`, so anything on a timer or a `fetch` (the search
  panel, any measuring script) is not on screen yet. The way through: serve from
  a **threaded** server with an endpoint that sleeps, and reference it as an
  off-screen `<img>` in a copy of the page, so `load` waits for it. A
  single-threaded `http.server` deadlocks instead — the sleep blocks every other
  request, including the one being waited for.

  ```python
  import http.server, socketserver, time, sys, os
  os.chdir(sys.argv[1])
  class H(http.server.SimpleHTTPRequestHandler):
      def do_GET(self):
          if self.path.startswith("/slow.png"):
              time.sleep(2.5); self.send_response(200)
              self.send_header("Content-Length", "0"); self.end_headers(); return
          return super().do_GET()
      def log_message(self, *a): pass
  socketserver.ThreadingTCPServer.allow_reuse_address = True
  with socketserver.ThreadingTCPServer(("127.0.0.1", 8899), H) as s: s.serve_forever()
  ```
- Firefox ignores URL fragments in headless mode, so anchor landing cannot be
  verified this way; htmlproofer verifies the targets exist.
- To photograph something below the fold, inject a `<style>` hiding the
  masthead and intro into a copy of the built page rather than scrolling —
  scroll position is not honoured.
- Reuse of one profile directory across parallel runs hangs. Use a fresh one.

**Measured type** (Atkinson Hyperlegible Next, unitsPerEm 1000): `0` = 648
units = **11.016px at 17px**, so `--measure` (68ch) = 749.1px, the 65ch floor =
716.0px, and 72ch = 793.2px. `n` = 550 units = 9.350px, which is the number that
was wrong in `_rail.scss` for months. `m` = 845. Use fontTools against
`assets/fonts/*.woff2`; do not estimate.

**Both rails collapse at 1040px** and arrive there by different arithmetic
(systems: 48 + 210 + 48 of chrome; in-the-wild: 48 + 200 + 32). 940px is now
only the masthead's number, where brand + nav + search stop fitting on one line.

## House style

- **No em dashes in user-facing copy.** Use a full stop or a colon. Comments and
  commit messages are exempt in practice.
- **Comments**: keep only what a future edit would break with nothing failing.
  Exception: `_data/in-the-wild.yml`'s header is the contribution surface and
  stays full.
- **No signature hue** (ADR-0008). Links are ink with a persistent underline.
  Never introduce colour to solve a hierarchy problem.
- **Record measurements at the declaration site, with the arithmetic.** Six of
  them have been wrong; the number in the comment is the promise.
- **Breakpoints come from the measure**, never from device conventions. 1024px
  was rejected for the rail on exactly that ground.
- **A chip is worth its pill only if its value can recur.** 55 of 58 dashboard
  values appeared exactly once, which is what ended the chip rows.
- `/in-the-wild/` is a bibliography, not a dashboard: no cards, fills, lifts,
  stretched links or catalogue numbers. The argument is in
  `_sass/_in-the-wild.scss`'s header.

## Reading order for the next session

`DESIGN.md` first (normative, and now current), then the header comments of
`_data/in-the-wild.yml`, `_sass/_in-the-wild.scss` and `_sass/_rail.scss`. The
full chip critique with its measurements is
`.impeccable/critique/2026-08-11T14-31-06Z__includes-system-tile-html.md`.

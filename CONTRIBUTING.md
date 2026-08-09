# Contributing an example

An example is **one directory**. Adding one changes nothing outside it.

## What belongs here

- **Complete** documentations — all twelve arc42 sections. Where the original
  has nothing for a section, say so in one line rather than deleting the file.
  The rail and the stepper expect twelve, and an honest gap is itself useful to
  someone comparing examples.
- **Real** systems. Anonymised is fine. Invented is not — this site's whole
  claim is that these are real architectures.
- **Provenance.** Who wrote the original, under which licence, and permission
  to republish. A pull request without this cannot be merged, however good the
  documentation is.

Short, section-sized snippets belong on [docs.arc42.org](https://docs.arc42.org)
instead.

### If you cannot republish it

A documentation can be complete, real and excellent and still not be
publishable here — most often because its licence does not allow it. Send us a
**link** instead: one entry in `_data/in-the-wild.yml`, which renders on
[/in-the-wild/](https://examples.arc42.org/in-the-wild/).

| What you have | Where it goes |
|---|---|
| Complete, and republishable here | An example directory — the rest of this file |
| Complete, but not republishable | `_data/in-the-wild.yml` |
| A fragment of one section | [docs.arc42.org](https://docs.arc42.org) |

Supply `title`, `url`, `author` and `description` (one factual sentence, no
praise). **Leave `note` out** — that sentence is the maintainers' editorial
voice, and notes written by the documentation's owner turn into blurbs. The file
header documents every field.

That page is a reading list, not a second shelf of examples: nothing on it has
been read end to end by us, which is why it is deliberately not laid out as
tiles.

## Steps

1. Fork and clone.
2. `make new-system SLUG=your-system`
   Copies `_systems/_TEMPLATE/` and rewrites the one line that names the
   directory.
3. Fill in `index.md` **first**. Its front matter *is* the dashboard tile —
   see the field-by-field comments in the template.
4. Write the twelve sections.
   - Images → `images/`, referenced relatively: `![Context](../images/03-context.png)`
   - Anything you converted from (AsciiDoc, PlantUML, drawio) → `_originals/`
5. `make dev`, look at it, `make check && make check-links`.
6. Open a pull request.

## Conventions

**Markdown is canonical.** Whatever the documentation was written in, the
Markdown here becomes the source of truth once merged. Examples are snapshots
and are not synchronised with their originals — which is why the site needs no
conversion step at build time and runs on plain GitHub Pages.

**Keep the arc42 section titles.** Readers navigate by them, and cross-example
comparison only works if section 5 means section 5 everywhere.

**Don't renumber.** `order:` values are the arc42 section numbers, 1–12. The
`order:` in `index.md` is different — it is the tile's position on the
dashboard, and uses gaps (10, 20, 30) so an example can be slotted in later.

**No colour of your own.** The site is deliberately neutral; its only colour is
the spine. Tiles do not carry per-example or per-domain colour. If you think
they should, that is a design change — open an issue rather than styling one
example differently.

**Reserved slugs.** Because examples live under `/systems/`, they cannot
collide with site pages. Still avoid `_TEMPLATE`, and avoid a leading
underscore in any directory or file you want published — Jekyll skips those.

## Reviewing checklist

- [ ] Twelve sections present, `order:` 1–12, titles unchanged
- [ ] `index.md` front matter complete: tagline ≤ 60 chars, ≤ 4 decisions,
      ≤ 6 technologies, keywords not sentences
- [ ] `attribution`, `licence`, `source_url` present and correct
- [ ] Images in the system's own `images/`, referenced relatively
- [ ] Source material in `_originals/` (underscore intact)
- [ ] `make check` and `make check-links` pass
- [ ] No file outside `_systems/<slug>/` changed

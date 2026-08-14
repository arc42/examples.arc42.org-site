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

## Review notes (maintainers only)

Some systems carry **arc42 review notes**: signed, subjective remarks by the
arc42 maintainers, pinned onto the documentation at the passage they discuss
— the way a comment lands in an architecture-documentation review. The
contract is [ADR-0009](https://github.com/arc42/meta.arc42.org/blob/main/adr/0009-review-notes-on-hosted-content.md):
the original is never altered, every note is signed, and the subjectivity is
disclosed once per system on its overview page.

These are **not part of contributing an example** — contributed directories
are reproduced as-is, and notes written by a documentation's own author would
be blurbs, the same reason `note:` is reserved on `/in-the-wild/`.

The workflow, when you review a system and want to comment on a passage:

1. **Write the finding** in the system's review report,
   `_data/reviews/<slug>.yml` (create the file from the header comment in
   `_data/reviews/htmlsc.yml` if it is the system's first note):

   ```yaml
   - id: quality-goal-priorities        # stable slug → anchor #review-<id>
     section: 1                         # the section the marker sits in
     title: Priority inflation in the quality goals
     author: Gernot Starke
     body: |
       The remark, in markdown. Multiple paragraphs are fine.
   ```

2. **Drop the marker** in the section file, directly after the passage the
   note discusses:

   ```liquid
   {% include review-note.html id="quality-goal-priorities" %}
   ```

3. **`make check`.** `check-review.sh` verifies every marker has exactly one
   entry and vice versa, and that every entry is complete and signed. The
   overview's disclaimer and findings list appear automatically once the
   report exists — there is no flag to set.

That is the whole mechanism: one file holds the review, one line per note
sits in the text, and everything else is derived.

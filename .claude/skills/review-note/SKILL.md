---
name: review-note
description: Add, edit, or retire an arc42 review note on an example system — the maintainers' signed, subjective commentary pinned onto as-is content. Use when the user wants to comment on / review / annotate a passage of a hosted example, add a finding, change or remove an existing review note, or asks how review notes work.
---

# arc42 review notes

The contract is ADR-0009 (meta.arc42.org): review notes are **signed,
subjective** remarks by the arc42 maintainers, pinned onto hosted
documentation at the passage they discuss. The original is never altered;
the notes are the one voice on a section page that is ours.

## The model (do not deviate)

- **Note texts** live in one review report per system:
  `_data/reviews/<slug>.yml` — deliberately OUTSIDE `_systems/<slug>/`,
  because the review is the maintainers' voice, not part of the contributed
  work. Field spec and header comment: `_data/reviews/htmlsc.yml`.
- **Markers** — one line per note, in the section file, directly after the
  passage the note discusses:
  `{% include review-note.html id="<id>" %}`
- **Everything else is derived.** The overview's disclaimer and findings
  list appear automatically once the report exists. There is NO flag, no
  registry, nothing else to edit. Never add note prose to a section file.

## Adding a note

1. If `_data/reviews/<slug>.yml` does not exist, create it by copying the
   header comment block from `_data/reviews/htmlsc.yml`.
2. Append an entry — all five fields are required:

   ```yaml
   - id: quality-goal-priorities        # stable lowercase-kebab slug;
                                        #   becomes anchor #review-<id>
     section: 1                         # `order` of the page the marker is in
     title: Priority inflation in the quality goals   # findings headline
     author: Gernot Starke              # every note is signed
     body: |                            # markdown; | block scalar, not >
       The remark. Multiple paragraphs are fine.
   ```

3. Place the marker line in `_systems/<slug>/<section>.md` after the
   passage. This marker is the ONLY change ever made to a section file.
4. Verify: `sh scripts/check-review.sh` (or `make check`). It enforces the
   marker⇔entry bijection both ways, unique ids, field completeness, and
   orphaned reports — trust its messages.
5. For visual verification build with `make site` (docker) and inspect
   `_site/systems/<slug>/…`.

## Editing / retiring a note

- Rewording, retitling, reattributing: edit the entry in the report only.
- Renaming an `id`: change it in BOTH the report and the marker (the id is
  the public anchor — prefer not to rename).
- Retiring: delete the entry AND its marker, then run the check. If it was
  the system's last note, delete the now-empty report file too.
- Removing a system: also remove its report, or the check flags an orphan.

## Voice and judgement

- Write as in an architecture-documentation review: concrete, tied to the
  passage, praising what is good and naming what is weak — never a verdict
  on the whole work. Reference arc42/ISO vocabulary where it sharpens the
  point.
- A note nobody will sign is a note the site does not publish. Author is a
  real maintainer's name, never a collective.
- Notes are the maintainers' act. Never add review notes on behalf of an
  example's contributor, and never edit the surrounding original content.

## Do not touch

- The visual layer (`_sass/_review.scss`, `_includes/review-note.html`,
  `_includes/review-pin.html`) is settled by ADR-0009 and examples'
  DESIGN.md — pin glyph, amber accent, off-grid offset. Changing it is a
  design decision, not part of authoring a note.

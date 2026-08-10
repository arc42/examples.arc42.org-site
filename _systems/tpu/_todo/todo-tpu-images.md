# TODO — TPU diagrams

The TPU chapter references **21 figures**. All 21 are **now in place** in
`_systems/tpu/images/`, extracted from the embedded images in
`_originals/arc42byexample-TPU.pdf`. The gray placeholders are gone.

They are `.jpg`, because that is what the PDF stores. Re-wrapping JPEG line art
as PNG gains nothing and costs ~4× the bytes (measured: 61 KB → 235 KB on
`05_1`), so the markdown references `.jpg`.

**Still worth doing:** ask Wolfgang Reimesch, who wrote the chapter, for the
Enterprise Architect originals. Not because the extracts are bad — they are
genuinely good — but because vector/SVG or ≥1600 px exports would survive a
retina display, and because one figure is cropped in the PDF (see below). If a
replacement arrives as `.png`, remember to update the extension in the
corresponding section file.

## Copyright — settled

TPU is © Wolfgang Reimesch and Peter Hruschka, originally published on Leanpub
in «arc42 by Example». Confirmed by Gernot Starke, 2026-08-10.

Both names are in `attribution:` (the overview page prints it as "Written by",
and CC BY-SA attribution requires the rights holders). Licence stays CC BY-SA
4.0 and `source_url` stays the Leanpub book page — identical to `mama` and
`htmlsc`, which come from the same book. The figures below are the book's
rendered figures, republished on the same terms.

## The list

| # | Figure caption (as in the book) | File in `images/` | Section | PDF page | Pixels | Kind |
|---|---|---|---|---|---|---|
| 1 | Fig. 1: TPU Use Cases | `01-use-cases.jpg` | 01 | 4 | 997 × 1196 | UML use case |
| 2 | Fig. 3.1: TPU Business Context | `03_1-business-context.jpg` | 03 | 7 | 1192 × 838 | context diagram |
| 3 | Fig. 3.2: TPU The Complete Device | `03_2-complete-device.jpg` | 03 | 8 | 1600 × 1200 | **photo**, downscaled from 3648 × 2736 |
| 4 | Fig. 3.3: TPU Technical Context | `03_3-technical-context.jpg` | 03 | 9 | 1184 × 1142 | context diagram |
| 5 | Fig. 5.1: TPU Level 1: White Box TPU | `05_1-whitebox-tpu.jpg` | 05 | 11 | 1147 × 879 | building blocks |
| 6 | Fig. 5.2: White Box Measuring Unit | `05_2-whitebox-measuring-unit.jpg` | 05 | 13 | 1155 × 1016 | building blocks |
| 7 | Fig. 5.3: White Box Video Unit | `05_3-whitebox-video-unit.jpg` | 05 | 15 | 1427 × 1070 | building blocks |
| 8 | Fig. 5.4: White Box Video Subsystem | `05_4-whitebox-video-subsystem.jpg` | 05 | 18 | 1342 × 984 | building blocks |
| 9 | Fig. 5.5: White Box Pursuit | `05_5-whitebox-pursuit.jpg` | 05 | 20 | 1000 × 951 | UML class |
| — | *Fig. 5.6: C++ Header File* | *no file* | 05 | 20 | — | **not an image** — a code listing, inlined as a fenced `cpp` block |
| 10 | Fig. 5.7: White Box Calibrate | `05_7-whitebox-calibrate.jpg` | 05 | 21 | 1379 × 1163 | UML class (active classes) |
| 11 | Fig. 6.1: Sequence Diagram | `06_1-sequence-diagram.jpg` | 06 | 22 | 1408 × 1070 | UML sequence |
| 12 | Fig. 6.2: Communication Diagram | `06_2-communication-diagram.jpg` | 06 | 23 | 1000 × 808 | UML communication |
| 13 | Fig. 6.3: Activity Diagram | `06_3-activity-diagram.jpg` | 06 | 24 | 1285 × 812 | UML activity |
| 14 | Fig. 6.4: Extended Activity Diagram | `06_4-extended-activity-diagram.jpg` | 06 | 25 | 1355 × 847 | UML activity + swim lanes — **cropped, see below** |
| 15 | Fig. 7.1: TPU Hardware | `07_1-tpu-hardware.jpg` | 07 | 26 | 1600 × 1200 | **photo**, downscaled from 3648 × 2736 |
| 16 | Fig. 7.2: Deployment View Level 1 | `07_2-deployment-level-1.jpg` | 07 | 27 | 1326 × 1162 | UML deployment |
| 17 | Fig. 7.3: Video Cards | `07_3-video-cards.jpg` | 07 | 29 | 1286 × 1073 | UML deployment |
| 18 | Fig. 7.4: Video Inserters | `07_4-video-inserters.jpg` | 07 | 30 | 1600 × 1200 | **photo**, downscaled from 3648 × 2736 |
| 19 | Fig. 7.5: Codec Board | `07_5-codec-board.jpg` | 07 | 31 | 1600 × 1200 | **photo**, downscaled from 3648 × 2736 |
| 20 | Fig. 8.1: Domain Entity Model | `08_1-domain-entity-model.jpg` | 08 | 32 | 1181 × 1118 | UML class |
| 21 | Fig. 8.2: Event Handling Scenario | `08_2-event-handling.jpg` | 08 | 34 | 1151 × 812 | scenario diagram |

"PDF page" = page in `_originals/arc42byexample-TPU.pdf`, not the book's printed
page number. Untouched extracts are kept in `_originals/extracted/pg-NNN-000.jpg`.

## Resolution verdict

Diagrams display at `--measure-wide` (≈116ch, roughly 930 CSS px). Every diagram
here is 997–1427 px wide, so all of them are **at or above 1× display width**,
and above this site's existing median image width of 746 px. Nothing needs
replacing on resolution grounds.

The honest caveat: at 930 CSS px, a 2× retina display wants ~1860 px. Only the
four photos reach that. The diagrams will look slightly soft on a retina screen
— acceptable, and the same trade-off every other example on this site already
makes, but it is the argument for getting vector originals from the author.

The three narrowest are `01-use-cases` (997 px, but portrait — it is height, not
width, that constrains it, so it is effectively the sharpest of the lot),
`05_5-whitebox-pursuit` (1000 px) and `06_2-communication-diagram` (1000 px).
All three were checked by eye and are fully legible.

The four photos were downscaled to 1600 px wide at quality 85. At their original
3648 × 2736 they were 1.3–2.4 MB each — far too heavy for a page that shows
several of them. Now 180–383 KB.

## Known defects in the source

1. **Fig. 6.4 is cropped in the PDF itself.** The bottom edge cuts off the
   "Legal Inserter Frame Timer" label in the VideoSubsystem swim lane (and the
   book prints it as "Legak"). This is not an extraction artifact — the embedded
   image is already cropped. A replacement from the author would fix it. This is
   the single best reason to ask.
2. **Figure numbering skips 5.6 as an image.** Fig. 5.6 is a C++ header listing,
   not a diagram, so there is no `05_6-*` file. Deliberate.
3. **Cross-reference numbers in section 7.2 are off by one in the book.** The
   text says the inserter PCB is "cf. figure 7.5" and the codec PCB "cf. figure
   7.6", but the actual captions are Fig. 7.4 (Video Inserters) and Fig. 7.5
   (Codec Board), and there is no Fig. 7.6. Corrected to 7.4 and 7.5 in
   `07-deployment-view.md`. Revert if you would rather stay literal to print.

## Other conversion notes (not image-related)

- **Subsection headings keep the original numbering** (`## 5.2 White Boxes Level
  2`, `**2.3 MuProxy**`), unlike `biking` and `status.arc42.org` which dropped
  the numbers. Here the numbers carry meaning: the text cross-references them
  ("see 8.2", "cf. chapter 7", "as shown as use cases in chapter 1.1").
- **Obvious typos in the print edition were silently fixed**: *accurary* →
  accuracy, *strenghten* → strengthen, *thedocuments* → the documents,
  *processoror* → processor, *manoevers* → manoeuvers, *accelleration* →
  acceleration, *Legalnserter* → LegalInserter, *depend on* → dependent on,
  *separation of concern* → separation of concerns. Also normalised
  *Reimesch Kommunikationsysteme* → *Reimesch Kommunikationssysteme* (the
  chapter spells it both ways).
- **Attribution and source_url are confirmed**, see "Copyright" above. Nothing
  open there.
- **`order: 50`** — note that `biking` and `status.arc42.org` both currently sit
  at `order: 30`, which may or may not be intentional. The only open item in
  this file besides the diagrams themselves.

# Original sources

Two sources, both from the NFDI4Earth consortium.

## 1. The published PDF — the spine of these chapters

`NFDI4Earth_Software_Architecture_Documentation_2024.pdf`, kept here
unmodified.

- **Title**: NFDI4Earth Software Architecture Documentation
- **Authors**: Christin Henzen, Anna Brauer, Auriol Degbelo, Stephan
  Frickenhaus, Jonas Grieb, Stephan Hachinger, Ralf Klammer, Claudia Müller,
  Johannes Munke, Tom Niers, Daniel Nüst, Claus Weiland, Alexander Wellmann
- **Published**: 2024-12-20, Zenodo
- **DOI**: [10.5281/zenodo.14534839](https://doi.org/10.5281/zenodo.14534839)
- **Licence**: [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/) —
  permits republication, including in adapted form, with attribution
- **Funding**: German Research Foundation (DFG), NFDI4Earth, project no.
  460036893

It covers arc42 sections 1, 2, 3, 4, 5 and 9, and points elsewhere for 7.

## 2. The consortium's living online version — merged in

<https://nfdi4earth.pages.rwth-aachen.de/architecture/architecture-docs/>

- **Licence**: **CC0 1.0 Universal** — *"To the extent possible under law, the
  people who associated CC0 with this work have waived all copyright and
  related or neighboring rights to this work."*
- Built with MkDocs from
  <https://git.rwth-aachen.de/nfdi4earth/architecture/architecture-docs>
- Consulted 2026-08-14 (page footer: build `09f0e08` @ 2026-08-14T12:54:44Z)

Merged where it says more than the PDF:

- **Section 7** — the entire deployment view, which the PDF only links to:
  VM distribution at the Lehmann-Zentrum, Docker/Portainer, Ansible with its
  drawbacks, GitLab at RWTH Aachen, the three domain families, SSL handling,
  and the per-service deployments.
- **Section 5** — the OneStop4All internals (52°North Open Pioneer Trails,
  React/Chakra/Vite/pnpm, frontend + Solr index + SPARQL harvester) and Jena
  Fuseki named as the triple store.
- **Sections 6, 8, 11** — the placeholder wording, quoted, because it says what
  is planned rather than merely that something is missing.
- **Section 12** — the consortium's glossary entries, from
  `architecture-docs/glossary/`, marked ● in the table.

The site records the combined work as **CC BY 4.0**, the stricter of the two
licences: CC0 waives everything, so honouring CC BY over the whole satisfies
both.

## What the conversion changed

- The PDF's chapters were mapped onto arc42 sections 1, 2, 3, 4, 5 and 9.
  Chapter titles, tables and wording are the authors'.
- Sections 6, 8, 10 and 11 have no written content in either source; each says
  so and quotes what the online version does state. Section 11 additionally
  collects the risks both sources mention in passing, and reproduces the empty
  risk table with its priority definitions.
- Section 12's non-● rows (the abbreviation expansions) were written for this
  edition.
- Figures 1–4 were extracted from the PDF at their embedded resolution; the
  harvesting schedule came from the online version; the logo from
  <https://www.nfdi4earth.de/images/nfdi4earth/materials/nfdi4earth_logo.png>,
  downscaled to 1200px. All are in `../images/`. Alt text was written for this
  edition; the original figure captions are preserved in the chapter text.
- The executive summary and the acknowledgements pages are not reproduced as
  chapters; their content is on the system's overview page.

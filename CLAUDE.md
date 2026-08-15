# CLAUDE.md

Instructions for agents working in this repository. The design rules live in
`DESIGN.md` and in the schema headers of the files under `_data/`; read those
before changing anything they cover.

## Prose style

Everything published here is read as the arc42 maintainers' own voice, so
prose that reads as machine-written costs the site its credibility. Two rules.

### Do not use the em dash

No `—` in prose you write. A comma, a semicolon, a colon or a full stop will
do the same work. Rewrite the sentence if none of them fits.

The en dash `–` is a different character and it stays, in numeric and date
ranges only: `2024–2026`, `sections: 1–8`. The schema in
`_data/in-the-wild.yml` requires it there.

Existing text in this repository uses em dashes heavily. Leave it as it is.
This rule governs new prose, not a sweep through what is already written.

### Avoid the sentence shapes that mark machine-written text

Punctuation is only the surface of it. The structures matter more:

- The dramatic pivot: a clause, then a dash, then the same idea restated for
  effect.
- "Not just X, it's Y", and its relatives "isn't merely", "goes beyond",
  "more than just".
- The rule of three used as a reflex, where two items or four would be truer.
- One-word or fragment sentences dropped in for emphasis.
- A participial clause opening one sentence after another.
- A closing line that summarises the paragraph it sits at the end of.
- Throat-clearing: "Here's the thing", "The key insight", "It's worth noting",
  "That said".
- Vocabulary: delve, leverage, robust, seamless, crucial, comprehensive,
  landscape, realm, testament, underscore, and navigate used figuratively.

Let the sentence stop when the point does.

## In the wild: be generous

`/in-the-wild/` links documentation that other people wrote, published, and
usually licensed in a way that stops us hosting it. Every entry there is a
gift. Nobody owed us an arc42 document, the authors earned nothing by
publishing one, and the page would be empty without them. We are glad to have
each one.

Write the `note` in that spirit. Lead with what makes the document worth a
reader's hour. Where it is thin, say so once, plainly, and move on.

Do not build a paragraph around what is missing. Do not set strengths against
weaknesses as though the entry were being graded. Do not end a note on the
shortfall, because the last sentence is the one a reader carries away.

The schema in `_data/in-the-wild.yml` says a note covers "what is worth
looking at, or what is thin". Both still belong, and a note that flatters
everything is useless. What matters is the proportion. A note that spends its
closing third on what the authors did not do reads as a review of people who
volunteered their work.

Before publishing a note, read it as its author would. Nothing in it should
make someone regret having made their documentation public.

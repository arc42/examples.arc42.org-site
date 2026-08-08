---
title: Risks and Technical Debt
order: 11
---

The original marks this section "omitted in this example". It does, however,
close with the author's retrospective notes on the real project, and three of the
points made there are risks that actually materialized. They are reproduced here
because they say more about migration projects than an empty section would.

**The quality of the source data varied wildly.** The project had to severely
restrict the distinction it had originally introduced between *mandatory* and
*optional* data fields, because 2–3% of the more than 20 million person records
did not contain all the mandatory attributes — mandatory, that is, as the new
system needs them.

**Logical or business attributes were heavily obfuscated by extreme storage
optimizations, and immensely hard to identify.** Example: *"If this is a case of
type 42, then bit 4 of the data record (in EBCDIC format) says whether this is a
posting or a reversal."*

**Some of the logic in the existing programs was more than 30 years old** — and
for some of the legacy programs there was nobody left to ask.

See the [system overview](../) for the rest of the author's notes on the real
project.

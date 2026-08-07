---
title: Risks and Technical Debt
order: 11
---

This chapter was still an empty template in the original documentation. The
risks below are the ones the team identified explicitly while deciding on
the availability-monitoring architecture (see
[section 9](../09-architecture-decisions/)).

- **Single vantage point.** All probes originate from one GitHub-hosted
  runner region, so a network problem between that region and a site reads
  as a site outage. Mitigated by 2-of-3 confirmation; a second vantage can
  be added later without a schema change.
- **Resolution is 15 minutes, and delays are possible.** Outages shorter
  than one cycle can be missed entirely. The published copy is careful never
  to claim more than "checked every ~15 min".
- **The 60-day GitHub inactivity rule applies to the prober's dependencies.**
  If a repository that the workflow relies on goes quiet for two months,
  GitHub disables its schedule — which would surface as growing staleness
  on the page rather than as silence, but is a dependency worth watching.
- **Deferred honesty-chain layer.** Of the three layers designed to prevent
  a silent failure (static-page error panel, `stale` rendering, Slack
  alerting), only the first two are built; Slack alerting on probe failure
  itself (as opposed to site-down alerting) is still open.
- **Local badge generation was deprecated** (ADR-0006) in favour of plain
  numbers, leaving a small amount of now-unused Golang tooling in `/cmd`
  until it is cleaned up.

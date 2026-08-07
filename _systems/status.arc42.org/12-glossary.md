---
title: Glossary
order: 12
---

The glossary table was still empty placeholders in the original
documentation. The terms below are the ones actually used and defined
across the docs and ADRs.

| Term | Definition |
|---|---|
| Vantage point | The network location a probe request originates from. status.arc42.org currently has a single vantage point (one GitHub-hosted runner region); a second could be added without a schema change. |
| Honesty chain | The three-layer design that prevents an outage from failing silently: a static error panel when the backend is unreachable, a `stale` status when probe data stops advancing, and a Slack alert when a check fails. |
| Probe run | One execution of the availability prober, covering all monitored sites. Recorded as a single `probe_run` heartbeat row regardless of outcome — the signal the freshness check reads. |
| Status bucket | A per-site, per-day rollup of downtime minutes and outage count, upserted on every probe run. What the 30-day history bars render from, so rendering never scans the raw event log. |
| Status snapshot | A recorded state transition for one site (e.g. `up` → `down`), written only when the state actually changes. |
| Confirmed outage | A site is only marked `down` after 2 of 3 probe attempts, five seconds apart, fail — preventing a single dropped packet from being recorded as an incident. |
| Plausible.io | Commercial, cookie-free web analytics service used to collect visitor and pageview counts, chosen for its EU hosting and GDPR/CCPA/PECR compliance. |
| Turso | A cloud-hosted, distributed SQLite database (libSQL), used to persist availability data, rate-limit timestamps, and startup metadata. |
| Atlas | A declarative database schema management tool; the desired Turso schema is described in HCL and kept in sync with the Go code manually. |
| cron-job.org | The external cron service that triggers availability probing every 15 minutes via `POST /api/probe`, chosen over GitHub Actions cron for independence from the systems it monitors. |

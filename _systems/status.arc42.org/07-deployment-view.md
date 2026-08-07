---
title: Deployment View
order: 7
---

This chapter was still an empty template in the original documentation;
deployment is instead documented through architecture decision records. This
section pulls that material together.

## Infrastructure Level 1

```
cron-job.org (cron */15)              the 9 arc42 sites
        │                              (GitHub Pages, Netlify)
        │  POST /api/probe  ──────────────► HTTP GET
        │  (Bearer token)                      │
        ▼                                      └── compares to last known state
   status.arc42.org (fly.io)                        │
        ├── wakes & stays warm                      ├──► Turso: status_snapshot (only on change)
        ├── runs internal/probe                     ├──► Turso: status_bucket   (daily rollup)
        └── returns 200 OK                          ├──► Turso: probe_run       (heartbeat, every run)
                                                     └──► Slack: on availability failure (site down)
```

**Motivation.** The production service runs on [fly.io](https://fly.io) — an
affordable cloud provider chosen for its developer experience over hosting
anything on-premise. `cron-job.org` was chosen over a GitHub Actions cron
trigger specifically to keep the monitor independent of the systems it
watches: status.arc42.org is itself one of the nine sites it monitors, so
the prober cannot live inside the thing being monitored without losing that
independence.

**Quality and performance.** The whole loop — waking the machine, running
the probe, writing three Turso tables, alerting Slack — runs on the order of
30 seconds per 15-minute cycle, comfortably inside `cron-job.org`'s call
window, at effectively €0/month in added infrastructure.

**Mapping of building blocks to infrastructure:**

| Building block | Infrastructure |
|---|---|
| `api gateway`, `domain`, `internal/probe`, all API wrappers | Go binary, deployed as a single Fly.io machine |
| Jekyll static shell | Built and published via GitHub Pages |
| `status_snapshot`, `status_bucket`, `probe_run`, and the other application tables | Turso (distributed SQLite), schema managed declaratively via [Atlas](https://atlasgo.io) |
| Availability trigger | `cron-job.org`, external to both Fly.io and GitHub |

## Infrastructure Level 2: Local development

Local development, build, database, and deployment tasks are standardised
behind a single `Makefile`, so that developers — and AI coding agents — have
one self-documenting entry point (`make help`) instead of a set of
remembered multi-line shell incantations, for a repository that combines a
Go backend, a static Jekyll site, and both local and remote database schema
targets.

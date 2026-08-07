---
title: Building Block View
order: 5
---

## Whitebox Overall System

![Building blocks](../images/05-building-blocks.png)

| Element | Responsibility | Code |
|---|---|---|
| main | Go requires a `main` func as the application's entry point. | |
| api gateway | An HTTP server with a fixed set of routes, called from the public website. Dispatches to the domain layer and returns plain HTML to the static site (or other formats, via a technical API still in planning). | `internal/api` |
| domain | Core functionality: coordinates the various subsystems and collects results. | |
| types | A few data types and structures shared by other parts, extracted from the domain to avoid circular dependencies. | |
| github | Wrapper for the public GitHub GraphQL API. Queries repository info — open issues, bugs, pull requests — for each site. | |
| database | Wrapper for [Turso](https://turso.tech), an SQLite clone running in the cloud, chosen to avoid operating a dedicated database. | |
| fly.io | Wrapper for the [fly.io API](https://fly.io), used to find the server region the application runs in. Not to be confused with the deployment concept in [section 7](../07-deployment-view/). | |

## Availability Monitoring

Availability probing is triggered externally by `cron-job.org` calling
`POST /api/probe` on a 15-minute schedule with a bearer token (see the
availability-monitoring decision in [section 9](../09-architecture-decisions/)).

The API gateway dispatches the request to `internal/probe`, which measures
all monitored properties concurrently, performs 2-of-3 failure confirmation,
records results in Turso, and alerts Slack if any site is `down`.

`internal/availability` is the read/write and computation layer:
`internal/probe` writes transitions, daily rollups, and heartbeats through
it; `internal/api` reads it to compute the status tokens, verdict, and
30-day history shown on the pages.

Runtime storage uses three Turso tables:

- `status_snapshot` — state transitions (`site`, `status`, `changed_at`,
  `response_ms`, `detail`, `monitor_id` as `vantage`).
- `status_bucket` — daily downtime rollups per site (`site`, `bucket_start`,
  `bucket_kind='day'`, `downtime_minutes`, `outage_count`).
- `probe_run` — run heartbeat log (`run_at`, `vantage`, `sites_checked`,
  `duration_ms`).

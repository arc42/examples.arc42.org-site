---
title: Runtime View
order: 6
---

This chapter was still an empty template in the original documentation; the
scenarios below are assembled from the sequence and activity diagrams and the
architecture decisions that describe them.

## Serving the statistics table

![Fetching the stats table, with a CORS preflight](../images/06-api-call-with-cors.png)

1. A client opens `https://status.arc42.org`, which loads the static Jekyll
   site.
2. The page's `htmx` JavaScript replaces the (empty) table placeholder with a
   request for live data.
3. `htmx` issues a CORS preflight (`OPTIONS /statsTable`) against the api
   gateway, which is on a different origin — the Fly.io app, not GitHub
   Pages.
4. The gateway sets CORS headers and returns `200 OK`.
5. `htmx` issues the real request, `GET /statsTable`.
6. The gateway sets CORS headers again, performs the actual processing, and
   returns `200 OK` with the data.
7. `htmx` swaps the returned HTML table into the page; the client sees the
   result.

## Concurrent collection of statistics

Each request for site statistics fans out into a set of concurrent API
calls, one goroutine per external call, coordinated with a `sync.WaitGroup`
and no mutex:

1. `domain` iterates over all monitored sites.
2. For each site, two branches run in parallel:
   - `siteStats.GetSiteStatistics` fans out further into three parallel
     calls to Plausible.io — one each for the 7-day, 30-day and 12-month
     windows.
   - `repoStats.GetRepoStatistics` calls the GitHub GraphQL API once for the
     same site.
3. `domain` aggregates the results per site once all branches for that site
   return.

Doing this sequentially for the 7+ monitored sites — three Plausible calls
and one GitHub call each — took roughly four seconds on average; running the
calls concurrently was the direct fix.

## System startup

1. The process initialises its logger, database connection, and cache.
2. It loads site statistics once, caching them with a 10-minute expiry.
3. It loads repository statistics once, caching them with a 1-minute expiry.
4. The API server starts and detaches to keep serving requests, waiting for
   incoming HTTP requests.
5. On an external event (such as a probe run) it performs the corresponding
   processing before returning to waiting.

Startup time itself is written to a `system_startup` table, which is how the
operator can tell, after the fact, when Fly.io suspended and restarted the
machine.

## Availability probe run

Triggered externally every 15 minutes by `cron-job.org`:

1. `cron-job.org` calls `POST /api/probe` with a bearer token.
2. The call itself wakes and warms the Fly.io machine — a side effect that
   eliminates cold starts for the next human visitor.
3. `internal/probe` requests each monitored site with a 10-second timeout
   and checks status code, latency, and expected content.
4. A failing check is retried; a site is only marked `down` after 2 of 3
   attempts, five seconds apart, fail.
5. Results are written to Turso: a `status_snapshot` row only on a state
   change, an upsert into the day's `status_bucket`, and always one
   `probe_run` heartbeat row.
6. If a site is `down`, a Slack notification is sent.
7. The process returns `200 OK` and exits — the prober is a batch job, not a
   long-running service.

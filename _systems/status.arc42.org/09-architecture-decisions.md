---
title: Architecture Decisions
order: 9
---

status.arc42.org keeps its architecture decisions as individual ADRs,
following Michael Nygard's format (see ADR-0001). All twenty are reproduced
here in full, in decision order.

## ADR-0001 — Record architecture decisions

**Status:** Accepted · 2023-11-27

**Context.** We need to record the architectural decisions made on this
project.

**Decision.** We will use Architecture Decision Records, as
[described by Michael Nygard](https://thinkrelevance.com/blog/2011/11/15/documenting-architecture-decisions).

**Consequences.** See Michael Nygard's article, linked above. For a
lightweight ADR toolset, see Nat Pryce's
[adr-tools](https://github.com/npryce/adr-tools).

## ADR-0002 — Use zerolog for logging

**Status:** Accepted · 2023-11-27

**Context.** Previously several `fmt.Print*` function calls were scattered
around the code. Especially when run in the fly.io cloud, these normal print
statements didn't work properly. Therefore, issue #58 was created to track
this problem.

**Decision.** We will use [zerolog](https://github.com/rs/zerolog) for
logging.

**Consequences.**

- A global logger (`log`) is made available.
- zerolog has to be imported by all packages.

## ADR-0003 — Use Arc42Statistics struct to collect results

**Status:** Accepted · 2023-12-01

**Context.** Within the `domain` package we need to collect the results of
the various API calls (to plausible.io and github.com).

**Decision.** We use a complex struct (`types.Arc42Statistics`) to collect
these results:

```go
type Arc42Statistics struct {
    // some meta info, like AppVersion and time of last update

    // some info on the server that collected these results (e.g. fly.io region)

    // Stats4Site contains the statistics per site or subdomain
    Stats4Site [len(Arc42sites)]SiteStats

    // Totals contains the sum of all the statistics over all sites
    Totals TotalsForAllSites
}
```

Core of this is `Stats4Site`, which holds the statistics (visitors and
pageviews) for all sites:

```go
type SiteStats struct {
	Site           string // site name
	Repo           string // the URL of the GitHub repository

	// the following are received from GitHub.com
	NrOfOpenBugs   int    // the number of open bugs in that repo
	NrOfOpenIssues int    // number of open issues

	// the following are received from plausible.io
	Visitors7d     string
	Pageviews7d    string
	Visitors30d    string
	Pageviews30d   string
	Visitors12m    string
	Pageviews12m   string
}
```

Each of the three time periods (7D, 30D, 12M) needs a distinct call to
plausible.io, so these can be called in parallel goroutines. See ADR-0004
for how goroutines are used.

**Consequences.** The various funcs calling Plausible and GitHub need to
return parts of these structs, so we can collect the results.

## ADR-0004 — Parallel collection of time intervals from Plausible

**Status:** Accepted · 2023-12-01

**Context.** The visitor and pageview counts from plausible.io are
collected for three distinct time intervals (7D, 30D, 12M). Each of these
requires a single API call to plausible.io. These can be handled
sequentially or in parallel goroutines.

**Decision.** We call plausible.io in parallel goroutines for the three
time intervals.

**Consequences.** We need to implement a func to call plausible with the
site and time interval as parameter. The return value needs to include the
time interval, therefore we define a (kind-of enum) type for these
(ADR-0005).

## ADR-0005 — Concurrent access to external APIs

**Status:** Accepted · 2023-12-04

**Context.** For the 7+ arc42 websites we need 3 queries each to
plausible.io (for the three time periods) plus one GraphQL query to GitHub.
Performing these 28 queries sequentially takes approx. 4 seconds on
average, which seems too slow for the website. We therefore evaluated
concurrent access to these APIs.

**Decision.** Goroutines are an established way of performing concurrent
processing in Golang, well documented and fairly easy to implement. We
don't want the additional complexity of channels, so we stick to the
easiest programming model possible:

- Refactor the funcs calling external APIs to get a distinct pointer to a
  struct.
- Have a `sync.WaitGroup` in the func surrounding these calls.
- Do not use a mutex.

**Consequences.** —

## ADR-0006 — Create local SVG badges in Golang

**Status:** Deprecated · 2023-12-08. Update 2023-12-25: the badges shall be
replaced by pure numbers to improve visual consistency of the table.

**Context.** The badges showing the number of open issues and bugs for each
repository have to be loaded. Sending requests to the external service
(shields.io) adds a runtime dependency, and potential runtime and energy
overhead.

**Decision.**

- Pre-load at least 20 such badges for open issues and bugs to local
  storage.
- Make these badges available to the static Jekyll site under
  `images/badges/`.
- Add a function to create the appropriate path/filename combination, so
  these can be added to HTML output.

**Consequences.** A new Golang app in `/cmd`.

## ADR-0007 — Migrate to single repo

**Status:** Accepted · 2023-12-09

**Context.** Previously, the code for `status.arc42.org` was split into two
different GitHub repositories: `status.arc42.org-site` and
`site-usage-statistics`. That resulted from history: between January and
October 2023, only the static (Jekyll-based) site was available — only then
was the (dynamic, Golang-based) app developed.

This two-repo situation suffers from some drawbacks. It is unclear where to
put documentation, and where to open or maintain bugs, issues and feature
requests. Updating or releasing often needs coordinated changes in both
repositories.

**Decision.** Migrate both repositories, move content into the status repo.

**Consequences.** Build processes have to be updated. See GitHub issue #72.

## ADR-0008 — Deploy on fly.io

**Status:** Accepted · 2023-12-10

**Context.** We want to make the statistics service available online, so we
need to either host a service on-premise or in the cloud.

**Decision.** Deploy the (production) service on [fly.io](https://fly.io),
an affordable cloud service provider with a nice developer experience.

**Consequences.**

- Some secrets (API tokens) need to be configured via the fly.io command
  line tool.
- For development, the `flyctl` utility needs to be installed. See their
  [documentation](https://fly.io/docs/speedrun/) for details.

## ADR-0009 — Format large numbers with separator chars

**Status:** Accepted · 2023-12-12

**Context.** The (fairly) large access numbers for the sites result in
numbers difficult to read (e.g. 805455).

**Decision.** Numbers in the generated HTML table shall be formatted using
separators, resulting in e.g. 805.455. We decided to use the following way
to get separators:

```go
p := message.NewPrinter(language.German)
myStr := p.Sprintf("%d", 1234567)
// myStr == "1.234.567"
```

**Consequences.** Some types (e.g. `types.TotalsForAllSites`) need to carry
around both an int plus a string representation of the same value. The
string is formatted with decimal separators, whereas the numbers aren't.

## ADR-0010 — Use DataTables for dynamic sorting of table

**Status:** Accepted · 2023-12-16

**Context.** Users (in browser) shall be able to sort the table by the
various columns — see issue #69.

**Decision.**

- To make sorting dynamic, we use JavaScript for sorting.
- We use the [DataTables](https://datatables.net/manual/options) library
  for sorting, which is based on jQuery.

**Consequences.** We need to:

- Download the respective JS libraries, as documented in their installation
  guide.
- Download their CSS.
- Add the required boilerplate to the gohtml template: `<thead>`,
  `<tbody>`, `<tfoot>`; set table attributes:
  `<table id="statsTable" class="display">`.
- Create a sample HTML for demo and testing.

## ADR-0011 — Rate limiter with persistently stored last-query time

**Status:** Accepted · 2023-12-29, modified 2024-01-25

**Context.**

- The number of visitors and pageviews does not change quickly.
- Requests to our API might come frequently.
- It would be resource-friendly if we kept results of our external APIs
  (Plausible, GitHub) for appropriate times: Plausible statistics for at
  least 10 minutes, maybe even 30 or 60 minutes; GitHub issues, bugs and PR
  counts might change more frequently, so their cache retention needs to be
  lower.
- This is only valid if our service wasn't shut down by our cloud provider
  between calls to our API — if the current server is a "fresh instance",
  we have to ignore the last-time-called values.
- As we run in the cloud, we need to store the last-query time for our
  external APIs in a persistent store (DB).

**Decision.**

1. Create a table that keeps the invocation times of our own API.
2. Create tables that keep the last-query time for both Plausible and
   GitHub requests.
3. Call the Plausible.io API only once every `plausible_Rate_Limit_Minutes`
   (defaulting to 20).
4. Call the GitHub API only once every `gitHub_Rate_Limit_Minutes`
   (defaulting to 3).

The tables have the following format:

**TimeOfInvocation** — stores the datetime of invocations, plus request IP
and route.

| invocation_time | request_ip | route |
|---|---|---|
| datetime our API was called | caller IP | route that was called (e.g. `statsTable` or `ping`) |

**TimeOfPlausibleCall** — stores the datetime of the calls to the
plausible.io API.

| plausible_invocation_time |
|---|
| datetime the Plausible API was called |

**TimeOfGitHubCall** — stores the datetime of the calls to the GitHub API.

| github_invocation_time |
|---|
| datetime the GitHub API was called |

**Consequences.**

- We use turso.tech as our (cloud) database.
- Create a script/app to create that table:

```sql
CREATE TABLE TimeOfStatusRequest IF NOT EXISTS (
  TimeCalled DATETIME PRIMARY KEY,
  ServiceVersion STRING,
  RequestIP STRING
);
```

## ADR-0012 — Persistently store system startup metadata

**Status:** Accepted · 2024-01-03

**Context.** We're running this service in the cloud (mostly), and our
cloud provider [fly.io](https://fly.io) might shut down instances when it
needs to. To get a feel for fly.io's behaviour in that sense, we need to
know when the service is started or re-started.

**Decision.** We write the current time to a database table during system
startup, prior to starting the API server, via a new `system_startup`
table:

| startup | app_version | environment |
|---|---|---|
| datetime our system was started | the version of our service, kept in the global variable `AppVersion` | PROD or DEV |

**Consequences.**

- Enhance the scripts for creating, dropping and dumping tables,
  accordingly.
- Create a function to be called once, immediately after system startup.

## ADR-0013 — Use Atlas for declarative database schema management

**Status:** Accepted · 2024-01-06

**Context.** We will evolve the database schema in the course of
development. Manual DB migration or schema evolution is a nightmare,
therefore we want an automated solution.

**Decision.** [Atlas](https://atlasgo.io) is a free solution which enables
declarative schema management. A
[blog post on turso.tech](https://blog.turso.tech/database-migrations-made-easy-with-atlas-df2b259862db)
describes some more details.

**Consequences.** Describe the (desired) DB schema in HCL (the language
invented by HashiCorp for Terraform), file `db-schema.hcl`.

## ADR-0014 — Keep Atlas HCL and Go code in sync manually

**Status:** Accepted · 2024-01-07

**Context.** Database schema, table and column names are maintained with
Atlas (see ADR-0013). That involves a central `schema.hcl` file defining
table and column names. In Go code, we use those names (as constants) for
database operations. How to keep HCL and Go code in sync?

**Decision.** We decided to manually keep both in sync, and refrain from
automating this process. The file `internal/database/schema.hcl` defines
the DB schema.

**Consequences.** What becomes easier or more difficult to do, and any
risks introduced by the change, will need to be mitigated as they arise.

## ADR-0015 — Caching of results

**Status:** Accepted · 2024-01-28

**Context.** Using the external APIs from Plausible and GitHub is resource
intensive, and their results don't change too often.

**Decision.** Introduce caching, related to the rate-limiting decision
(ADR-0011). For Golang, a few caching libraries/packages exist, most
targeting large volumes of data and/or high-throughput applications. We
tested the simple packages [go-cache](https://github.com/patrickmn/go-cache)
and [zcache](https://github.com/arc242/zcache), as both have global and
entry-specific expiration times and are simple to use. `zcache` is an
updated fork of `go-cache`, and `go-cache` is no longer actively
maintained. Therefore we use `zcache`. A small example can be found in
`/cmd/cache/try-caching.go`.

**Consequences.**

- The cache needs to be typed.
- Expiration needs to be set when pushing data into the cache.

## ADR-0016 — Use Slack to inform user about important system events

**Status:** Accepted · 2024-02-02, updated 2026-08-06

**Context.** Requirement F-004 requires the owners of the system to be
informed about important system events.

**Decision.** Routine "system startup" and "acquisition of usage and
repository data" notifications are disabled. Slack notifications are sent
whenever an availability check fails — meaning a monitored domain or
subdomain is not available / down.

**Consequences.**

- A Slack app has to be created and configured.
- The [Slack API](https://pkg.go.dev/github.com/slack-go/slack@v0.12.3#section-readme)
  is used in `internal/slack`.
- `SLACK_AUTH_TOKEN` secret is passed to the availability prober workflow in
  GitHub Actions and set at fly.io.

## ADR-0017 — Use plausible.io to collect statistics

**Status:** Accepted · 2024-04-14

**Context.** A fundamental requirement is collecting usage statistics for
various arc42 websites, with high accuracy. Spam traffic shall be excluded.
Results must be compliant with EU privacy regulations, and accurate over
all websites.

**Decision.** It's perfectly possible to build a website and visitor
counter, but the effort to get both reliability and privacy right seemed
overly high, and recognizing spam traffic might be very difficult.
Therefore, we decided to use plausible.io, a commercial offering. From
their website: "Plausible is intuitive, lightweight and open source web
analytics. No cookies and fully compliant with GDPR, CCPA and PECR. Made
and hosted in the EU, powered by European-owned cloud infrastructure."

**Consequences.** Just a small JavaScript snippet has to be included in the
header of all pages that need to be included in counting. Jekyll makes this
fairly easy.

## ADR-0018 — Use env vars for API secrets and tokens

**Status:** Accepted · 2024-04-18

**Context.** (External) APIs require secrets (similar to passwords) for
access.

**Decision.** Two options were considered: environment variables, set
during deployment (for local development, kept in a non-versioned shell
script sourced once per session), or a server-based system like Keycloak.
Decision: use environment variables, as it's simpler and creates fewer
external dependencies. GitHub detects if the file is accidentally committed
into the central repo.

**Consequences.**

- Make sure the file `set-api-keys.sh` is run prior to local deployment.
- Keep the names (IDs) of the secrets in sync between deployment platforms
  and source code.

## ADR-0019 — Availability monitoring with cron-job.org prober endpoint

**Status:** Accepted · 2026-08-05, updated to **Option A** · 2026-08-06:

1. **Deterministic cron trigger via cron-job.org.** Replaced GitHub Actions
   cron with an external cron-job.org schedule calling `POST /api/probe`
   every 15 minutes. This eliminates GitHub Actions runner queue delays and
   prevents false "stale" warnings.
2. **Visitor cold-start elimination.** Every 15 minutes, the incoming
   cron-job.org HTTP ping automatically wakes/warms the Fly.io machine,
   providing instant responses for human visitors.
3. **Freshness heartbeat.** A `probe_run` table (one row per run) carries
   "last checked", maintaining the honesty chain.
4. **Slack alerting active on availability failure.** When a domain or
   subdomain availability check fails (state `down`), the prober sends a
   Slack notification.
5. **meta.arc42.org is excluded from probing.** Skipped via
   `types.Property.NoProbe`.

**Decision.** An external cron schedule on cron-job.org calls
`POST /api/probe` on the Go backend every 15 minutes with a bearer secret
key. The Go endpoint runs `internal/probe`, writes availability transitions
into Turso, and alerts Slack on outage.

### Architecture

```
cron-job.org (cron */15)              the 9 arc42 sites
        │                              (GitHub Pages, Netlify)
        │  POST /api/probe  ──────────────► HTTP GET
        │  (Bearer token)                      │
        ▼                                      └── compares to last known state
   arc42-stats (fly.io)                             │
        ├── wakes & stays warm                      ├──► Turso: status_snapshot (only on change)
        ├── runs internal/probe                     ├──► Turso: status_bucket   (daily rollup)
        └── returns 200 OK                          ├──► Turso: probe_run       (heartbeat, every run)
                                                    └──► Slack: on availability failure (site down)
```

The prober is deliberately *not* a service. It is a batch job that wakes,
measures, records, and exits — which is why it costs nothing and has
nothing to keep running.

### Probe semantics

Per site, one GET with a 10-second timeout:

| Outcome | State | `detail` |
|---|---|---|
| 2xx, latency ≤ 2000 ms, expected content present | `up` | — |
| 2xx, latency > 2000 ms | `degraded` | `slow: 3480ms` |
| 2xx but expected content missing | `degraded` | `content` |
| non-2xx, TLS error, DNS failure, or timeout | `down` | `502` / `timeout` / … |

The content assertion is a per-site expected substring (e.g. arc42.org must
contain `arc42`), which catches the "serves 200 but the build broke" case
that pure ping monitoring misses. TLS expiry is **not** checked: all
domains use Let's Encrypt with automated renewal.

A failure is confirmed before it is recorded: **2 of 3 attempts**, 5 seconds
apart, must fail before a site is declared `down`. This keeps a single
dropped packet from writing an incident.

### Storage

Uses the tables already declared in `internal/database/schema.hcl`:

- **`status_snapshot`** — one row per state change, not per sample: `site`,
  `status`, `changed_at`, `response_ms`, `detail`. The `monitor_id` column,
  added for an external provider, is repurposed to identify the probe
  vantage point (`gha-<runner-region>`), which keeps the door open for a
  second vantage later.
- **`status_bucket`** — one row per site per day: `downtime_minutes`,
  `outage_count`. Written by the same job, upserting the current day. This
  is what the history bars read, so rendering never scans the event log.
- **`probe_run`** — one row per run, not per site: `run_at`, vantage, sites
  checked, duration. Added as the freshness heartbeat (see below).

All three tables are append-mostly and tiny, but `status_bucket` is the
dominant one: every run upserts each site's daily bucket, so it is 9 sites
× 96 runs ≈ 864 bucket upserts a day, ~26,000 a month — a per-run cost, not
a per-day one. `status_snapshot` adds only a handful of transition rows on
top. `probe_run` adds one row every run regardless of outcome: 96 a day,
~2900 a month. The combined total, on the order of 30,000 writes a month,
is still roughly 0.3% of the 10M allowance — negligible.

### Freshness is derived, never asserted

The page computes staleness from the newest `probe_run` row (`run_at`), not
from the newest bucket timestamp. A bucket is a per-site daily rollup, so on
a quiet day with no transitions its timestamp would go stale even while the
prober is running fine; `probe_run` gets one row per run regardless of
outcome, so it is the true heartbeat. If the workflow stops running — GitHub
disabled the schedule, a secret expired, the job broke — `probe_run` stops
advancing and the page says so ("last checked 4 hours ago") instead of
showing a stale green. No separate heartbeat *service* is needed: the
heartbeat is a row the batch job already writes, not a second process to
keep alive; absence of new rows is itself the signal.

This is designed as a three-layer honesty chain, in which nothing can fail
silently. As implemented, only layers 1–2 are built; layer 3 is deferred:

1. The static Jekyll page renders an error panel when the fly.io app is
   unreachable — this is why the shell stays static; a page served by the
   app could not report the app being down.
2. The app renders `stale` when the probe data has stopped advancing.
3. Slack alerts when an availability check fails (`down`), so the
   maintainer learns of an incident without visiting the page.

### Cadence

`*/15 * * * *` — 96 runs per day, ~30 s each, free on a public repo. Fifteen
minutes is a deliberate choice, not a limit: GitHub's floor is 5 minutes,
but scheduled runs are delayed under load, and a status page for
documentation sites gains nothing from minute-level resolution. The
published copy states the cadence, so no reader infers more precision than
exists.

**Consequences.**

- **€0/month.** No new provider, no new machine, no volume, no plan to
  outgrow.
- **The prober is independent of everything it watches** — outside fly.io,
  outside GitHub Pages, outside Netlify.
- **The stack stays the showpiece stack.** Go, goroutines for concurrent
  probing, Turso, GitHub Actions, and Slack: the probe is a compact,
  readable example of exactly the architecture this project exists to
  demonstrate.
- **Single vantage point.** All probes originate from one GitHub-hosted
  runner region, so a network problem between that region and a site reads
  as a site outage. Mitigated by 2-of-3 confirmation; a second vantage can
  be added later without a schema change.
- **Resolution is 15 minutes, and delays are possible.** Outages shorter
  than one cycle can be missed entirely. The page must never claim more
  than "checked every ~15 min".
- **The 60-day inactivity rule applies.** If the repository goes quiet for
  two months, GitHub disables the schedule — which surfaces as growing
  staleness on the page rather than as silence.
- Secrets configured on the workflow: `TURSO_AUTH_TOKEN` and
  `SLACK_AUTH_TOKEN`.
- `schema.hcl` and the Go code must stay in sync manually (see ADR-0014).

### Alternatives considered

**Always-on fly.io machine** (`min_machines_running = 1`, goroutine ticker,
60-second resolution). The best resolution and the simplest code, at
roughly €2/month — but it puts the monitor inside the system being
monitored, and status.arc42.org is itself one of the nine monitored sites.
Rejected for independence, not for cost. If minute-level resolution is
ever wanted, this becomes the natural upgrade and the schema does not
change.

**Upptime** (GitHub-Actions-based, open source). Does essentially this
decision as a finished product, with incident issues and history in git.
Rejected because it brings its own status page and its own data layout,
duplicating the site and the Turso database this project already has;
adopting it would mean maintaining an integration instead of ~150 lines of
Go.

**Gatus** (open source, YAML-declared checks, richer semantics including
TLS expiry and conditional assertions). The most capable option, and
philosophically close to this project. Rejected because it needs its own
always-on host and volume — the same cost as the fly option, plus a second
service to operate, for capability beyond what nine documentation sites
require.

**Uptime Kuma** (open source, click-to-configure). Rejected: configuration
lives in its own database rather than in this repository, and it needs a
persistent host.

**UptimeRobot / BetterStack free tiers.** Genuinely free at this scale and
zero maintenance, but proprietary, with the availability history living in
someone else's account and leaving on their terms. Rejected on ownership,
which is the same reason the statistics themselves are collected here
rather than embedded.

## ADR-0020 — Use Make as central automation tool for build, test, database, and deployment tasks

**Status:** Accepted · 2026-08-05

**Context.** The repository consists of multiple interconnected components:
a Go backend service (`go-app/`), a static Jekyll shell website (`docs/`),
database schema management via Atlas (`go-app/internal/database/`)
targeting both local SQLite and remote TursoDB (libSQL), and cloud
deployment on Fly.io (`flyctl`). Without a central workflow runner, local
development, database migrations, and deployments require remembering
multiple complex multi-line shell commands, directory changes, and
secret-sourcing incantations.

**Decision.** We use GNU Make (`Makefile` in the repository root) as the
single, standardized entry point for all development, build, test,
database management, and deployment tasks. Key capabilities provided via
`Makefile`:

- **Environment diagnostics** — `make doctor` verifies Docker, Go,
  `flyctl`, Atlas CLI, and API secret configuration.
- **Development servers** — `make backend` and `make site` to run the two
  local dev processes.
- **Backend build & quality** — `make build`, `make test`, `make lint`,
  `make probe`.
- **Fly.io deployment** — `make fly-deploy`, `make fly-status`,
  `make fly-logs`, `make fly-ssh`, `make fly-secrets`.
- **Database & schema (Atlas)** — `make db-apply-dev`, `make db-apply-prod`,
  `make db-diff-dev`, `make db-diff-prod`, `make db-validate`,
  `make db-shell-dev`.

**Consequences.**

- Developers and AI agents have a single, self-documenting interface
  (`make help`).
- Sourcing live environment secrets (`go-app/set-api-keys.sh`) is
  automatically handled by relevant targets (`make backend`, `make probe`,
  `make db-apply-prod`).
- `make doctor` catches missing tools (`go`, `docker`, `flyctl`, `atlas`)
  early, before failures occur.

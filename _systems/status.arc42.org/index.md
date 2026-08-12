---
layout: system

permalink: /systems/status.arc42.org/

title: status.arc42.org
tagline: Usage statistics and uptime monitoring for arc42's websites.

domain: Site observability

main_goal: >-
  Give every arc42 family site an honest, self-monitoring status page —
  one that says so when its own data goes stale, instead of failing
  silently.

decisions:
  - Independent external prober, not an in-process watcher
  - Turso for durable snapshots and heartbeats
  - Go backend behind a static Jekyll shell

technologies:
  - Go
  - Jekyll
  - Turso

keywords:
  - adr
  - runtime-view
  - deployment-view
  - risk

scale: 9 arc42 family sites monitored · single maintainer · in production since 2023

order: 30

# Provenance. Confirmed by Gernot Starke, 2026-08-07: he is the author of
# this documentation and it is CC BY-SA 4.0.
attribution: Gernot Starke
licence: CC BY-SA 4.0
licence_url: https://creativecommons.org/licenses/by-sa/4.0/
source_url: https://github.com/arc42/status.arc42.org-site
imported: 2026-08
---

![status.arc42.org](images/status-arc42-org-icon.png)

status.arc42.org watches the rest of the arc42 family — arc42.org,
docs.arc42.org, examples.arc42.org and the other sites and subdomains — and
publishes two things about each of them: how many people are visiting, and
whether the site is actually up.

The system is a working instance of the architecture it advocates: a small
Go backend on Fly.io, wrapping four external APIs (Plausible, GitHub,
Fly.io, Slack) behind one domain layer, backed by a Turso database for the
little state it needs to keep. An external cron trigger — not a GitHub
Action, and not an always-on process inside the monitored system itself —
probes every site every 15 minutes, confirms failures before recording
them, and alerts Slack when one goes down.

Where MaMa-CRM and HtmlSanityCheck each document a finished system, this one
documents itself while still being built: twenty architecture decision
records track the reasoning as it happened, several revised in place as the
design changed. [Section 9](09-architecture-decisions/) reproduces all
twenty in full.

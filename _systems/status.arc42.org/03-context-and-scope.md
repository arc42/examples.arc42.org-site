---
title: Context and Scope
order: 3
---

![Business context](../images/03-context.png)

| Element | Responsibility | Code |
|---|---|---|
| Plausible.io | Web analytics SaaS platform; counts visitors and pageviews. | `/internal/plausible` |
| Fly.io | Cloud platform where status.arc42.org is deployed and executed. Also queried for the current server region via its [API](https://fly.io/docs/reference/). | `/internal/fly` |
| GitHub | Hosts every arc42 repository. Its GraphQL API returns bug and issue counts and other repository info. | `/internal/github` |
| Slack | Notification service. Sends a message to a configured channel when an availability check fails for a monitored site. | `/internal/slack` |
| Turso Database | Cloud-hosted, multi-instance SQLite database. Stores availability snapshots, daily buckets, probe-run heartbeats, and application startup times. | `/internal/database` |
| cron-job.org | External cron trigger. Calls `POST /api/probe` every 15 minutes with a bearer token, driving availability probing and keeping the Fly.io machine warm. | `/internal/api`, `/internal/probe` |

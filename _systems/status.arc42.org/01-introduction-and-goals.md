---
title: Introduction and Goals
order: 1
---

status.arc42.org exists to answer two questions about every site in the arc42
family: how many people are visiting it, and is it actually up.

## Requirements Overview

- **F-001** — publish current usage statistics of arc42 websites.
- **F-002** — publish current repository statistics (issues, bugs) of arc42
  websites.
- **F-003** — store important results and events persistently for future
  reference.
- **F-004** — inform owners of important system events, such as site
  availability outages, via Slack.
- **F-005** — monitor availability of all arc42 websites and subdomains,
  storing uptime history and alerting owners on outages.

## Quality Goals

- **Accurate** — site usage (pageviews, visitors) and availability
  measurements must be correct. Spam and bot traffic is excluded.
  Availability checks confirm an outage (2-of-3 retries) before recording it,
  so a single dropped packet never writes an incident.
- **Understandable** — at least 90% of users should be able to understand the
  displayed data without further instruction, as measured by a user survey.
- **Environmentally friendly** — reduce the computing resources used as much
  as possible.
- **Reliable** — the system achieves a minimum uptime of 99.9% per month.
  Recovery from any single point of failure should not exceed 5 minutes.
  Error rates should not exceed 0.1% of transactions.
- **Available & responsive** — statistics and availability data are available
  24×7. A periodic cron trigger (`cron-job.org`) keeps the Fly.io machine
  warm, so visitors see no cold-start delay.
- **Privacy-compliant** — collection of statistics is compliant with European
  data-privacy regulations as far as possible: no cookies, no personal user
  information beyond browser/device type and coarse geolocation.

## Stakeholders

Not spelled out as a table in the original documentation. Implicitly: the
**arc42 maintainers**, who need trustworthy numbers to justify time spent on
each site, and **site visitors and committers**, who see the published
statistics and status pages.

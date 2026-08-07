---
title: Cross-cutting Concepts
order: 8
---

This chapter was still an empty template in the original documentation. The
concepts below are the ones that recur across status.arc42.org's building
blocks, each originally documented as its own architecture decision record.

## Logging

A single global `zerolog` logger, imported by every package. Chosen after
plain `fmt.Print*` calls turned out not to work properly once the service
ran inside Fly.io's cloud runtime.

## Caching and rate limiting

External calls to Plausible and GitHub are both cached and rate-limited,
because neither result changes quickly and both APIs are comparatively
expensive to call:

- Plausible results are cached and re-fetched at most every 20 minutes.
- GitHub results (issues, bugs, PRs) are cached and re-fetched at most every
  3 minutes, since they change faster.

Rate-limiting state — the last-call time per API — is stored in Turso rather
than in memory, because the Fly.io machine can be stopped and restarted
between calls; an in-memory value would silently reset and defeat the rate
limit. Caching itself uses `zcache`, an actively maintained fork of the
now-unmaintained `go-cache`.

## Secrets

API tokens and secrets are passed as environment variables, sourced from a
non-versioned shell script for local development, and configured directly on
the deployment platform (Fly.io, GitHub Actions) in production. A
server-based secret store (such as Keycloak) was rejected as unnecessary
complexity for this system's size.

## Number formatting

Visitor and pageview counts are large enough (e.g. 805455) to be hard to
read at a glance. The application formats them with locale separators
(`805.455`) using Go's `golang.org/x/text/message` package, which means
every count is carried as both a raw `int` and a pre-formatted string.

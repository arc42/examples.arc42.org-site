---
title: Solution Strategy
order: 4
---

- Implement in Go — chosen because it deploys cleanly to the cloud.
- Use [Plausible.io](https://plausible.io) to collect usage data — a
  commercial service with excellent data privacy and no cookies.
- Serve the main site with a static site generator (Jekyll, GitHub Pages).
- Use [fly.io](https://fly.io) for cloud deployment of the Go backend.
- Use [turso.tech](https://turso.tech) for cloud data storage.

Fully open source, source hosted in a
[public GitHub repository](https://github.com/arc42/status.arc42.org-site).

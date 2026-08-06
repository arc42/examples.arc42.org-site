---
layout: system
permalink: /systems/sample-system/

title: Sample System
tagline: A placeholder, here to show what a tile and a documentation look like.

domain: Demonstration
main_goal: Show every part of the site's structure with one example in place.

decisions:
  - One directory per system
  - Markdown as the canonical source
  - Twelve sections, always

technologies:
  - Jekyll
  - Liquid
  - SCSS

scale: 13 files · 0 users · never shipped

order: 10

attribution: The arc42 maintainers
licence: CC BY-SA 4.0
licence_url: https://creativecommons.org/licenses/by-sa/4.0/
source_url: https://github.com/arc42/examples.arc42.org-site
imported: 2026-08
---

**This is not a real system.** It exists so that the dashboard, the overview
page, the rail and the stepper all have something to render while the site is
being built, and so that the first real contributor can see a filled-in
example next to the empty skeleton in `_systems/_TEMPLATE/`.

Delete this directory — `rm -rf _systems/sample-system` — as soon as two real
examples are in place. Nothing else references it: no navigation entry, no
config key, no list. That is the point of the structure.

---
layout: home
title: Architecture examples

# Rendered BELOW the grid (2026-08-12), not above it. Both paragraphs send the
# reader somewhere else, and they used to stand between the hero and the first
# example — so the page opened with a claim and a redirect, and no example was
# on screen at any viewport width. What stays above the grid is the one
# sentence that says what the things below it are.
#
# Markdown, rendered by `markdownify` in _layouts/home.html — which means NO
# Liquid runs in here. The In the Wild link is therefore a plain root path
# rather than `relative_url`; `baseurl` is empty in _config.yml, and
# `make check-links` fails the build if that ever stops being true.
endnotes: >-
  Reading for one arc42 section rather than for one system? Every section has
  a page of its own, gathering that section from each documentation here:
  [the twelve sections](/sections/).


  Looking for short, section-sized illustrations instead? Those live with the
  template documentation at [docs.arc42.org](https://docs.arc42.org).


  More arc42 documentation exists that cannot live here — other people's
  systems, on other people's sites, under licences that do not let us
  republish them. Those are listed under [In the Wild](/in-the-wild/).
# The invitation tile (2026-09-10). Content and slot live here, as the
# endnotes do; the markup is _includes/invite-tile.html and the placement is
# in _layouts/home.html. `after` is the number of grid CELLS it follows
# (2026-09-25; it was the catalogue number until the featured tile, which
# fills two cells, made the two differ). 4 puts it at the centre of a
# three-by-three block, and a fixed slot keeps it there as examples arrive
# instead of letting it drift to the end of the grid. It is not a system, so
# it is not counted by the sentence above the grid and it carries no
# catalogue number.
invite:
  after: 4
  eyebrow: An invitation
  title: Your documentation belongs here
  text: >-
    A few thousand people read these examples every month. If you have
    documented a real system along arc42 and may publish it, we would like to
    add it. If you cannot republish it, a link is welcome too.
  call: How to contribute
# "Recently added" (2026-09-25). A tile whose `imported:` month falls inside
# the last `months` calendar months, counting the month of the build, gets a
# tab on its top edge that says when it arrived: "Added Sep 2026". The month
# is printed, not just "New", because the page changes only when the site is
# rebuilt and nothing rebuilds it on a timer; a dated tab is still true on a
# page nobody has rebuilt for a quarter. `since` keeps the founding
# collection, everything imported in August 2026, from ever counting as new.
# Rationale in DESIGN.md, "Recently added and featured".
recent:
  months: 2
  since: 2026-09
# The featured example (2026-09-25). One system, chosen by a person, moved to
# the head of the grid for as long as `until` has not passed. It keeps its
# catalogue number, so the order of the others does not change and the gap
# in the numbering shows where it came from. `why` is the maintainers' voice,
# the same voice as an /in-the-wild/ note, so write it in that spirit. `image`
# is a path inside the system's own directory and is shown only where the
# tile has two columns to show it in. Delete the block, or let `until` pass,
# and the grid is back to plain `order`.
featured:
  system: nfdi4earth
  until: 2026-10-31
  why: >-
    Thirteen authors from a national consortium agreed on one architecture
    and wrote it down. Section 3 says plainly what the infrastructure will
    not do, and section 4 tells the strategy as the services it produces.
  image: images/02-software-architecture.png
  alt: >-
    The NFDI4Earth services drawn as a honeycomb, coloured by function, with
    the five services the consortium builds itself numbered one to five.
---

{%- comment -%}
  The count is computed, not written. At rest this page never said how many
  examples exist — the number only appeared once you typed into the filter,
  and the filter is gone (2026-08-12). A written "six" goes stale the day the
  seventh example lands. Same landing-page condition as _layouts/home.html
  uses to build the grid; the two must agree or the sentence miscounts the
  tiles directly below it.

  IT COUNTS TILES, MINUS THE ANNOUNCED ONES (2026-08-14). The sentence calls
  every example below it "a complete architecture documentation", and an
  `upcoming: true` tile is the one thing on this page that is not: it has no
  sections at all. Counting it made the page's first claim false — so the
  landing set is split and the number promises only what is written. It stays
  computed; it never goes stale.
{%- endcomment -%}
{%- assign landings = site.systems
      | where_exp: 'd', 'd.url contains "/systems/"'
      | where_exp: 'd', 'd.title'
      | where_exp: 'd', 'd.tagline' -%}
{%- assign upcoming = landings | where: 'upcoming', true -%}
{%- assign example_count = landings.size | minus: upcoming.size -%}
Each of the {{ example_count }} completed examples below is a **complete
architecture documentation** of a real system, written along the arc42
structure. Different domains, different scales, different technologies.

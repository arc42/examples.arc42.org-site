---
layout: default
title: arc42 Documentation in the Wild
permalink: /in-the-wild/

# Hero band art (_sass/_masthead.scss). The H1 moves into the band and must
# not be repeated in the body below.
hero: wild

# The title is indexed, the body is not: search.json emits one record per
# ENTRY, anchored at that entry, so a reader searching "DokChess" lands on
# DokChess rather than at the top of a list containing it. Indexing the page
# as well would return the whole page for every query that matches any entry.
search_body: false
---
{%- comment -%}
  The external reading list. Entries come from _data/in-the-wild.yml; the runs
  they are grouped into, and the order of those runs, come from
  _data/in-the-wild-runs.yml. Both are editorial orders — do not sort here.
  Why this is a bibliography and not a tile grid is in those files' headers
  and in _sass/_in-the-wild.scss.
{%- endcomment -%}
{%- assign entries = site.data['in-the-wild'] -%}
{%- assign runs = site.data['in-the-wild-runs'] -%}

<div class="ex-shell ex-shell--wild">
  
  <div class="ex-prose">
    <p>These are arc42 documentations we cannot host, usually
    because their licence does not allow it.
    We link them because we consider them useful or interesting.
    We have <strong>not</strong> checked their structure and content.
    That is the difference between this page and the
    <a href="{{ '/' | relative_url }}">examples</a>.
    </p>

    <p class="ex-wild-howto">Ordered roughly easiest first. Start at the top if
    arc42 is new to you, otherwise skip to
    <a href="#{{ runs.last.id }}">{{ runs.last.title }}</a>.
    Every note is ours, and dated.
    </p>
  </div>

  {%- if entries and entries.size > 0 -%}

  {%- comment -%}
    Contents, and only once the list has outgrown a couple of screens. Below
    eight entries every run heading is already on screen and an index would
    print each title twice for nothing.

    This is the one place an entry carries a SECOND link. One-link-per-entry
    exists to keep a tile's tab order honest; an index link is a different job,
    and without it nothing on this page is addressable.
  {%- endcomment -%}
  {%- if entries.size >= 8 -%}
  <nav class="ex-wild-toc" aria-label="Contents">
    <p class="ex-wild-toc__label">On this page</p>
    <ul class="ex-wild-toc__runs">
      {%- for run in runs -%}
      {%- assign in_run = entries | where: 'group', run.id -%}
      {%- if in_run.size > 0 -%}
      <li class="ex-wild-toc__run">
        <p class="ex-wild-toc__runname"><a href="#{{ run.id }}">{{ run.title }}</a></p>
        <ul class="ex-wild-toc__items">
          {%- for entry in in_run -%}
          <li><a href="#{{ entry.title | slugify }}">{{ entry.title }}</a></li>
          {%- endfor -%}
        </ul>
      </li>
      {%- endif -%}
      {%- endfor -%}
    </ul>
  </nav>
  {%- endif -%}

  {%- comment -%}
    `placed` records what the runs rendered, so the orphan pass below can find
    entries whose `group` matches no run. Bars either side of the title stop
    one title matching another that contains it.
  {%- endcomment -%}
  {%- assign placed = '' -%}

  {%- for run in runs -%}
  {%- assign in_run = entries | where: 'group', run.id -%}
  {%- if in_run.size > 0 -%}
  <section class="ex-wild-run" aria-labelledby="{{ run.id }}">
    <h2 class="ex-wild-run__name" id="{{ run.id }}">{{ run.title }}</h2>
    <p class="ex-wild-run__blurb">{{ run.blurb }}</p>
    <ol class="ex-wild">
      {%- for entry in in_run -%}
      {% include in-the-wild-entry.html entry=entry %}
      {%- assign placed = placed | append: '|' | append: entry.title | append: '|' -%}
      {%- endfor -%}
    </ol>
  </section>
  {%- endif -%}
  {%- endfor -%}

  {%- comment -%}
    Orphans: an entry whose `group` is missing or misspelt. It renders with no
    heading above it, straight after the headed runs, because it is meant to
    look wrong — silently dropping an entry a contributor added is the one
    failure mode this grouping could introduce. `make check` catches it first.
  {%- endcomment -%}
  {%- assign orphan_count = 0 -%}
  {%- for entry in entries -%}
  {%- assign needle = '|' | append: entry.title | append: '|' -%}
  {%- unless placed contains needle -%}{%- assign orphan_count = orphan_count | plus: 1 -%}{%- endunless -%}
  {%- endfor -%}
  {%- if orphan_count > 0 -%}
  <ol class="ex-wild">
    {%- for entry in entries -%}
    {%- assign needle = '|' | append: entry.title | append: '|' -%}
    {%- unless placed contains needle -%}
    {% include in-the-wild-entry.html entry=entry %}
    {%- endunless -%}
    {%- endfor -%}
  </ol>
  {%- endif -%}

  {%- else -%}
  <div class="ex-prose">
    <div class="ex-note">
      <p><strong>Nothing here yet.</strong> This list is filled from
      <code>_data/in-the-wild.yml</code>. If you know of arc42 documentation that
      cannot be republished here, see
      <a href="{{ '/contribute/' | relative_url }}">Contribute</a>.</p>
    </div>
  </div>
  {%- endif -%}
</div>

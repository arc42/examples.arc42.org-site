---
layout: default
title: Documented elsewhere
permalink: /elsewhere/
---
{%- comment -%}
  The external reading list. Content comes entirely from _data/elsewhere.yml,
  whose header documents the fields and says why the tile fields are absent.

  NOT TILES, and that is the whole design. A dashboard tile is the summary of a
  completed audit — domain, main goal, decisions, technologies, scale — and
  every one of those fields can only be filled in by someone who has read all
  twelve sections. For a link we have not audited a tile would be either
  half-empty or fabricated, so this is set as a BIBLIOGRAPHY instead: name,
  description, note, hairline facts line, rule between entries.

  Genre is doing the work here, and it is doing it better than styling could.
  A reader recognises a bibliography as a different kind of thing from a
  dashboard before reading a word of the disclaimer — which matters on a site
  whose own rules forbid a purely visual distinction from carrying meaning
  alone. A "downgraded tile" (dashed border, no hover-lift) was considered and
  rejected: near-equivalence is exactly what implies equivalence of quality.

  If someone later "unifies" this page with the dashboard, they will have
  quietly promised that these links have been checked. They have not.
{%- endcomment -%}
{%- assign entries = site.data.elsewhere | sort_natural: 'title' -%}

<div class="ex-shell ex-shell--prose">
  <div class="ex-prose">
    <h1>Documented elsewhere</h1>

    <p>These are arc42 documentations we cannot host — usually because their
    licence does not allow it. We link them because they are useful, not
    because we have checked them. Nobody here has read every one of these end
    to end, several are partial, and the note under each is one person's
    opinion on the date it was added. Everything on the
    <a href="{{ '/' | relative_url }}">home page</a>, by contrast, has been
    read in full and carries its provenance.</p>
  </div>

  {%- if entries and entries.size > 0 -%}
  <ol class="ex-elsewhere">
    {%- for entry in entries -%}
    {%- comment -%}
      The host, shown in the facts line, is how a reader knows where a link
      goes before clicking it. That is also why these links do NOT open in a
      new tab, unlike the external links in the site footer: a page whose
      entire content is external links would spawn one tab per click, and
      WCAG 3.2.5 asks us not to open windows without warning. Showing the
      destination is the warning.
    {%- endcomment -%}
    {%- assign host = entry.url | split: '//' | last | split: '/' | first | remove_first: 'www.' -%}
    <li class="ex-elsewhere__item">
      {%- comment -%}
        Exactly ONE link per entry, on the title — the same discipline the
        dashboard tiles keep. A second link on the URL would announce every
        entry twice to a screen reader.
      {%- endcomment -%}
      <h2 class="ex-elsewhere__name">
        <a href="{{ entry.url }}" rel="noopener noreferrer">{{ entry.title }}</a>
      </h2>

      <p class="ex-elsewhere__desc">{{ entry.description }}</p>

      {%- if entry.note -%}
      <p class="ex-elsewhere__note">{{ entry.note }}</p>
      {%- endif -%}

      <p class="ex-elsewhere__facts">
        {{- entry.author -}}
        {%- if entry.language %} &middot; {{ entry.language }}{% endif -%}
        {%- if entry.year %} &middot; {{ entry.year }}{% endif -%}
        {%- if entry.added %} &middot; added {{ entry.added }}{% endif -%}
        {%- if host %} &middot; {{ host }}{% endif -%}
      </p>
    </li>
    {%- endfor -%}
  </ol>
  {%- else -%}
  <div class="ex-prose">
    <div class="ex-note">
      <p><strong>Nothing here yet.</strong> This list is filled from
      <code>_data/elsewhere.yml</code>. If you know of arc42 documentation that
      cannot be republished here, see
      <a href="{{ '/contribute/' | relative_url }}">Contribute</a>.</p>
    </div>
  </div>
  {%- endif -%}
</div>

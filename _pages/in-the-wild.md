---
layout: default
title: arc42 Documentation in the Wild
permalink: /in-the-wild/

# Hero band art (_sass/_masthead.scss). The H1 moves into the band and must
# not be repeated in the body below.
hero: wild
---
{%- comment -%}
  The external reading list. Entries and their order both come from
  _data/in-the-wild.yml — do not sort here. Why this is a bibliography and
  not a tile grid is in that file's header and in _sass/_in-the-wild.scss.
{%- endcomment -%}
{%- assign entries = site.data['in-the-wild'] -%}

<div class="ex-shell ex-shell--wild">
  <div class="ex-prose">
    <p>These are arc42 documentations we cannot host, often because their
    licence does not allow it.
    We link them because we consider them useful or interesting.
    We have checked their content or structure.
    The notes under each is our personal opinion on the date it was added.
    </p>
  </div>

  {%- if entries and entries.size > 0 -%}
  <ol class="ex-wild">
    {%- for entry in entries -%}
    {%- comment -%}
      The host is shown in the facts line so a reader knows where a link goes.
      That is why these links do not open in a new tab (WCAG 3.2.5): showing
      the destination is the warning.
    {%- endcomment -%}
    {%- assign host = entry.url | split: '//' | last | split: '/' | first | remove_first: 'www.' -%}
    <li class="ex-wild__item">
      {%- comment -%} __main is the grid's left track; the facts list is the right one. {%- endcomment -%}
      <div class="ex-wild__main">
        {%- comment -%} Exactly one link per entry, on the title. {%- endcomment -%}
        <h2 class="ex-wild__name">
          <a href="{{ entry.url }}" rel="noopener noreferrer">{{ entry.title }}</a>
        </h2>

        <p class="ex-wild__by">{{ entry.author }}</p>

        <p class="ex-wild__desc">{{ entry.description }}</p>

        {%- comment -%}
          A facet is a checkable fact about the DOCUMENT, never about the
          system — the rule and the five-item ceiling are in
          _data/in-the-wild.yml.
        {%- endcomment -%}
        {%- if entry.facets and entry.facets.size > 0 -%}
        <ul class="ex-chips ex-wild__facets" aria-label="About this documentation">
          {%- for f in entry.facets limit: 5 -%}
          <li class="ex-chip">{{ f }}</li>
          {%- endfor -%}
        </ul>
        {%- endif -%}

        {%- if entry.note -%}
        <p class="ex-wild__note">{{ entry.note }}</p>
        {%- endif -%}
      </div>

      {%- comment -%}
        Separators are borders, not characters: CSS-generated punctuation gets
        announced, so do not put middots back. The sr-only labels are what name
        values that arrive as bare strings out loud.
      {%- endcomment -%}
      <ul class="ex-wild__facts" aria-label="Provenance">
        {%- if entry.language %}<li><span class="ex-sr-only">Language: </span>{{ entry.language }}</li>{% endif -%}
        {%- if entry.year %}<li><span class="ex-sr-only">Written: </span>{{ entry.year }}</li>{% endif -%}
        {%- if entry.licence %}<li><span class="ex-sr-only">Licence: </span>{{ entry.licence }}</li>{% endif -%}
        {%- if host %}<li><span class="ex-sr-only">Published at: </span>{{ host }}</li>{% endif -%}
        {%- if entry.added %}<li>added {{ entry.added }}</li>{% endif -%}
      </ul>
    </li>
    {%- endfor -%}
  </ol>
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

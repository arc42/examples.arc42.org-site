---
layout: default
title: arc42 Documentation in the Wild
permalink: /in-the-wild/

# Opts this page into a hero band and names its art. Home's herbarium is
# specimens collected, pressed and mounted in one identical format; this is a
# roadside verge with the roots showing — the same plants, where they actually
# grow, which is the metaphor the page name already carries. See
# _sass/_masthead.scss for the crop, and _includes/masthead.html for the H1,
# which moves into the band and must not be repeated in the body below.
hero: wild
---
{%- comment -%}
  The external reading list. Content comes entirely from _data/in-the-wild.yml,
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
{%- comment -%}
  No sort. The order in _data/in-the-wild.yml IS the order on the page, and
  that file's header explains the editorial rule behind it (easiest first,
  deepest last, not a ranking). If you reinstate `| sort_natural: 'title'`
  here, delete that rule there too — a documented reading order that the
  template silently overrides is worse than no order at all.
{%- endcomment -%}
{%- assign entries = site.data['in-the-wild'] -%}

{%- comment -%}
  Not --prose. This page needs room for the catalogue rail beside the entries,
  and _sass/_in-the-wild.scss derives the exact cap from the measure plus the
  rail. The intro paragraph below is capped at --measure by .ex-prose on its
  own, so it keeps the same left edge and the same line length it had — the
  shell got wider, the reading column did not.
{%- endcomment -%}
<div class="ex-shell ex-shell--wild">
  <div class="ex-prose">
    {%- comment -%}
      No <h1> here. It lives in the hero band (front matter `hero: wild`,
      rendered by _includes/masthead.html from page.title), and a second one
      on the page would be a second H1 announcing the same words twice.
    {%- endcomment -%}
    <p>These are arc42 documentations we cannot host — usually because their
    licence does not allow it. We link them because they are useful, not
    because we have checked them. Nobody here has read every one of these end
    to end, several are partial, and the note under each is one person's
    opinion on the date it was added. Everything on the
    <a href="{{ '/' | relative_url }}">home page</a>, by contrast, has been
    read in full and carries its provenance.</p>
  </div>

  {%- if entries and entries.size > 0 -%}
  <ol class="ex-wild">
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
    {%- comment -%}
      Two children, and above 1040px they are two columns: everything a reader
      READS on the left, the catalogue data on the right. The wrapper div is
      what makes that a two-track grid without the entry's five text blocks
      each becoming a track of their own.

      Source order is reading order and is unchanged by the grid — title,
      author, description, facets, note, then provenance. Nothing here is
      reordered visually, so nobody hears it in a different order than they
      see it.
    {%- endcomment -%}
    <li class="ex-wild__item">
      <div class="ex-wild__main">
      {%- comment -%}
        Exactly ONE link per entry, on the title — the same discipline the
        dashboard tiles keep. A second link on the URL would announce every
        entry twice to a screen reader.
      {%- endcomment -%}
      <h2 class="ex-wild__name">
        <a href="{{ entry.url }}" rel="noopener noreferrer">{{ entry.title }}</a>
      </h2>

      {%- comment -%}
        The author is a BYLINE under the title now, not an item in the rail,
        and the reason is measurement rather than bibliographic taste (though
        it is also the bibliographic form): "Students of the Software
        Engineering degree, University of Oviedo" is 433.4px in the shipped
        Atkinson woff2 at 0.875rem, which is three wrapped lines in a 200px
        rail and one line here.
      {%- endcomment -%}
      <p class="ex-wild__by">{{ entry.author }}</p>

      <p class="ex-wild__desc">{{ entry.description }}</p>

      {%- comment -%}
        Facets sit ABOVE the note, not down with the facts line, because they
        answer a question that comes first. A reader meeting "Fictional
        teaching example" has already decided whether to spend an hour here,
        and should not have to read our opinion of a document to find out what
        kind of document it is. The note is a judgement about something you
        have already identified; these are the identification.

        The rule for what may appear here is in _data/in-the-wild.yml and is
        not a formatting rule: a facet is a checkable fact about the DOCUMENT.
        The moment one describes the SYSTEM this page is a tile grid again,
        promising an audit nobody performed.

        Chips, which _sass/_in-the-wild.scss once ruled out for this component
        — see the note there for why that changed. Same `.ex-chip` as the
        dashboard on purpose: it is the site's small neutral label and there is
        no reason for a second one. The genre distance from a tile is carried
        by everything this entry still does not have (card, fill, lift,
        catalogue number, stretched link), which is a structural difference and
        survives a reader who has never seen the dashboard.

        aria-label, because a row of four unlabelled list items announces as a
        list of four items and nothing else. `limit: 5` matches the ceiling the
        data file documents; it truncates rather than wrapping to a second row.
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
        The rail: where this documentation came from and what you may do with
        it. A LIST and no longer a middot-separated sentence, because above
        1040px it sets one fact per line and a run of fragments glued with
        middots is not a sentence in any case — it was a list wearing prose
        punctuation. Below the breakpoint the same list runs inline again,
        separated by a hairline border rather than by a generated middot: a
        border is never announced, and CSS-generated punctuation is.

        The sr-only labels are the other half of that. On screen, position and
        format say which fact is which; out loud, "2024 to 2025" and "CC BY-NC
        4.0" arrive as bare strings. `added` keeps its visible prefix because
        it is the one fact that is about US rather than about the document —
        it dates our note, not their work — and it is last for the same reason.

        The licence sits beside the host deliberately: the page opens by saying
        these are documentations we cannot host, and for most entries the
        licence IS that reason.
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

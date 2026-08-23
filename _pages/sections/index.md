---
layout: default
title: The twelve sections
permalink: /sections/

# Not indexed as a page: search.json already carries a record for every
# section of every system, and this page's body is a list of twelve titles
# that all of them share. A hit here would displace the real one.
search_body: false
---
{%- comment -%}
  The parent route. Every documented system here follows the same twelve arc42
  sections, so the corpus can be read the other way round: pick a section, and
  see how each system handled it.

  The list is built from the twelve stubs in this directory, not written out
  here, so renaming a section is one edit in one file.
{%- endcomment -%}
<div class="ex-shell ex-shell--prose">
  <nav class="ex-breadcrumb" aria-label="Breadcrumb">
    <ol>
      <li><a href="{{ '/' | relative_url }}">Examples</a></li>
      <li aria-current="page">The twelve sections</li>
    </ol>
  </nav>

  <div class="ex-prose">
    <h1>The twelve sections</h1>
    <p>Every documentation here follows the same arc42 structure, which means
    the corpus can be read across as well as down. Pick a section and see how
    each system handled it: what a building block view looks like when the
    system is small, and what it looks like when it is a federation.</p>
    <p>The template itself, and what belongs in each section, is at
    <a href="https://docs.arc42.org">docs.arc42.org</a>.</p>
  </div>

  {% include section-grid.html %}
</div>

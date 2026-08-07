---
layout: default
title: Search
permalink: /search/
# Keep the search page out of its own index — a hit that leads back to the
# search form answers nothing.
search: false
sitemap: false
---
<div class="ex-shell ex-shell--prose" data-search-page data-search-index="{{ '/search.json' | relative_url }}">
  <div class="ex-prose">
    <h1>Search</h1>

    <p>Every word of every example is indexed, not just the section titles —
    so <code>Drools</code>, <code>template method</code> or
    <code>quality scenario</code> will find the section that discusses them.</p>

    <form class="ex-searchpage__form" role="search" onsubmit="return false;">
      <label class="ex-searchpage__label" for="search-input">Search term</label>
      <input class="ex-searchpage__input" type="search" id="search-input" name="q"
             autocomplete="off" autocorrect="off" autocapitalize="off"
             spellcheck="false" placeholder="system, technology, decision&hellip;">
    </form>

    <noscript>
      <div class="ex-note">
        <p><strong>This search needs JavaScript.</strong> Without it there is no
        index to query — the site ships one JSON file and builds the index in
        the browser, because GitHub Pages has no search server to ask.</p>
        <p>Everything is still reachable without it: the
        <a href="{{ '/' | relative_url }}">dashboard</a> lists every example,
        and each example's overview page lists all twelve of its sections.</p>
      </div>
    </noscript>

    <p class="ex-searchpage__count" id="search-count" role="status" aria-live="polite"></p>
    <ol class="ex-searchpage__results" id="search-results"></ol>
  </div>
</div>

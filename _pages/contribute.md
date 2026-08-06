---
layout: default
title: Contribute an example
permalink: /contribute/
---
<div class="ex-shell ex-shell--prose">
<div class="ex-prose">

<h1>Contribute an example</h1>

<p>An example is one directory. Adding one changes nothing outside it — there
is no navigation file to edit, no index to update, no configuration to touch.</p>

<h2>What we are looking for</h2>

<ul>
  <li>A <strong>complete</strong> arc42 documentation — all twelve sections,
      even where a section only says "not documented in the original". A
      partial documentation is a snippet, and snippets belong on
      <a href="https://docs.arc42.org">docs.arc42.org</a>.</li>
  <li>A <strong>real</strong> system. Anonymised is fine; invented is not.</li>
  <li>Clear <strong>provenance</strong>: who wrote it, under what licence, and
      permission to republish it here. This is the one thing a pull request
      cannot be merged without.</li>
</ul>

<h2>How</h2>

<ol>
  <li>Fork <a href="https://github.com/arc42/examples.arc42.org-site">the repository</a>.</li>
  <li><code>make new-system SLUG=your-system</code> — this copies
      <code>_systems/_TEMPLATE/</code> and fixes the one line that names the
      directory.</li>
  <li>Fill in <code>index.md</code> first. Its front matter <em>is</em> the
      dashboard tile.</li>
  <li>Write the twelve sections. Images go in your directory's
      <code>images/</code>; anything you converted from
      (AsciiDoc, PlantUML, drawio) goes in <code>_originals/</code>, which is
      kept for provenance and never published.</li>
  <li><code>make dev</code>, look at it, then open a pull request.</li>
</ol>

<h2>Markdown is canonical</h2>

<p>Whatever the documentation was written in, the Markdown in this repository
becomes the source of truth once it is merged. Examples are snapshots and are
not synchronised with their originals, so there is nothing to round-trip —
which is why the site needs no conversion step at build time and runs on plain
GitHub Pages.</p>

<h2>House rules for the writing</h2>

<ul>
  <li>Keep the arc42 section titles. Readers navigate by them.</li>
  <li>Say when something is missing rather than deleting the section. An
      honest gap is useful to someone comparing examples.</li>
  <li>No colour-coding of your own — the site is deliberately neutral and its
      only colour is the spine.</li>
</ul>

</div>
</div>

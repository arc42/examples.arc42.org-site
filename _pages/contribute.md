---
layout: default
title: Contribute
permalink: /contribute/
---
<div class="ex-shell ex-shell--prose">
<div class="ex-prose">

<h1>Contribute</h1>

<p>There are two things you can send us: a documentation to publish here, or a
link to one we cannot publish. Which one you have depends on two questions —
is it complete, and are you allowed to republish it?</p>

<table>
  <thead>
    <tr><th>What you have</th><th>Where it goes</th></tr>
  </thead>
  <tbody>
    <tr>
      <td>Complete, and republishable here</td>
      <td>An example directory — the rest of this page</td>
    </tr>
    <tr>
      <td>Complete, but not republishable</td>
      <td><a href="#documentation-we-cannot-host">A link under <em>Elsewhere</em></a></td>
    </tr>
    <tr>
      <td>A fragment of a single section</td>
      <td><a href="https://docs.arc42.org">docs.arc42.org</a></td>
    </tr>
  </tbody>
</table>

<h2>Contribute an example</h2>

<p>An example is one directory. Adding one changes nothing outside it — there
is no navigation file to edit, no index to update, no configuration to touch.</p>

<h3>What we are looking for</h3>

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

<h3>How</h3>

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

<h3>Markdown is canonical</h3>

<p>Whatever the documentation was written in, the Markdown in this repository
becomes the source of truth once it is merged. Examples are snapshots and are
not synchronised with their originals, so there is nothing to round-trip —
which is why the site needs no conversion step at build time and runs on plain
GitHub Pages.</p>

<h3>House rules for the writing</h3>

<ul>
  <li>Keep the arc42 section titles. Readers navigate by them.</li>
  <li>Say when something is missing rather than deleting the section. An
      honest gap is useful to someone comparing examples.</li>
  <li>No colour-coding of your own — the site is deliberately neutral and its
      only colour is the spine.</li>
</ul>

<h2 id="documentation-we-cannot-host">Documentation we cannot host</h2>

<p>Plenty of good arc42 documentation cannot be republished here — the licence
does not allow it, or it belongs on the site it already lives on. We link to it
from <a href="{{ '/elsewhere/' | relative_url }}">Elsewhere</a> instead.</p>

<p>Be clear about what that page is: a reading list, not a second shelf of
examples. Nothing on it has been read end to end by us, and it is deliberately
not laid out as tiles, because a tile on this site means somebody audited all
twelve sections.</p>

<h3>How</h3>

<p>Add one entry to <code>_data/elsewhere.yml</code> and open a pull request.
Nothing else changes — there is no page to edit and no navigation to update.</p>

<pre><code>- title:       Name of the documentation
  url:         https://example.org/arch/
  author:      Who wrote it
  description: One neutral sentence — what the system is.
  added:       2026-08
  language:    German          # omit when it is English
  year:        2019            # if knowable
</code></pre>

<p><strong>Leave out the <code>note</code> field.</strong> That one sentence is
our editorial voice — what is worth looking at, or what is thin — and we write
it ourselves after looking at your link. Notes written by the people who own the
documentation turn into blurbs, and a reading list of blurbs helps nobody
choose.</p>

<p>Keep <code>description</code> factual and free of praise: what the system
does, for whom, at roughly what size. One sentence.</p>

</div>
</div>

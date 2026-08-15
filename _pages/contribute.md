---
layout: default
title: Contribute
permalink: /contribute/
---
<div class="ex-shell ex-shell--prose">
<div class="ex-prose">

<h1>Contribute</h1>

<p>You can send us a documentation to publish here, or a link to one. 


<table>
  <thead>
    <tr><th>What you have</th><th>Where it goes</th></tr>
  </thead>
  <tbody>
    <tr>
      <td>Complete, and republishable here</td>
      <td>An example directory , the rest of this page</td>
    </tr>
    <tr>
      <td>Complete, but not republishable</td>
      <td><a href="#documentation-we-cannot-host">A link under <em>In the Wild</em></a></td>
    </tr>
    <tr>
      <td>A fragment of a single section</td>
      <td><a href="https://docs.arc42.org">docs.arc42.org</a></td>
    </tr>
  </tbody>
</table>

<h2>Contribute an example</h2>

<p>An example is one directory. Adding one is simple:
    no navigation file to edit, no index to update, no configuration to touch.</p>

<h3>What we are looking for</h3>

<ul>
  <li>A <strong>(fairly) complete</strong> arc42 documentation: most of the sections used,
      even where a section only says "not documented in the original". </li>
  <li>A <strong>real</strong> system. Anonymised is fine. </li>
  <li>Clear <strong>provenance</strong>: who wrote it, under what licence, and permission to republish it here. 
      Without that information, we cannot merge your pull request!</li>
</ul>

<h3>How</h3>

<ol>
  <li>Fork <a href="https://github.com/arc42/examples.arc42.org-site">the repository</a>.</li>
  <li><code>make new-system SLUG=your-system</code>: this copies
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
not synchronised with their originals, so there is nothing to round-trip. 
That is why the site needs no conversion step at build time and runs on plain GitHub Pages.</p>

<h3>House rules for the writing</h3>

<ul>
  <li>Keep the arc42 section titles. Readers navigate by them.</li>
  <li>Say when something is missing rather than deleting the section. An
      honest gap is useful to someone comparing examples.</li>
</ul>

<h2 id="documentation-we-cannot-host">Documentation we cannot host</h2>

<p>Plenty of good arc42 documentation cannot be republished here: 
    Their licence does not allow it, or it belongs on the site it already lives on. 
We link to it from <a href="{{ '/in-the-wild/' | relative_url }}">In the Wild</a> instead.</p>

<p>That page is a reading list!
    Nothing on it has been read end to end by us. </p>

<h3>How</h3>

<p>Add one entry to <code>_data/in-the-wild.yml</code> and open a pull request.
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
our editorial voice: What is worth looking at. 
We write it ourselves after looking at your link.</p>

<p>Keep <code>description</code> factual and free of praise: what the system
does, for whom, at roughly what size. One sentence.</p>

</div>
</div>

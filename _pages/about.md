---
layout: default
title: About
permalink: /about/
---
<div class="ex-shell ex-shell--prose">
<div class="ex-prose">
<h1>About this site</h1>

<p><strong>examples.arc42.org</strong> collects complete architecture
documentations of real systems, each written along the arc42 template's twelve
sections.</p>

<h2>Why a separate site</h2>

<p><a href="https://docs.arc42.org">docs.arc42.org</a> explains what belongs in
each arc42 section and illustrates it with short, section-sized snippets. That
is a different job from showing a whole documentation end to end: a fragment
teaches you what section 5 is for, and a complete example shows you what it
feels like when all twelve sections describe the same system.</p>

<p>The two sites overlap deliberately. A snippet may appear both here, inside
its full documentation, and there, as an illustration. Neither site is
generated from the other — the same arrangement arc42.org and arc42.de already
use.</p>

<h2>These are snapshots</h2>

<p>The systems documented here are not maintained in step with their originals.
An example is a photograph of an architecture at a moment, kept for what it
teaches, and every overview page records who wrote it, under which licence, and
where the original lives.</p>

<h2>Review Comments</h2>

<p>Some examples carry <strong>arc42 review notes</strong>: remarks by the
arc42 maintainers, written the way we would comment in an
architecture-documentation review — saying what a documentation does well,
and what we would do differently. A note is an amber-marked card pinned into
the text at the passage it discusses, signed with the reviewer's name. The
overview page of a reviewed system announces the notes with a disclaimer and
lists every finding — see
<a href="/systems/htmlsc/">HtmlSanityCheck</a> for a live one. The rules are
strict and recorded in
<a href="https://github.com/arc42/meta.arc42.org/blob/main/adr/0009-review-notes-on-hosted-content.md">ADR-0009</a>:
the original content is never altered, every note is signed, and every note
is our subjective opinion, not the author's words.</p>

<p>Adding a note is a maintainer's act, in three steps:</p>

<ol>
  <li>
    <p><strong>Write the finding</strong> in the system's review report,
    <code>_data/reviews/&lt;slug&gt;.yml</code> — one file holds the whole
    review of one system, one entry per note:</p>
<pre><code>- id: quality-goal-priorities   # stable slug, becomes the note's anchor
  section: 1                    # the arc42 section the note appears in
  title: Priority inflation in the quality goals
  author: Gernot Starke
  body: |
    The remark, in markdown. Multiple paragraphs are fine.</code></pre>
  </li>
  <li>
    <p><strong>Drop the marker</strong> in the section file, directly after
    the passage the note discusses — the only line a review ever adds to a
    content file:</p>
<pre><code>{% raw %}{% include review-note.html id="quality-goal-priorities" %}{% endraw %}</code></pre>
  </li>
  <li>
    <p><strong>Run <code>make check</code>.</strong> It verifies that every
    marker has exactly one report entry and vice versa, and that every note
    is complete and signed. The disclaimer and the findings list on the
    overview appear automatically once the report exists — there is nothing
    else to edit, and no flag to keep in step.</p>
  </li>
</ol>

<p>The same workflow is written for repository work in
<a href="https://github.com/arc42/examples.arc42.org-site/blob/main/CONTRIBUTING.md">CONTRIBUTING.md</a>.</p>

<h3>Or let an agent do the mechanics</h3>

<p>The repository ships a <strong><code>review-note</code> skill</strong> for
<a href="https://claude.com/claude-code">Claude Code</a>, in
<code>.claude/skills/review-note/</code>. Open a session in the repository
and say what you want in plain language —</p>

<blockquote><p>add a review note on biking's deployment view, section 7:
the single-artifact deployment is exemplary, but the diagram omits the
MQTT broker</p></blockquote>

<p>— or invoke it directly as <code>/review-note</code>. The skill loads the
rules of this page into the session: the agent writes the report entry,
places the marker at the passage, runs <code>make check</code>, and shows
you the result. It also carries the judgement the check script cannot
enforce — note prose belongs in the report file and never in the content,
every note is signed with a real reviewer's name (yours: the agent drafts,
you review the wording before it is committed), and the notes' visual
design is settled and out of scope. Agents earn no exemption from the
check; they just stop you from forgetting a step.</p>

<h2>The herbarium</h2>

<p>The band on the home page shows a row of fourteen botanical specimens, no
two alike, drawn in one hand. That picture is the site's argument. A herbarium
collects wildly different plants and mounts every one in the same format, on
the same paper, with the same kind of label. This collection does the same
with architectures: systems from different domains, at different scales,
built by different teams, all documented along the same twelve arc42
sections.</p>

<figure>
  <img src="/assets/images/hero/herbarium-band.webp"
       alt="Fourteen botanical specimens in different shapes and colours, drawn in one flat style on a dark warm ground"
       width="2560" height="465" loading="lazy">
  <figcaption>The herbarium frieze from the home page: fourteen specimens,
  one format.</figcaption>
</figure>

<p>The picture states our intention twice, in shape and in colour. No two
specimens share a form, and none of them was asked to match the site's
palette: each keeps its own colours, the way every system in this collection
keeps its own domain, scale and technology. Diversity is not an accident of
what happened to get collected, it is what we collect for. An embedded
measuring unit, a mainframe migration and a public open data service have
little in common except the twelve sections that describe them, and that is
the point: the format stays fixed so that the variety can show. Like a real
herbarium, the collection is open. Anyone can contribute a new specimen, and
every addition makes it more varied, not more uniform.</p>
</div>
</div>

/* ===========================================================================
 * Site search — lunr.js, incremental, no build step.
 *
 * One engine serves two surfaces: the masthead combobox (suggestions while
 * typing) and /search/ (every hit, with excerpts). They share an index so a
 * suggestion and a result can never disagree about what matches.
 *
 * DIVERGENCE FROM arc42.de, DELIBERATE. There the masthead runs a separate
 * title-only scorer and lunr is reserved for /search/, because its stemmer
 * files "Dokumentation" under "dokument" and a half-typed word then misses
 * its own page. That reasoning is sound and the fix is applied here instead
 * of the workaround: the stemmer is removed and every term also goes in as a
 * trailing wildcard, which is what makes prefix-as-you-type work at all. The
 * reason not to copy arc42.de's split is content, not mechanism — its page
 * titles are meaningful on their own, and "3. Context and Scope" is the same
 * title in every example here. A title-only index would answer almost nothing
 * a reader of this site actually asks.
 *
 * KEYBOARD (identical to arc42.de, so the two sites do not teach different
 * habits):
 *   Cmd/Ctrl-K            focus the field
 *   Enter                 open the highlighted suggestion (the first by default)
 *   Cmd/Ctrl/Shift-Enter  skip the panel, go to /search/?q=…
 *   Escape                close the panel, then clear the field
 *   Up/Down               move the highlight
 *
 * WITHOUT JAVASCRIPT the panel stays `hidden`, aria-expanded stays "false",
 * and the masthead form submits as an ordinary GET to /search/?q=… — which
 * reaches a page that then says it needs JavaScript. That is worse than a
 * working search and better than a dead box, and /search/ says so plainly.
 *
 * Requires window.lunr (assets/lib/lunr/lunr.min.js, plain lunr 2.3.9 — the
 * same file docs.arc42.org and arc42.de ship, byte for byte).
 * =========================================================================== */
(function () {
  "use strict";

  var DEBOUNCE_MS = 120;
  var PANEL_MAX = 8;      // suggestions in the masthead panel
  var EXCERPT_WORDS = 34;
  var EXCERPT_LEAD = 8;

  // lunr's tokenizer splits on whitespace and hyphens. Query terms are cut the
  // same way or "cross-cutting" typed into the box would never line up with
  // the two tokens the index holds.
  var SEPARATOR = /[\s\-]+/;
  var EDGES = /^[^0-9a-zÀ-ɏ]+|[^0-9a-zÀ-ɏ]+$/g;

  // Diacritic folding, applied SYMMETRICALLY to the index pipeline and to the
  // query. Folding one side only is worse than folding neither: the folded
  // half stops meeting the unfolded half. These documents are English but
  // carry German names and «guillemets», so this is not hypothetical.
  function fold(value) {
    return (value || "").toLocaleLowerCase().normalize("NFD").replace(/[̀-ͯ]/g, "");
  }

  function normalize(word) { return fold(word).replace(EDGES, ""); }

  function tokenize(value) {
    return fold(value).split(SEPARATOR)
      .map(function (part) { return part.replace(EDGES, ""); })
      .filter(Boolean);
  }

  function escapeHtml(value) {
    return String(value)
      .replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;")
      .replace(/"/g, "&quot;").replace(/'/g, "&#39;");
  }

  // ---- the index ----------------------------------------------------------

  var Engine = {
    index: null,
    byUrl: {},
    loading: null,

    trimEdges: function (token) {
      return token.update(function (value) { return fold(value).replace(EDGES, ""); });
    },

    build: function (docs) {
      lunr.Pipeline.registerFunction(Engine.trimEdges, "arc42-trim-edges");
      return lunr(function () {
        // No stemmer, on both halves. It would file "documentation" under
        // "document", so "documentati*" — what a reader has typed halfway
        // through the word — would miss its own page.
        this.pipeline.remove(lunr.stemmer);
        this.searchPipeline.remove(lunr.stemmer);
        this.pipeline.remove(lunr.trimmer);

        // Stopwords stay INDEXED. The query half runs usePipeline:false, so a
        // dropped stopword would arrive as a real term the index cannot
        // satisfy, and the AND filter below would then return nothing for a
        // pasted phrase. Forty documents make the extra terms free.
        this.pipeline.remove(lunr.stopWordFilter);
        this.pipeline.add(Engine.trimEdges);

        this.ref("url");
        this.field("title", { boost: 12 });
        this.field("system", { boost: 6 });
        this.field("content");

        docs.forEach(function (doc) { this.add(doc); }, this);
      });
    },

    // Fetched on demand — on first focus, first keypress or Cmd-K — never on
    // page load. Every page would otherwise pay for a search most readers
    // never open.
    load: function (url) {
      if (Engine.loading) { return Engine.loading; }
      Engine.loading = window.fetch(url, { credentials: "same-origin" })
        .then(function (response) {
          if (!response.ok) { throw new Error("HTTP " + response.status); }
          return response.json();
        })
        .then(function (data) {
          var docs = (data || []).filter(function (d) { return d && d.title && d.url; });
          docs.forEach(function (doc) { Engine.byUrl[doc.url] = doc; });
          Engine.index = Engine.build(docs);
          return Engine.index;
        });
      return Engine.loading;
    },

    search: function (raw) {
      var tokens = tokenize(raw);
      if (!Engine.index || !tokens.length) { return { tokens: tokens, matches: [] }; }

      var matches;
      try {
        matches = Engine.index.query(function (query) {
          tokens.forEach(function (token) {
            // Two clauses per token: the exact term, weighted up so a finished
            // word beats a coincidental prefix, and the trailing wildcard,
            // which keeps results flowing mid-word.
            query.term(token, { usePipeline: false, boost: 10 });
            query.term(token, {
              usePipeline: false, boost: 1,
              wildcard: lunr.Query.wildcard.TRAILING
            });
          });
        });
      } catch (error) {
        // lunr throws on malformed clauses (a lone "*", for instance).
        return { tokens: tokens, matches: [] };
      }

      // Multi-word queries are AND, not OR. lunr's default clause presence is
      // OPTIONAL, so "gradle plugin" would score every document carrying
      // either word. Intersecting over matchData is cheaper than a second
      // query pass; a wildcard clause records the EXPANDED term, hence the
      // prefix test rather than equality.
      if (tokens.length > 1) {
        matches = matches.filter(function (match) {
          var matched = Object.keys(match.matchData.metadata);
          return tokens.every(function (token) {
            return matched.some(function (term) { return term.indexOf(token) === 0; });
          });
        });
      }
      return { tokens: tokens, matches: matches };
    }
  };

  // A word counts as a hit when a query token is a prefix of it — the same
  // relation the wildcard clause uses, so what gets marked is what earned the
  // match. Hyphenated compounds are checked per part, mirroring the tokenizer.
  function isHit(word, tokens) {
    var parts = normalize(word).split("-");
    return tokens.some(function (token) {
      return parts.some(function (part) { return part.indexOf(token) === 0; });
    });
  }

  function excerpt(content, tokens) {
    var words = String(content || "").split(/\s+/).filter(Boolean);
    if (!words.length) { return ""; }

    var hit = -1;
    for (var i = 0; i < words.length; i++) {
      if (isHit(words[i], tokens)) { hit = i; break; }
    }
    var start = hit === -1 ? 0 : Math.max(0, hit - EXCERPT_LEAD);
    var end = start + EXCERPT_WORDS;
    var body = words.slice(start, end).map(function (word) {
      var safe = escapeHtml(word);
      return isHit(word, tokens) ? "<mark>" + safe + "</mark>" : safe;
    }).join(" ");
    return (start > 0 ? "… " : "") + body + (end < words.length ? " …" : "");
  }

  // "MaMa-CRM · section 9". The row's own title is the section title, which is
  // the same string in every example — "Architecture Decisions" alone cannot
  // tell a reader which system they just found. The bare number needs the word
  // in front of it or it reads as a count.
  function whereLine(doc) {
    if (!doc.system) { return ""; }
    return doc.system + (doc.section ? " · section " + doc.section : "");
  }

  // ---- the masthead combobox ---------------------------------------------

  function initCombobox() {
    var form = document.querySelector("[data-arc42-search]");
    if (!form) { return; }

    var input = form.querySelector("input[type=search]");
    var panel = form.querySelector("[data-arc42-search-panel]");
    var status = form.querySelector("[data-arc42-search-status]");
    var hint = form.querySelector("[data-arc42-search-hint]");
    var hintDesc = form.querySelector("[data-arc42-search-hint-desc]");
    var indexUrl = form.getAttribute("data-arc42-search");
    var resultsUrl = form.getAttribute("action");
    if (!input || !panel) { return; }

    var apple = /Mac|iPhone|iPad|iPod/.test(navigator.platform || "");
    if (hint) { hint.textContent = apple ? "⌘K" : "Ctrl K"; }
    if (hintDesc) {
      hintDesc.textContent = (apple ? "Command-K" : "Control-K") +
        " focuses this search. Enter opens the highlighted suggestion; " +
        (apple ? "Command-Enter" : "Control-Enter") + " opens all results.";
    }
    // Same chord the badge above already advertises, echoed in the panel's
    // own footer (below) — ported from arc42.de's masthead autocomplete.
    var chordLabel = apple ? "⌘⏎" : "Ctrl⏎";

    var rows = [];
    var active = -1;
    var timer = null;

    function close() {
      panel.hidden = true;
      panel.innerHTML = "";
      input.setAttribute("aria-expanded", "false");
      input.removeAttribute("aria-activedescendant");
      rows = [];
      active = -1;
    }

    function highlight(next) {
      if (!rows.length) { return; }
      if (active >= 0) { rows[active].setAttribute("aria-selected", "false"); }
      active = (next + rows.length) % rows.length;
      rows[active].setAttribute("aria-selected", "true");
      input.setAttribute("aria-activedescendant", rows[active].id);
      if (rows[active].scrollIntoView) {
        rows[active].scrollIntoView({ block: "nearest" });
      }
    }

    function render(result) {
      var shown = result.matches.slice(0, PANEL_MAX);
      if (!shown.length) {
        panel.innerHTML = '<p class="arc42-search__empty">No match.</p>';
        panel.hidden = false;
        input.setAttribute("aria-expanded", "true");
        rows = [];
        active = -1;
        if (status) { status.textContent = "No results."; }
        return;
      }

      var rowsHtml = shown.map(function (match, i) {
        var doc = Engine.byUrl[match.ref];
        var where = whereLine(doc);
        return '<a class="arc42-search__row" role="option" aria-selected="false"' +
          ' id="arc42-search-row-' + i + '" href="' + escapeHtml(doc.url) + '">' +
          '<span class="arc42-search__row-title">' + escapeHtml(doc.title) + "</span>" +
          (where ? '<span class="arc42-search__row-where">' + escapeHtml(where) + "</span>" : "") +
          "</a>";
      }).join("");

      // Rows scroll; the footer below is outside .arc42-search__scroll so it
      // stays put. Decorative (aria-hidden) — the aria-live status span below
      // carries the counts for assistive tech.
      panel.innerHTML = '<div class="arc42-search__scroll">' + rowsHtml + "</div>" +
        '<div class="arc42-search__footer" aria-hidden="true">' +
        '<span class="arc42-search__footer-hint">' +
        "<kbd>↵</kbd> open" +
        " · <kbd>" + escapeHtml(chordLabel) + "</kbd> all results" +
        " · <kbd>↑↓</kbd> navigate" +
        " · <kbd>esc</kbd> close" +
        "</span></div>";

      panel.hidden = false;
      input.setAttribute("aria-expanded", "true");
      rows = Array.prototype.slice.call(panel.querySelectorAll("[role=option]"));
      active = -1;
      highlight(0);   // Enter has something to open from the first keystroke.

      if (status) {
        status.textContent = result.matches.length + " result" +
          (result.matches.length === 1 ? "" : "s") + ", " + shown.length + " shown.";
      }
    }

    function run() {
      var raw = input.value.trim();
      if (!raw) { close(); if (status) { status.textContent = ""; } return; }
      if (!Engine.index) {
        Engine.load(indexUrl).then(run).catch(function () {
          panel.innerHTML = '<p class="arc42-search__empty">Search is unavailable.</p>';
          panel.hidden = false;
        });
        return;
      }
      render(Engine.search(raw));
    }

    function allResults() {
      window.location.href = resultsUrl + "?q=" + encodeURIComponent(input.value.trim());
    }

    // Warm the index on intent, not on load.
    input.addEventListener("focus", function () { Engine.load(indexUrl).catch(function () {}); });

    input.addEventListener("input", function () {
      window.clearTimeout(timer);
      timer = window.setTimeout(run, DEBOUNCE_MS);
    });

    input.addEventListener("keydown", function (e) {
      if (e.key === "ArrowDown") { e.preventDefault(); highlight(active + 1); return; }
      if (e.key === "ArrowUp") { e.preventDefault(); highlight(active - 1); return; }

      if (e.key === "Escape") {
        // First Escape closes the panel, a second clears the field. Clearing
        // on the first press throws away a query the reader may still want.
        //
        // preventDefault is load-bearing: an <input type="search"> is cleared
        // by the browser itself on Escape, so without it the first press did
        // both — panel shut AND query gone — and the two-step was invisible.
        if (!panel.hidden) {
          e.preventDefault();
          close();
        } else {
          input.value = "";
        }
        return;
      }

      if (e.key === "Enter") {
        if (e.metaKey || e.ctrlKey || e.shiftKey) {
          e.preventDefault();
          allResults();
          return;
        }
        if (active >= 0 && rows[active]) {
          e.preventDefault();
          window.location.href = rows[active].getAttribute("href");
          return;
        }
        // Nothing highlighted: let the form submit to /search/?q=… on its own.
      }
    });

    // A click outside closes the panel. Not a blur handler: blur fires before
    // the click that follows it lands, so choosing a suggestion with the
    // mouse would close the panel out from under the pointer.
    document.addEventListener("click", function (e) {
      if (!form.contains(e.target)) { close(); }
    });

    document.addEventListener("keydown", function (e) {
      if ((e.metaKey || e.ctrlKey) && (e.key === "k" || e.key === "K")) {
        e.preventDefault();
        input.focus();
        input.select();
      }
    });
  }

  // ---- /search/ -----------------------------------------------------------

  function initResultsPage() {
    var page = document.querySelector("[data-search-page]");
    if (!page) { return; }

    var input = document.getElementById("search-input");
    var countLine = document.getElementById("search-count");
    var results = document.getElementById("search-results");
    var indexUrl = page.getAttribute("data-search-index");
    if (!input || !countLine || !results) { return; }

    var timer = null;

    function rememberQuery(value) {
      if (!window.history || !window.history.replaceState) { return; }
      var address = new URL(window.location.href);
      if (value) { address.searchParams.set("q", value); }
      else { address.searchParams.delete("q"); }
      try {
        window.history.replaceState({}, "", address.pathname + address.search + address.hash);
      } catch (error) {
        // Safari rate-limits replaceState and throws once a fast typist trips
        // the limit. A shareable URL is a nicety; letting this escape would
        // abort run() and leave the field dead until reload, which is not.
      }
    }

    function run() {
      var raw = input.value.trim();
      rememberQuery(raw);

      if (!raw) { results.innerHTML = ""; countLine.textContent = ""; return; }
      if (!Engine.index) { countLine.textContent = "Loading the search index…"; return; }

      var result = Engine.search(raw);
      if (!result.tokens.length) {
        // Punctuation only. Nothing searchable survives folding, but the
        // reader HAS typed something — answer them rather than going blank as
        // if the box were empty.
        results.innerHTML = "";
        countLine.textContent = "No results.";
        return;
      }

      results.innerHTML = result.matches.map(function (match) {
        var doc = Engine.byUrl[match.ref];
        if (!doc) { return ""; }
        var where = whereLine(doc);
        // A record may carry no body at all (`search_body: false`, for a page
        // whose entries are indexed one by one). An empty <p> would still take
        // its margin, so the hit would sit in a column of ragged gaps.
        var body = excerpt(doc.content, result.tokens);
        return "<li>" +
          (where ? '<p class="ex-hit__where">' + escapeHtml(where) + "</p>" : "") +
          '<h2 class="ex-hit__title"><a href="' + escapeHtml(doc.url) + '">' +
          escapeHtml(doc.title) + "</a></h2>" +
          (body ? '<p class="ex-hit__excerpt">' + body + "</p>" : "") +
          "</li>";
      }).join("");

      // Every surviving hit is listed: this page IS the all-results page.
      countLine.textContent = result.matches.length
        ? result.matches.length + " result" + (result.matches.length === 1 ? "" : "s")
        : "No results.";
    }

    input.addEventListener("input", function () {
      window.clearTimeout(timer);
      timer = window.setTimeout(run, DEBOUNCE_MS);
    });

    // Arriving from the masthead lands here as /search/?q=… — pick the term up
    // and run it, or the reader types the same thing twice.
    var requested = new URLSearchParams(window.location.search).get("q");
    if (requested) { input.value = requested; countLine.textContent = "Loading the search index…"; }
    input.focus();

    Engine.load(indexUrl).then(run).catch(function (error) {
      countLine.textContent = "The search index could not be loaded.";
      if (window.console && window.console.error) {
        window.console.error("arc42 search: " + indexUrl, error);
      }
    });
  }

  function init() {
    if (!window.lunr) { return; }
    initCombobox();
    initResultsPage();
  }

  // Both script tags are deferred and run in order after parsing, so the DOM
  // is up; the guard only covers the page being loaded some other way.
  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", init);
  } else {
    init();
  }
}());

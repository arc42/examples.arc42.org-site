/* ===========================================================================
 * Dashboard filter — progressive enhancement, nothing more.
 *
 * Every tile is server-rendered and visible before this file runs. If the JS
 * fails, is blocked, or never arrives, the dashboard still lists every
 * example. The filter UI is therefore rendered `hidden` in the markup and
 * revealed here — a control that cannot work must not be on screen.
 *
 * Matching is a plain substring test against `data-haystack`, which the tile
 * template fills with title, tagline, domain, goal, decisions and
 * technologies. With a ceiling of ~15 examples there is no index to build and
 * no debounce to tune: the whole list is filtered in well under a frame.
 * =========================================================================== */
(function () {
  'use strict';

  var root  = document.querySelector('[data-ex-filter]');
  var grid  = document.querySelector('[data-ex-grid]');
  var empty = document.querySelector('[data-ex-empty]');
  if (!root || !grid) return;

  var input = root.querySelector('.ex-filter__input');
  var count = root.querySelector('.ex-filter__count');
  var items = Array.prototype.slice.call(grid.querySelectorAll('[data-ex-item]'));
  var total = items.length;

  // Nothing to filter — one tile filters to either one tile or none.
  if (total < 2) return;

  root.hidden = false;

  function apply(query) {
    var q = query.trim().toLowerCase();
    var shown = 0;

    items.forEach(function (item) {
      var hay = (item.getAttribute('data-haystack') || '').toLowerCase();
      var match = q === '' || hay.indexOf(q) !== -1;
      item.hidden = !match;
      if (match) shown++;
    });

    if (empty) empty.hidden = shown !== 0;

    // Announced via aria-live. Silent when nothing is filtered, so a screen
    // reader is not told "5 of 5" the moment the page settles.
    count.textContent = q === ''
      ? ''
      : shown + ' of ' + total + ' example' + (total === 1 ? '' : 's');
  }

  input.addEventListener('input', function () { apply(input.value); });

  var clear = document.querySelector('[data-ex-clear]');
  if (clear) {
    clear.addEventListener('click', function () {
      input.value = '';
      apply('');
      input.focus();
    });
  }

  // Escape clears, the convention for a search field.
  input.addEventListener('keydown', function (e) {
    if (e.key === 'Escape' && input.value !== '') {
      e.preventDefault();
      input.value = '';
      apply('');
    }
  });
})();

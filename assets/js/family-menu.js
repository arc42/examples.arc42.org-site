/* ===========================================================================
 * The "42" family menu in the masthead (_includes/family-menu.html).
 *
 * The family's behaviour, ported from docs.arc42.org-site/assets/js/site.js
 * ("Family menu"); meta.arc42.org, wiki/concepts/family-menu.md. A file of its
 * own because this site has no general script to put it in.
 *
 * Contract with the include: a .family-toggle button whose aria-controls names
 * the panel; the panel is closed while it carries `hidden`. aria-expanded and
 * the panel's state are flipped together and never disagree, and `hidden`
 * stays the real closed state so the links leave the tab order.
 *
 * Closes on a click outside, on Escape (focus goes back to the button), and
 * when keyboard focus leaves the menu. Opened by keyboard, focus moves to the
 * first link; opened by mouse it stays put (e.detail is 0 for a keyboard
 * "click").
 *
 * Without this file the button does nothing. The footer no longer repeats the
 * three links (removed 2026-11-05), so the sibling sites need JavaScript.
 * =========================================================================== */
(function () {
  'use strict';

  var btn = document.querySelector('.family-toggle');
  if (!btn) return;

  var panel = document.getElementById(btn.getAttribute('aria-controls') || 'family-panel');
  if (!panel) return;

  var wrap = btn.parentNode;

  function setOpen(open) {
    panel.hidden = !open;
    btn.setAttribute('aria-expanded', open ? 'true' : 'false');
  }

  btn.addEventListener('click', function (e) {
    var open = panel.hidden;
    setOpen(open);
    if (open && e.detail === 0) {
      var first = panel.querySelector('a');
      if (first) first.focus();
    }
  });

  document.addEventListener('click', function (e) {
    if (!panel.hidden && !wrap.contains(e.target)) setOpen(false);
  });

  wrap.addEventListener('keydown', function (e) {
    if (e.key === 'Escape' && !panel.hidden) {
      setOpen(false);
      btn.focus();
    }
  });

  wrap.addEventListener('focusout', function (e) {
    if (!panel.hidden && e.relatedTarget && !wrap.contains(e.relatedTarget)) {
      setOpen(false);
    }
  });
})();

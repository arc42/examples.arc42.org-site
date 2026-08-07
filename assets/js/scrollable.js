/* ===========================================================================
 * Make horizontally scrolling blocks reachable by keyboard.
 *
 * Wide tables and code blocks scroll inside their own container rather than
 * making the page scroll sideways (_sass/_content.scss). A mouse or a finger
 * can scroll them; a keyboard cannot, because a plain <pre> or <table> is not
 * focusable — so on a narrow screen the truncated half of a code line is
 * simply unreachable. That is WCAG 2.1.1.
 *
 * tabindex is applied only where a block ACTUALLY overflows, and re-evaluated
 * on resize: a container that fits needs no stop, and adding one to every
 * table would pad the tab order with nothing to do.
 *
 * Progressive enhancement, like the dashboard filter — without this file the
 * content is all still present and the page still reads.
 * =========================================================================== */
(function () {
  'use strict';

  var blocks = Array.prototype.slice.call(
    document.querySelectorAll('.ex-prose pre, .ex-prose table, .ex-tablewrap')
  );
  if (!blocks.length) return;

  function sync() {
    blocks.forEach(function (el) {
      if (el.scrollWidth > el.clientWidth) {
        if (el.tabIndex !== 0) {
          el.tabIndex = 0;
          // A focus stop with no name announces as "group" and tells the
          // reader nothing about why they landed there.
          if (!el.hasAttribute('aria-label')) {
            el.setAttribute(
              'aria-label',
              el.tagName === 'PRE' ? 'Code block, scrolls sideways'
                                   : 'Table, scrolls sideways'
            );
          }
        }
      } else if (el.tabIndex === 0) {
        el.removeAttribute('tabindex');
        el.removeAttribute('aria-label');
      }
    });
  }

  sync();

  var pending;
  window.addEventListener('resize', function () {
    clearTimeout(pending);
    pending = setTimeout(sync, 150);
  });
})();

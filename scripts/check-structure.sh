#!/bin/sh
# ============================================================================
# The shape of an example on disk, as opposed to the fields inside its front
# matter (scripts/check-system-fields.sh does those).
#
# WHY THIS IS A SCRIPT. It was thirty lines of shell inlined in the `structure`
# job of .github/workflows/checks.yml and it existed NOWHERE else, so `make
# check` could not run it and no local command could catch what it caught. On
# 2026-08-14 `upcoming: true` was taught to check-system-fields.sh, to
# _layouts/system.html and to _includes/system-tile.html, and missed the copy
# in the workflow, because the copy in the workflow is not somewhere anyone
# looks. main went red on the next push. Every other check on this repo is a
# script under scripts/ that `make check` runs; this is now one too.
#
# EVERY RULE HERE FAILS SILENTLY WITHOUT IT. That is the test for belonging in
# this file: not "is it wrong" but "would anything else notice". Jekyll builds
# a system with four section files, html-proofer passes it, and the page simply
# renders a short rail. Nothing is red and nothing is right.
#
#   1. index.md exists          without it there is no dashboard tile at all
#   2. permalink matches dir    the page builds at a path nothing links to
#   3. twelve sections, or none the rail and the stepper both go short
#   4. provenance keys present  THE PAGE REPUBLISHES SOMEONE ELSE'S WORK
#                               WITH NO ATTRIBUTION AND NO LICENCE
#   5. _originals not originals JEKYLL PUBLISHES EVERY SOURCE FILE IN IT
#
# Rules 4 and 5 are the reason this check is not optional and not advisory.
# This corpus is other people's documentation, hosted with permission and
# under their terms. Both failures are invisible on the built site and both
# publish material nobody agreed to publish.
#
# UPCOMING SYSTEMS OWE ZERO SECTIONS, NOT TWELVE. `upcoming: true` announces an
# example whose documentation is not written yet: the tile is quieted and
# stamped "Coming soon" and the page renders no section grid. The count is
# exact in both directions, because _layouts/system.html guards the grid on the
# section COUNT and not on the flag, so a system that grew section files while
# still carrying `upcoming:` would render a full grid under a "Coming soon"
# tile. Publishing means dropping the flag and adding twelve files in one
# commit, and rule 3 is what says so.
#
# Written in POSIX shell with no dependency beyond find and grep, matching
# scripts/check-system-fields.sh and scripts/check-wild-fields.sh.
#
# Exit codes: 0 every example is well formed, 1 at least one is not.
# ============================================================================
set -eu

DIR="${1:-_systems}"

if [ ! -d "$DIR" ]; then
  echo "check-structure: $DIR not found" >&2
  exit 1
fi

PROBLEMS=""
WARNINGS=""
COUNT=0
SKIPPED=0
UPCOMING=""

note() {
  # One report line, "<slug>|<what went wrong, and what to do about it>".
  PROBLEMS="${PROBLEMS}$1|$2
"
}

warn() {
  # Same shape, but it does not set the exit code. A warning is for something
  # that is not wrong YET: it would be wrong if committed as it stands.
  WARNINGS="${WARNINGS}$1|$2
"
}

# WORK IN PROGRESS IS NOT A BROKEN EXAMPLE, and this is the whole difference
# between running here and running in CI. CI checks out a clean tree and sees
# only what is committed; `make check` sees the working tree, including a
# half-imported example sitting under _systems/ with nothing but _originals/ in
# it while its licence is still being cleared. Failing on that would train a
# maintainer to ignore this check, which is the one outcome worth avoiding.
#
# The test is git's, not ours: a directory with NO TRACKED FILES has not been
# committed to anything, so nobody can be publishing it wrongly yet. It gets a
# warning and is skipped. The moment one file in it is tracked, every rule
# below applies in full.
#
# If git is unavailable or this is not a repository, `tracked` returns nothing
# and every directory is checked, which is the safe direction to fail.
tracked() {
  git -C "$(dirname "$1")" ls-files --error-unmatch "$(basename "$1")" 2>/dev/null | head -1
}

for dir in "$DIR"/*/; do
  slug=$(basename "$dir")

  # A leading underscore is Jekyll's own "do not publish", which is what
  # _TEMPLATE relies on. Skipping it here is the same rule, not a special case.
  case "$slug" in _*) continue ;; esac

  if git rev-parse --is-inside-work-tree >/dev/null 2>&1 \
     && [ -z "$(git ls-files -- "$dir" | head -1)" ]; then
    warn "$slug" "not tracked by git, so it is work in progress and nothing here is published yet. Skipped. It will be checked in full as soon as any file in it is committed."
    SKIPPED=$((SKIPPED + 1))
    continue
  fi

  COUNT=$((COUNT + 1))
  index="$dir/index.md"

  # ---- 1. index.md, and 2. its permalink ----------------------------------
  if [ ! -f "$index" ]; then
    note "$slug" "no index.md. That file IS the dashboard tile and the head of the section rail, so without it the example does not appear on the site at all."
    # Everything below reads index.md. Nothing more can be said about this one.
    continue
  fi

  if ! grep -q "^permalink:[[:space:]]*/systems/$slug/[[:space:]]*$" "$index"; then
    have=$(grep -m1 "^permalink:" "$index" | sed -E 's/^permalink:[[:space:]]*//' || true)
    note "$slug" "permalink is \"${have:-missing}\" but the directory is $slug/, so the page builds where nothing links to it. Set: permalink: /systems/$slug/"
  fi

  # ---- 3. twelve section files, or none for an upcoming system ------------
  if grep -q '^upcoming:[[:space:]]*true[[:space:]]*$' "$index"; then
    upcoming=1
    UPCOMING="$UPCOMING $slug"
  else
    upcoming=0
  fi

  n=$(find "$dir" -maxdepth 1 -name '[0-9][0-9]-*.md' | wc -l | tr -d ' ')

  if [ "$upcoming" -eq 1 ] && [ "$n" -ne 0 ]; then
    note "$slug" "$n section file(s), but \`upcoming: true\` is still set, so the page renders a full grid under a tile stamped \"Coming soon\". Publishing is one commit: drop \`upcoming:\` AND add all twelve."
  elif [ "$upcoming" -eq 0 ] && [ "$n" -ne 12 ]; then
    note "$slug" "$n section file(s), expected 12. A gap shortens the rail and breaks the stepper, and nothing else reports it. CONTRIBUTING asks for a file saying \"not documented in the original\" rather than a deleted one. If the documentation is not published yet, set \`upcoming: true\` instead."
  fi

  # ---- 4. provenance ------------------------------------------------------
  # Deliberately the loudest message in the file. These are other people's
  # documents and this is the failure that does harm rather than damage.
  for key in attribution licence source_url; do
    grep -q "^$key:" "$index" || \
      note "$slug" "index.md has no \`$key:\`. This example reproduces someone else's documentation; without it the page publishes their work with no way to trace it back to them."
  done

  # ---- 5. the load-bearing underscore -------------------------------------
  if [ -d "$dir/originals" ]; then
    note "$slug" "has originals/, and Jekyll publishes every file in it. Rename it to _originals/ — the underscore is what keeps the sources out of _site."
  fi
done

if [ "$COUNT" -eq 0 ] && [ "$SKIPPED" -eq 0 ]; then
  echo "check-structure: no systems found under $DIR" >&2
  exit 1
fi

# Warnings print whether or not anything failed, and BEFORE the errors, so the
# last thing on screen is the thing that has to be fixed.
if [ -n "$WARNINGS" ]; then
  printf '%s' "$WARNINGS" | sed -E 's/^([^|]*)\|(.*)$/  warning  \1:\n    \2/' >&2
  echo "" >&2
fi

if [ -n "$PROBLEMS" ]; then
  printf '%s' "$PROBLEMS" | sed -E 's/^([^|]*)\|(.*)$/  ERROR    \1:\n    \2/' >&2
  echo "" >&2
  echo "Each of these is invisible on the built site: Jekyll builds, html-proofer" >&2
  echo "passes, and the page is quietly wrong. See _systems/_TEMPLATE/ for the" >&2
  echo "shape an example is meant to have." >&2
  exit 1
fi

# Say what was EXEMPTED and why, or a maintainer reading a green line has no way
# to tell a system that owes twelve sections from one that owes none.
echo "check-structure: $COUNT systems, every one complete and self-contained."
[ -n "$UPCOMING" ] && \
  echo "                 upcoming, sections not yet expected:$UPCOMING"
[ "$SKIPPED" -gt 0 ] && \
  echo "                 $SKIPPED untracked, skipped as work in progress (see warnings above)"
exit 0

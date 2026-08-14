#!/bin/sh
# ============================================================================
# Review notes and the `reviewed:` flag must agree, in both directions.
#
# A system whose sections include review-note.html without `reviewed: true`
# in its index.md ships subjective commentary with no disclaimer — the
# overview paragraph that says whose voice the notes are is the whole reason
# the flag exists. A system flagged `reviewed: true` with no notes prints a
# disclaimer about notes that do not exist, which is the stale-flag variant
# of the same lie. Liquid guards both with an `if`, so neither mistake breaks
# the build or tells anybody: exactly the failure mode check-system-fields.sh
# exists for.
#
# Also held here: every note names its reviewer. review-note.html renders
# `author` unguarded and unsigned commentary is not a review.
#
# Plain grep over the section sources, no YAML library, matching the other
# scripts in this directory. Only the system's own section files are read —
# _originals/ (the as-is proof) and _todo/ are never candidates.
#
# Exit codes: 0 flags and notes agree everywhere, 1 somewhere they do not.
# ============================================================================
set -eu

DIR="${1:-_systems}"

if [ ! -d "$DIR" ]; then
  echo "check-review: $DIR not found" >&2
  exit 1
fi

PROBLEMS=""
COUNT=0
NOTES_TOTAL=0

for idx in "$DIR"/*/index.md; do
  sysdir=$(dirname "$idx")
  name=$(basename "$sysdir")
  [ "$name" = "_TEMPLATE" ] && continue
  COUNT=$((COUNT + 1))

  # The flag, read from the front matter block only (between the first two
  # `---` lines), the way the other checks read it.
  flag=$(awk '
    NR == 1 && /^---[[:space:]]*$/ { infm = 1; next }
    !infm { next }
    /^---[[:space:]]*$/ { exit }
    /^reviewed:[[:space:]]*true[[:space:]]*$/ { print "yes"; exit }
  ' "$idx")

  # Note usage across the system's own top-level .md files. index.md is a
  # legal host too — introductory prose can carry a note.
  notes=0
  unsigned=0
  for f in "$sysdir"/*.md; do
    [ -f "$f" ] || continue
    n=$(grep -c 'include review-note\.html' "$f") || true
    [ "$n" -eq 0 ] && continue
    notes=$((notes + n))
    u=$(grep 'include review-note\.html' "$f" | grep -cv 'author=') || true
    if [ "$u" -gt 0 ]; then
      unsigned=$((unsigned + u))
    fi
  done
  NOTES_TOTAL=$((NOTES_TOTAL + notes))

  if [ "$notes" -gt 0 ] && [ "$flag" != "yes" ]; then
    PROBLEMS="${PROBLEMS}  ${name}:
    carries ${notes} review note(s) but index.md does not set \`reviewed: true\`,
    so the overview renders no disclaimer saying whose voice they are
"
  fi
  if [ "$notes" -eq 0 ] && [ "$flag" = "yes" ]; then
    PROBLEMS="${PROBLEMS}  ${name}:
    index.md sets \`reviewed: true\` but no section includes review-note.html —
    the overview promises notes that do not exist
"
  fi
  if [ "$unsigned" -gt 0 ]; then
    PROBLEMS="${PROBLEMS}  ${name}:
    ${unsigned} review note include(s) without an author= — every note is signed
"
  fi
done

if [ "$COUNT" -eq 0 ]; then
  echo "check-review: no systems found under $DIR" >&2
  exit 1
fi

if [ -n "$PROBLEMS" ]; then
  printf '%s' "$PROBLEMS" >&2
  echo "" >&2
  echo "Review notes ({% include review-note.html %}) and the \`reviewed: true\`" >&2
  echo "flag in the system's index.md must agree: the flag renders the" >&2
  echo "once-per-system disclaimer that makes the notes' subjectivity explicit." >&2
  echo "See _systems/_TEMPLATE/index.md and _includes/review-note.html." >&2
  exit 1
fi

echo "check-review: $COUNT systems, $NOTES_TOTAL review note(s), every flag and every signature in place."

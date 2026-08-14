#!/bin/sh
# ============================================================================
# Review reports and their markers must agree, in both directions (ADR-0009).
#
# A system's review lives in _data/reviews/<system>.yml — the maintainers'
# voice, deliberately outside the author's directory — and each entry renders
# where a one-line marker sits in a section file:
#
#   {% include review-note.html id="<id>" %}
#
# The failure modes are all silent in Liquid, which is why this check exists:
# a marker whose id has no entry renders nothing (a re-import that keeps
# markers but loses the report, or a typo in the id); an entry with no marker
# is a written note that appears in the overview's findings list but nowhere
# in the text — a link to nothing; a duplicate id makes the anchor ambiguous;
# an entry missing title, author or section renders a half-empty card, and
# unsigned commentary is not a review. The overview's disclaimer derives from
# the report file itself, so there is no flag to go stale — an orphaned
# report (no matching system directory) is the one way that derivation can
# lie, and it is checked here too.
#
# Plain grep/awk over the sources, no YAML library, matching the other
# scripts in this directory. Only the system's own section files are read —
# _originals/ (the as-is proof) and _todo/ are never candidates.
#
# Exit codes: 0 reports and markers agree everywhere, 1 somewhere they do not.
# ============================================================================
set -eu

DIR="${1:-_systems}"
REVIEWS="${2:-_data/reviews}"

if [ ! -d "$DIR" ]; then
  echo "check-review: $DIR not found" >&2
  exit 1
fi

PROBLEMS=""
COUNT=0
NOTES_TOTAL=0

add_problem() {
  PROBLEMS="${PROBLEMS}  $1:
    $2
"
}

# Every review report must belong to a system that exists.
if [ -d "$REVIEWS" ]; then
  for r in "$REVIEWS"/*.yml; do
    [ -f "$r" ] || continue
    rname=$(basename "$r" .yml)
    if [ ! -d "$DIR/$rname" ]; then
      add_problem "$rname" "review report $r has no matching system directory — an orphan from a removed or renamed system"
    fi
  done
fi

for idx in "$DIR"/*/index.md; do
  sysdir=$(dirname "$idx")
  name=$(basename "$sysdir")
  [ "$name" = "_TEMPLATE" ] && continue
  COUNT=$((COUNT + 1))

  report="$REVIEWS/$name.yml"

  # Marker ids, in file order, from the system's own top-level .md files.
  marker_ids=$(grep -ho 'include review-note\.html[[:space:]]*id="[^"]*"' "$sysdir"/*.md 2>/dev/null \
    | sed 's/.*id="//; s/"$//') || true

  # A marker without an id renders nothing and matches nothing above.
  badmarkers=$(grep -h 'include review-note\.html' "$sysdir"/*.md 2>/dev/null | grep -cv 'id="') || true
  if [ "${badmarkers:-0}" -gt 0 ]; then
    add_problem "$name" "$badmarkers review-note marker(s) without an id=\"...\" — the note cannot resolve"
  fi

  # Entry ids and per-entry field completeness from the report.
  entry_ids=""
  if [ -f "$report" ]; then
    entry_ids=$(awk '/^-[[:space:]]+id:/ { sub(/^-[[:space:]]+id:[[:space:]]*/, ""); print }' "$report")
    field_problems=$(awk -v name="$name" '
      function flush() {
        if (id == "") return
        if (!has["section"]) print name "|entry \"" id "\" has no section: — the findings list cannot link it"
        if (!has["title"])   print name "|entry \"" id "\" has no title: — the finding needs its headline"
        if (!has["author"])  print name "|entry \"" id "\" has no author: — every note is signed (ADR-0009)"
        if (!has["body"])    print name "|entry \"" id "\" has no body: — a note with no remark"
        delete has
      }
      /^-[[:space:]]+id:/ { flush(); id = $0; sub(/^-[[:space:]]+id:[[:space:]]*/, "", id); next }
      /^[[:space:]]+section:/ { has["section"] = 1 }
      /^[[:space:]]+title:/   { has["title"] = 1 }
      /^[[:space:]]+author:/  { has["author"] = 1 }
      /^[[:space:]]+body:/    { has["body"] = 1 }
      END { flush() }
    ' "$report")
    if [ -n "$field_problems" ]; then
      PROBLEMS="${PROBLEMS}$(printf '%s' "$field_problems" | sed -E 's/^([^|]*)\|(.*)$/  \1:\n    \2/')
"
    fi
  fi

  # The bijection, both directions, plus duplicates on either side.
  for m in $marker_ids; do
    if ! printf '%s\n' "$entry_ids" | grep -qx "$m"; then
      add_problem "$name" "marker id=\"$m\" has no entry in $report — the note renders nothing"
    fi
  done
  for e in $entry_ids; do
    if ! printf '%s\n' "$marker_ids" | grep -qx "$e"; then
      add_problem "$name" "report entry \"$e\" has no marker in any section — the findings list would link to nothing"
    fi
  done
  for d in $(printf '%s\n' "$marker_ids" | sort | uniq -d); do
    add_problem "$name" "marker id=\"$d\" appears more than once — anchors must be unique"
  done
  for d in $(printf '%s\n' "$entry_ids" | sort | uniq -d); do
    add_problem "$name" "report entry \"$d\" appears more than once"
  done

  n=$(printf '%s\n' "$entry_ids" | grep -c . ) || true
  NOTES_TOTAL=$((NOTES_TOTAL + n))
done

if [ "$COUNT" -eq 0 ]; then
  echo "check-review: no systems found under $DIR" >&2
  exit 1
fi

if [ -n "$PROBLEMS" ]; then
  printf '%s' "$PROBLEMS" >&2
  echo "" >&2
  echo "A system's review notes live in _data/reviews/<system>.yml, one entry" >&2
  echo "per note, and each entry renders at exactly one marker:" >&2
  echo "  {% include review-note.html id=\"<id>\" %}" >&2
  echo "placed in the section file at the commented passage. See ADR-0009" >&2
  echo "(meta.arc42.org) and the field list in _data/reviews/htmlsc.yml." >&2
  exit 1
fi

echo "check-review: $COUNT systems, $NOTES_TOTAL review note(s), every marker and entry paired and every note signed."

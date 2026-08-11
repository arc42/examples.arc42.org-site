#!/bin/sh
# ============================================================================
# Two things about every entry in _data/in-the-wild.yml that the template
# cannot enforce and will not complain about.
#
# 1. `kind` MUST BE PRESENT AND FROM THE VOCABULARY BELOW. It is the one chip on
#    the entry, and the only reason a chip earns its pill here is that a reader
#    can compare it straight down the page. Two entries reading "Production
#    system" and "Real production system" cannot be compared, and Liquid renders
#    both without a murmur. A missing `kind` renders an empty pill.
#
# 2. THE COMMA TRAP IN `facets`. It is a YAML flow sequence, so a facet that
#    contains a comma is not a facet:
#
#      facets: [Sections 3, 5, 7, Markdown]
#
#    is four items, two of which read "5" and "7". The entry still renders,
#    still validates, still passes every other check — it just says something
#    nobody wrote. The schema invites exactly this string, because "Sections 3,
#    5, 7" is how a person writes that fact.
#
#    _includes/in-the-wild-entry.html then renders `limit: 5`, which is the
#    deliberate ceiling. It is silent, so the comma trap above *hides* the
#    damage it does: four items out of a mistyped line, and the real facet after
#    them dropped without a word.
#
# Parsed with awk rather than a YAML library so it has no dependency beyond a
# POSIX shell, matching scripts/check-wild-groups.sh.
#
# Exit codes: 0 every entry is well formed, 1 at least one is not.
# ============================================================================
set -eu

DATA="${1:-_data/in-the-wild.yml}"

if [ ! -f "$DATA" ]; then
  echo "check-wild-fields: $DATA not found" >&2
  exit 1
fi

# The closed vocabulary. Widening it is a decision about what this page tells a
# reader, not a typo fix: add the term here AND in the schema header of
# _data/in-the-wild.yml in the same commit.
KINDS="Production system
Invented subject
Student coursework"

# awk -v cannot carry a newline, so the vocabulary crosses as one pipe-joined
# string. $KINDS keeps its newlines for the error message at the bottom.
KINDS_FLAT=$(printf '%s' "$KINDS" | tr '\n' '|')

# One report line per problem, "<title>|<what>". The current title is tracked so
# a problem can be named by entry rather than by line number. Commented lines
# are skipped by the anchors: the file header's example entry is indented behind
# a `#`, so neither `^- title:` nor `^ +facets:` can match it.
PROBLEMS=$(awk -v kinds="$KINDS_FLAT" '
  function trim(s) { sub(/^[[:space:]]+/, "", s); sub(/[[:space:]]+$/, "", s); return s }

  function value(line,   v) {
    v = line
    sub(/^[[:space:]]+[a-z_]+:[[:space:]]*/, "", v)
    sub(/[[:space:]]+#.*$/, "", v)
    return trim(v)
  }

  function check(item,   v) {
    v = trim(item)
    if (v == "")
      print title "|empty facet: a trailing or doubled comma"
    else if (v ~ /^[0-9]+$/)
      print title "|facet \"" v "\" is a bare number: a comma split a facet in half"
    else if (v ~ /^[Ss]ections?[[:space:]]+[0-9]+$/)
      print title "|facet \"" v "\" belongs in `sections:`, not on the form line"
  }

  # Everything that can only be judged once the whole entry has been read.
  function flush() {
    if (title == "") return
    if (kind == "") print title "|no kind:. Every entry needs one, from the list below"
    else if (index(vocab, "|" kind "|") == 0) print title "|kind \"" kind "\" is not in the vocabulary"
    if (count > 5) print title "|" count " facets: the template renders five and drops the rest silently"
  }

  BEGIN { vocab = "|" kinds "|" }

  /^-[[:space:]]*title:/ {
    flush()
    sub(/^-[[:space:]]*title:[[:space:]]*/, "")
    title = trim($0); kind = ""; block = 0; count = 0
    next
  }

  /^[[:space:]]+kind:/ { kind = value($0); block = 0; next }

  # Flow style, the form the schema documents: facets: [a, b, c]
  /^[[:space:]]+facets:[[:space:]]*\[/ {
    line = $0
    sub(/^[[:space:]]+facets:[[:space:]]*\[/, "", line)
    if (line !~ /\]/) {
      # A flow sequence may legally wrap, and this parser reads one line. Rather
      # than check half a list and report it as clean, say so.
      print title "|facets: spans more than one line. Keep it on one, or teach this script to read it"
      next
    }
    sub(/\].*$/, "", line)
    count = split(line, items, ",")
    for (i = 1; i <= count; i++) check(items[i])
    next
  }

  # Block style. Legal YAML, renders identically, so the ceiling has to hold
  # here too or the check is only half a check.
  /^[[:space:]]+facets:[[:space:]]*$/ { block = 1; count = 0; next }
  block && /^[[:space:]]+-[[:space:]]/ {
    line = $0
    sub(/^[[:space:]]+-[[:space:]]*/, "", line)
    sub(/[[:space:]]+#.*$/, "", line)
    check(line); count++
    next
  }
  block && /^[[:space:]]+[a-z_]+:/ { block = 0 }

  END { flush() }
' "$DATA")

if [ -n "$PROBLEMS" ]; then
  echo "$PROBLEMS" | sed -E 's/^([^|]*)\|(.*)$/  \1:\n    \2/' >&2
  echo "" >&2
  echo "kind: is the entry's one chip and must be exactly one of:" >&2
  echo "$KINDS" | sed 's/^/  /' >&2
  echo "" >&2
  echo "facets: is one line of plain text about the FORM of the document, and a" >&2
  echo "YAML flow sequence, so every comma starts a new item. Write section" >&2
  echo "coverage in \`sections:\`, which is the rail row built for it, and keep" >&2
  echo "the list to five: the template renders five and says nothing about the" >&2
  echo "rest." >&2
  exit 1
fi

ENTRIES=$(grep -cE '^-[[:space:]]*title:' "$DATA" || true)
echo "check-wild-fields: $ENTRIES entries, every kind known and every facet list intact."

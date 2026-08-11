#!/bin/sh
# ============================================================================
# The `facets` list of every entry in _data/in-the-wild.yml must survive YAML
# and must fit in the template.
#
# THE COMMA TRAP. `facets` is written as a YAML flow sequence, so a facet that
# contains a comma is not a facet:
#
#   facets: [Sections 3, 5, 7, Markdown]
#
# is four items, two of which are the chips "5" and "7". The entry still
# renders, still validates, still passes every other check — it just says
# something nobody wrote. The schema invites exactly this string, because
# "Sections 3, 5, 7" is how a person writes that fact.
#
# THE TRUNCATION. _includes/in-the-wild-entry.html renders `limit: 5`, which is
# the deliberate ceiling (a sixth chip turns a triage aid into a spec sheet).
# It is silent, so the comma trap above *hides* the damage it does: four chips
# out of a mistyped line, and the real facet after them dropped without a word.
#
# Parsed with awk rather than a YAML library so it has no dependency beyond a
# POSIX shell, matching scripts/check-wild-groups.sh.
#
# Exit codes: 0 every facet list is intact, 1 at least one is not.
# ============================================================================
set -eu

DATA="${1:-_data/in-the-wild.yml}"

if [ ! -f "$DATA" ]; then
  echo "check-wild-facets: $DATA not found" >&2
  exit 1
fi

# One report line per problem, "<title>|<what>". The current title is tracked so
# a problem can be named by entry rather than by line number. Commented lines
# are skipped by the anchors: the file header's example entry is indented behind
# a `#`, so neither `^- title:` nor `^ +facets:` can match it.
PROBLEMS=$(awk '
  function trim(s) { sub(/^[[:space:]]+/, "", s); sub(/[[:space:]]+$/, "", s); return s }

  function check(item,   value) {
    value = trim(item)
    if (value == "")
      print title "|empty facet: a trailing or doubled comma"
    else if (value ~ /^[0-9]+$/)
      print title "|facet \"" value "\" is a bare number: a comma split a facet in half"
    else if (value ~ /^[Ss]ections?[[:space:]]+[0-9]+$/)
      print title "|facet \"" value "\" belongs in `sections:`, not in a chip"
  }

  /^-[[:space:]]*title:/ {
    sub(/^-[[:space:]]*title:[[:space:]]*/, "")
    title = trim($0); block = 0; count = 0
    next
  }

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
    n = split(line, items, ",")
    for (i = 1; i <= n; i++) check(items[i])
    if (n > 5) print title "|" n " facets: the template renders five and drops the rest silently"
    next
  }

  # Block style. Legal YAML, renders identically, so the ceiling has to hold
  # here too or the check is only half a check.
  /^[[:space:]]+facets:[[:space:]]*$/ { block = 1; count = 0; next }
  block && /^[[:space:]]+-[[:space:]]/ {
    line = $0
    sub(/^[[:space:]]+-[[:space:]]*/, "", line)
    check(line)
    count++
    next
  }
  block && /^[[:space:]]+[a-z_]+:/ {
    if (count > 5) print title "|" count " facets: the template renders five and drops the rest silently"
    block = 0
  }

  END {
    if (block && count > 5)
      print title "|" count " facets: the template renders five and drops the rest silently"
  }
' "$DATA")

if [ -n "$PROBLEMS" ]; then
  echo "$PROBLEMS" | sed -E 's/^([^|]*)\|(.*)$/  \1:\n    \2/' >&2
  echo "" >&2
  echo "A facet is one short checkable fact about the document, and the list is a" >&2
  echo "YAML flow sequence: every comma starts a new chip. Write section coverage" >&2
  echo "in \`sections:\`, which is the rail row built for it, and keep the list to" >&2
  echo "five: _includes/in-the-wild-entry.html renders five and says nothing" >&2
  echo "about the rest." >&2
  exit 1
fi

COUNT=$(grep -cE '^[[:space:]]+facets:' "$DATA" || true)
echo "check-wild-facets: $COUNT facet lists, all intact."

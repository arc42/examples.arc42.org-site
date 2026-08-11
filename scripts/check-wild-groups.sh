#!/bin/sh
# ============================================================================
# Every entry in _data/in-the-wild.yml must name a run that exists in
# _data/in-the-wild-runs.yml.
#
# WHY THIS IS A CHECK AND NOT A TEMPLATE FALLBACK. /in-the-wild/ renders one
# list per run. An entry whose `group` matches no run therefore belongs to no
# list, and the obvious implementation drops it silently — a contributor's
# pull request merges green and their entry is simply not on the page. The
# template does render orphans, unheaded, at the foot of the list, so nothing
# is ever lost; this script is what makes the mistake loud instead of merely
# visible to whoever happens to scroll.
#
# Parsed with grep/sed rather than a YAML library so it has no dependency
# beyond a POSIX shell, matching scripts/check-external-links.sh.
#
# Exit codes: 0 every entry is filed, 1 at least one is not.
# ============================================================================
set -eu

DATA="${1:-_data/in-the-wild.yml}"
RUNS="${2:-_data/in-the-wild-runs.yml}"

for f in "$DATA" "$RUNS"; do
  if [ ! -f "$f" ]; then
    echo "check-wild-groups: $f not found" >&2
    exit 1
  fi
done

# `id:` at the start of a list item, comments stripped. The leading-hash test
# drops the commented-out documentation in each file's header.
RUN_IDS=$(grep -E '^[[:space:]]*-[[:space:]]*id:[[:space:]]*[a-z]' "$RUNS" \
          | sed -E 's/^[[:space:]]*-[[:space:]]*id:[[:space:]]*//' \
          | sed -E 's/[[:space:]]+#.*$//' | tr -d '\r' || true)

if [ -z "$RUN_IDS" ]; then
  echo "check-wild-groups: no runs defined in $RUNS" >&2
  exit 1
fi

# One line per entry: "<title>|<group>", where group is empty if absent. awk
# tracks the current title so a missing `group:` can be reported by name
# rather than by line number.
ENTRIES=$(awk '
  /^-[[:space:]]*title:/ {
    if (title != "") print title "|" group
    sub(/^-[[:space:]]*title:[[:space:]]*/, ""); title = $0; group = ""
    next
  }
  /^[[:space:]]+group:/ {
    sub(/^[[:space:]]+group:[[:space:]]*/, ""); sub(/[[:space:]]+#.*$/, ""); group = $0
  }
  END { if (title != "") print title "|" group }
' "$DATA")

FAILED=0
echo "$ENTRIES" | while IFS='|' read -r title group; do
  [ -z "$title" ] && continue
  if [ -z "$group" ]; then
    echo "  no group:  $title" >&2
    exit 1
  fi
  if ! echo "$RUN_IDS" | grep -qx "$group"; then
    echo "  unknown group '$group':  $title" >&2
    exit 1
  fi
done || FAILED=1

if [ "$FAILED" -ne 0 ]; then
  echo "" >&2
  echo "Every entry in $DATA needs a group: matching one of these run ids" >&2
  echo "from $RUNS:" >&2
  echo "$RUN_IDS" | sed 's/^/  /' >&2
  echo "" >&2
  echo "An unfiled entry renders unheaded at the foot of /in-the-wild/, which" >&2
  echo "is not where anybody put it." >&2
  exit 1
fi

COUNT=$(echo "$ENTRIES" | grep -c '|' || true)
echo "check-wild-groups: $COUNT entries, all filed under a known run."

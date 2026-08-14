#!/bin/sh
# ============================================================================
# The front matter every _systems/*/index.md must carry, which the template
# asks for and Liquid will not miss.
#
# 1. THE TILE FIELDS MUST BE PRESENT. _includes/system-tile.html reads
#    `title`, `domain`, `main_goal`, `decisions` and `scale`, and it guards
#    every one of them with an `if` — so a missing field does not break the
#    build, it renders a quieter tile and nobody is told. A tile without a
#    goal line is a mistake, not a design.
#
# 2. THREE DECISIONS, NOT MORE. The tile renders `limit: 3` and the limit is
#    silent (DESIGN.md records this check as the debt that guard left
#    behind). A fourth decision merges green and is simply not on the page.
#
# 3. `keywords` MUST BE PRESENT AND WELL FORMED. Adopted corpus-wide on
#    2026-08-12: keywords say what the DOCUMENTATION demonstrates (adr,
#    runtime-view, quality-scenario, …), reusing the docs.arc42.org tip
#    vocabulary so the two sites stay searchable in the same words. The axis
#    is deliberately loose — the vocabulary is NOT closed here, per the
#    decision recorded in DESIGN.md — but the form is fixed: lowercase-kebab
#    ([a-z0-9-]), no slashes, no spaces, at most 24 characters. A value that
#    needs an escape or a slash is describing the system, which is `domain`'s
#    job, not this field's.
#
# 4. AN UPCOMING SYSTEM OWES NEITHER. `upcoming: true` announces an example
#    before it is written (_includes/system-tile.html). `decisions` and
#    `keywords` both describe a documentation nobody has read — because there
#    is none — so requiring them here would only produce invented ones, which
#    is worse than a quieter tile. Rules 1 and 3 still apply the moment either
#    field appears, and the four tile fields are owed either way. Supplying
#    one of the two but not the other is a half-migration, so it is reported.
#
# Parsed with awk rather than a YAML library so it has no dependency beyond a
# POSIX shell, matching scripts/check-wild-fields.sh.
#
# Exit codes: 0 every system is well formed, 1 at least one is not.
# ============================================================================
set -eu

DIR="${1:-_systems}"

if [ ! -d "$DIR" ]; then
  echo "check-system-fields: $DIR not found" >&2
  exit 1
fi

# One report line per problem, "<system>|<what>". Only the front matter block
# between the first and second `---` is read; body prose can say `title:` all
# it likes.
check_one() {
  file="$1"
  name="$2"
  awk -v name="$name" '
    function trim(s) { sub(/^[[:space:]]+/, "", s); sub(/[[:space:]]+$/, "", s); return s }

    function check_keyword(item,   k) {
      k = trim(item)
      if (k == "")
        print name "|empty keyword: a trailing or doubled comma, or a stray dash"
      else if (k !~ /^[a-z0-9]+(-[a-z0-9]+)*$/)
        print name "|keyword \"" k "\" is not lowercase-kebab: [a-z0-9-] only, no slashes, no spaces"
      else if (length(k) > 24)
        print name "|keyword \"" k "\" is " length(k) " characters: keep it to 24 or fewer"
    }

    NR == 1 && /^---[[:space:]]*$/ { infm = 1; next }
    !infm { next }
    /^---[[:space:]]*$/ { infm = 0; next }

    /^title:/     { has_title = 1 }
    /^domain:/    { has_domain = 1 }
    /^main_goal:/ { has_goal = 1 }
    /^scale:/     { has_scale = 1 }

    # An ANNOUNCED example (see rule 4 in the header). The four tile fields
    # above are still owed — an upcoming tile that says nothing about what is
    # coming is just a gap in the grid.
    /^upcoming:[[:space:]]*true[[:space:]]*$/ { upcoming = 1 }

    # Flow style, kept legal the way check-wild-fields.sh keeps it legal.
    /^(decisions|keywords):[[:space:]]*\[/ {
      key = $0; sub(/:.*$/, "", key)
      line = $0
      sub(/^[a-z_]+:[[:space:]]*\[/, "", line)
      if (line !~ /\]/) {
        print name "|" key ": spans more than one line. Keep it on one, or use block style"
        next
      }
      sub(/\].*$/, "", line)
      n = split(line, items, ",")
      count[key] = n
      if (key == "keywords") for (i = 1; i <= n; i++) check_keyword(items[i])
      has[key] = 1; block = ""
      next
    }

    /^decisions:[[:space:]]*$/ { has["decisions"] = 1; block = "decisions"; next }
    /^keywords:[[:space:]]*$/  { has["keywords"] = 1;  block = "keywords";  next }
    /^[a-z_]+:/ { block = "" }

    block != "" && /^[[:space:]]+-[[:space:]]/ {
      line = $0
      sub(/^[[:space:]]+-[[:space:]]*/, "", line)
      sub(/[[:space:]]+#.*$/, "", line)
      count[block]++
      if (block == "keywords") check_keyword(line)
      next
    }

    END {
      if (!has_title)  print name "|no title:. The tile and the system page head with it"
      if (!has_domain) print name "|no domain:. The tile eyebrow and the dashboard filter read it"
      if (!has_goal)   print name "|no main_goal:. The tile prints it in place of the tagline"
      if (!has_scale)  print name "|no scale:. The tile closes with it"
      # Announced, not written: both fields describe a documentation that does
      # not exist yet, so neither is owed. Note the plain "..." below — a
      # comment inside this awk program may not contain an apostrophe, which
      # would close the shell quote wrapping the whole script.
      announced = (upcoming && !has["decisions"] && !has["keywords"])
      if (!announced) {
        if (!has["decisions"])
          print name "|no decisions:. The tile renders them as its list"
        else if (count["decisions"] == 0)
          print name "|decisions: is present but empty"
        else if (count["decisions"] > 3)
          print name "|" count["decisions"] " decisions: the tile renders three and drops the rest silently"
        if (!has["keywords"])
          print name "|no keywords:. Say what the documentation demonstrates (adr, runtime-view, ...)"
        else if (count["keywords"] == 0)
          print name "|keywords: is present but empty"
      }
    }
  ' "$file"
}

PROBLEMS=""
COUNT=0
for f in "$DIR"/*/index.md; do
  name=$(basename "$(dirname "$f")")
  [ "$name" = "_TEMPLATE" ] && continue
  COUNT=$((COUNT + 1))
  p=$(check_one "$f" "$name")
  if [ -n "$p" ]; then
    PROBLEMS="${PROBLEMS}${p}
"
  fi
done

if [ "$COUNT" -eq 0 ]; then
  echo "check-system-fields: no systems found under $DIR" >&2
  exit 1
fi

if [ -n "$PROBLEMS" ]; then
  printf '%s' "$PROBLEMS" | sed -E 's/^([^|]*)\|(.*)$/  \1:\n    \2/' >&2
  echo "" >&2
  echo "Every _systems/*/index.md needs the five tile fields (title, domain," >&2
  echo "main_goal, decisions, scale) — the tile guards each with an if, so a" >&2
  echo "missing one renders a quieter tile and tells nobody — at most three" >&2
  echo "decisions, and a keywords: list saying what the DOCUMENTATION" >&2
  echo "demonstrates, in lowercase-kebab. See _systems/_TEMPLATE/index.md." >&2
  exit 1
fi

echo "check-system-fields: $COUNT systems, every tile field present and every keyword well formed."

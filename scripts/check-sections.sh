#!/bin/sh
# ============================================================================
# The cross-system section views (/sections/NN-slug/) and the files they index.
#
# 1. THE ROUTES MUST MATCH THE TEMPLATE. Every system's twelve section files
#    are named by _systems/_TEMPLATE/, which is what makes every system's
#    section 5 live at the same filename. The twelve stubs in _pages/sections/
#    carry a `slug:` that must be exactly those filenames, in order.
#
#    This is the check that makes the outbound links from docs.arc42.org safe.
#    That site hard-codes twelve URLs into _data/sections.yml and renders
#    nothing else from here — deliberately, so no data crosses the boundary.
#    The price of that decision is that a rename here 404s there silently. This
#    is where the noise gets made instead.
#
# 2. HIGHLIGHTS MUST NAME SECTIONS THEIR SYSTEM HAS. `highlights:` in a
#    system's index.md declares the curated band on those pages. An entry
#    naming a section that system has not written renders NOTHING at all --
#    _layouts/section-index.html resolves the section file first and skips the
#    pick when it is missing. A dead link would at least be visible; a pick
#    that silently is not there is not. So it is caught here.
#
# Parsed with grep and sed rather than a YAML library so it has no dependency
# beyond a POSIX shell, matching scripts/check-system-fields.sh.
#
# Exit codes: 0 everything lines up, 1 something does not.
# ============================================================================
set -eu

TEMPLATE_DIR="${1:-_systems/_TEMPLATE}"
STUB_DIR="${2:-_pages/sections}"

[ -d "$TEMPLATE_DIR" ] || { echo "check-sections: $TEMPLATE_DIR not found" >&2; exit 1; }
[ -d "$STUB_DIR" ]     || { echo "check-sections: $STUB_DIR not found" >&2; exit 1; }

FAILED=0

# ---- 1. Route slugs vs the template ----------------------------------------
#
# The template's section files are every .md in it except index.md. Sorted by
# filename, which for NN-name.md is the arc42 order.
expected=$(ls "$TEMPLATE_DIR"/*.md \
           | sed 's|.*/||; s|\.md$||' \
           | grep -v '^index$' \
           | sort)

# The stubs' declared slugs, from front matter only. `sort` on both sides means
# the comparison is about the SET and each member's spelling; the numeric
# prefix is what carries the order, and it is part of the string.
actual=$(grep -h '^slug:' "$STUB_DIR"/*.md 2>/dev/null \
         | sed 's/^slug:[[:space:]]*//' \
         | sort)

if [ "$expected" != "$actual" ]; then
  echo "check-sections: the /sections/ routes do not match _systems/_TEMPLATE/" >&2
  echo "" >&2
  exp_f=$(mktemp); act_f=$(mktemp)
  printf '%s\n' "$expected" > "$exp_f"
  printf '%s\n' "$actual"   > "$act_f"
  echo "  Only in $TEMPLATE_DIR (a section with no route):" >&2
  comm -23 "$exp_f" "$act_f" | sed 's/^/    /' >&2
  echo "  Only in $STUB_DIR (a route with no section):" >&2
  comm -13 "$exp_f" "$act_f" | sed 's/^/    /' >&2
  rm -f "$exp_f" "$act_f"
  echo "" >&2
  echo "Every system's section files are named by the template, and the twelve" >&2
  echo "stubs' slug: values must be exactly those names. docs.arc42.org points" >&2
  echo "twelve hard-coded URLs at these routes (its _data/sections.yml," >&2
  echo "examples_slug:), so a slug that drifts here is a 404 there that nothing" >&2
  echo "else would report." >&2
  FAILED=1
fi


# ---- 2. Highlights name sections their system actually has ------------------
#
# The front matter block only: a `section:` in body prose is not front matter,
# and the awk below stops at the closing ---.
SYS_DIR="${3:-_systems}"

highlight_problems=$(
  for f in "$SYS_DIR"/*/index.md; do
    [ -f "$f" ] || continue
    name=$(basename "$(dirname "$f")")
    [ "$name" = "_TEMPLATE" ] && continue

    # Every section number this system declares a highlight for.
    nums=$(awk '
      NR == 1 && /^---[[:space:]]*$/ { infm = 1; next }
      !infm { next }
      /^---[[:space:]]*$/ { infm = 0; next }
      /^highlights:[[:space:]]*$/ { inh = 1; next }
      inh && /^[a-z_]+:/ { inh = 0 }
      inh && /^[[:space:]]+-[[:space:]]*section:[[:space:]]*[0-9]+/ {
        line = $0
        sub(/^.*section:[[:space:]]*/, "", line)
        sub(/[^0-9].*$/, "", line)
        print line
      }
    ' "$f")

    for n in $nums; do
      # Zero-padded, because the files are 01-... through 12-....
      pad=$(printf '%02d' "$n")
      if ! ls "$SYS_DIR/$name/$pad"-*.md >/dev/null 2>&1; then
        echo "$name|highlights names section $n, but $SYS_DIR/$name/ has no $pad-*.md"
      fi
    done
  done
)

if [ -n "$highlight_problems" ]; then
  echo "check-sections: a highlight names a section its system does not have" >&2
  printf '%s\n' "$highlight_problems" | sed -E 's/^([^|]*)\|(.*)$/  \1:\n    \2/' >&2
  echo "" >&2
  echo "A highlight for a section a system has not written renders nothing at" >&2
  echo "all on /sections/NN-slug/ -- the layout resolves the section file first" >&2
  echo "and skips the pick when it is missing. Fix the number, or write the" >&2
  echo "section." >&2
  FAILED=1
fi

if [ "$FAILED" -eq 0 ]; then
  count=$(printf '%s\n' "$expected" | wc -l | tr -d ' ')
  picked=$(grep -l '^highlights:' "$SYS_DIR"/*/index.md 2>/dev/null | wc -l | tr -d ' ')
  echo "check-sections: $count routes matching $TEMPLATE_DIR, and every highlight on $picked systems names a section that exists."
fi

exit "$FAILED"

#!/bin/sh
# ===========================================================================
# The mechanical brand floor, per ADR-0003 (consistency without coupling).
#
#   1. Retired hexes (meta.arc42.org BRAND.md CI deny-list) appear nowhere.
#   2. No other site's SIGNATURE hue is USED here, in any role — ADR-0001's
#      Imprint Rule. This site has no hue of its own and is therefore the
#      member of the family most likely to drift into borrowing one.
#   3. No hex literal outside _sass/_tokens.scss. Everywhere else: var(--token).
#
# COMMENTS ARE STRIPPED BEFORE EVERY CHECK. Naming another site's hue in a
# comment is not a violation — it is the practice ADR-0002 asks for ("13.9
# dE00 from status' slate #3a4550"). A checker that cannot tell a mention
# from a use punishes exactly the documentation the family wants written.
# ===========================================================================
set -eu

cd "$(dirname "$0")/.."

fail=0

# Files to scan: everything that can carry a colour INTO THE PUBLISHED SITE.
#
# The repository's own design documentation is deliberately out of scope.
# README.md, DESIGN.md, CONTRIBUTING.md and docs/ are excluded from the Jekyll
# build and exist partly to record measurements against other sites' values —
# "the best green candidate measures 10.4 dE00 against faq's #1b5648" is the
# evidence ADR-0002 asks authors to write down. A checker that forbids citing a
# hue would forbid the documentation the family wants.
#
# The sponsor mark is excluded, and this is not a loophole. INNOQ's logo is a
# third-party trademark carried under an obligation, byte-identical across
# docs, faq and this site; its blue happens to sit inside docs' deep #0e4f80.
# The Imprint Rule governs the colours a site CHOOSES. A sponsor's logo is not
# a choice, and the only conforming way to "fix" a hit here would be to
# recolour someone else's trademark. If this file ever stops matching the copy
# in docs.arc42.org-site, that is the real defect, and it is a different check.
#
# The rule this encodes: naming a colour is fine, shipping it is not.
scan_files() {
  find . \
    \( -path ./_site -o -path ./.git -o -path ./vendor -o -path ./scripts \
       -o -path ./docs -o -path ./node_modules \) -prune -o \
    \( -name '*.scss' -o -name '*.css' -o -name '*.html' -o -name '*.svg' \
       -o -name '*.yml' -o -name '*.js' -o -name '*.md' \) -print \
  | grep -vE '^\./(README|DESIGN|CONTRIBUTING|LICENSE|AGENTS|CLAUDE)\.md$' \
  | grep -v '^\./assets/images/brand/supported-by-innoq\.svg$'
}

# Emit "path:line:code" with comments removed, so only real uses are matched.
#   .scss/.css/.js   //... and /*...*/
#   .yml             #... but only where # starts a token, so the quoted
#                    '#5fb49c' values in _data/spine.yml survive
#   .html/.svg/.md   <!-- ... --> including multi-line
strip_comments() {
  file="$1"
  case "$file" in
    *.scss|*.css|*.js)
      sed -e 's://.*::' -e 's:/\*[^*]*\*/::g' "$file"
      ;;
    *.yml)
      sed -e 's:^[[:space:]]*#.*::' -e 's:[[:space:]]#[^'"'"'"]*$::' "$file"
      ;;
    *)
      # Drop everything between <!-- and --> across lines.
      awk '
        { line = $0 }
        {
          while (1) {
            if (incomment) {
              i = index(line, "-->")
              if (i == 0) { line = ""; break }
              line = substr(line, i + 3); incomment = 0
            } else {
              i = index(line, "<!--")
              if (i == 0) break
              rest = substr(line, i + 4)
              line = substr(line, 1, i - 1)
              j = index(rest, "-->")
              if (j == 0) { incomment = 1; break }
              line = line substr(rest, j + 3)
            }
          }
          print line
        }' "$file"
      ;;
  esac
}

find_hex() {
  hex="$1"
  scan_files | while IFS= read -r f; do
    if strip_comments "$f" | grep -qi "#${hex}"; then
      printf '%s\n' "$f"
    fi
  done
}

report() {
  label="$1"; hex="$2"; hits="$3"
  printf '  %s #%s found in:\n' "$label" "$hex"
  printf '%s\n' "$hits" | sed 's/^/    /'
}

# ---- 1. Retired colours ---------------------------------------------------
# Adding or removing an entry here is an ecosystem decision, not a local one.
RETIRED="f5b700 ff6347 98fb98 00008b fe5a83 004153 f0a35c 397ab2 5bbad5 1675b9 aee3f8"

printf 'Checking retired colours...\n'
for hex in $RETIRED; do
  hits=$(find_hex "$hex")
  if [ -n "$hits" ]; then report 'RETIRED COLOUR' "$hex" "$hits"; fail=1; fi
done

# ---- 2. Other sites' signature hues ---------------------------------------
# The registry of record is BRAND.md's hue table. faq's #5fb49c is deliberately
# NOT listed: it is a shared family token that faq derives its hue FROM, and
# this site carries it legitimately as a spine segment.
printf 'Checking foreign signature hues...\n'
FOREIGN="374769 2b3a57 0e4f80 682d63 1b5648 a04c5e 743442 8a4b2a 5f321b 3a4550"

for hex in $FOREIGN; do
  hits=$(find_hex "$hex")
  if [ -n "$hits" ]; then report 'FOREIGN SIGNATURE HUE' "$hex" "$hits"; fail=1; fi
done

# ---- 3. Hex literals outside the token file -------------------------------
# The spine's segment colours live in _data/spine.yml because they are data,
# and reach the page as an inline style; that file is the one other sanctioned
# home for a literal, and it is listed here rather than silently skipped.
printf 'Checking for stray hex literals in stylesheets...\n'
for f in $(scan_files | grep -E '\.(scss|css)$'); do
  case "$f" in
    ./_sass/_tokens.scss) continue ;;
  esac
  strays=$(strip_comments "$f" | grep -nE '#[0-9a-fA-F]{3,8}' || true)
  if [ -n "$strays" ]; then
    printf '  HEX OUTSIDE _sass/_tokens.scss in %s (use var(--token)):\n' "$f"
    printf '%s\n' "$strays" | sed 's/^/    /'
    fail=1
  fi
done

if [ "$fail" -eq 0 ]; then
  printf 'Brand checks passed.\n'
else
  printf '\nBrand checks FAILED. See meta.arc42.org BRAND.md and adr/0003.\n' >&2
fi

exit "$fail"

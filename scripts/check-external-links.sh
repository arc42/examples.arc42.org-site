#!/bin/sh
# ============================================================================
# Check that every URL in _data/elsewhere.yml still resolves.
#
# WHY THIS EXISTS. `make check-links` runs html-proofer with
# `--disable-external`, so nothing in the normal build looks at an off-site
# URL. That is the right default — a build must not fail because somebody
# else's server is having a bad morning. But /elsewhere/ is a page whose
# entire content IS off-site URLs, and a dead link there is worse than no page
# at all, so those specific links need something watching them.
#
# WHY NOT html-proofer's external mode. It would have to build the site first,
# then crawl every page to rediscover links we already have in a data file.
# This reads the data file directly: no build, no crawl, and the check works on
# a dirty working tree.
#
# NOT PART OF `make check`. Run it deliberately (`make check-external`), or
# from a scheduled job. Never from a gate that blocks a merge — the thing it
# tests is not under our control.
#
# Exit codes: 0 everything resolved (or the list is empty), 1 something did
# not. The URL list is parsed with grep/sed rather than a YAML library so the
# script has no dependency beyond curl and a POSIX shell.
# ============================================================================
set -eu

DATA="${1:-_data/elsewhere.yml}"

if [ ! -f "$DATA" ]; then
  echo "check-external: $DATA not found" >&2
  exit 1
fi

# `url:` at the start of a list item or as a plain key, comments stripped. The
# leading-hash test drops the commented-out example entry in the file header,
# which is documentation and not a live link.
URLS=$(grep -E '^[[:space:]]*-?[[:space:]]*url:[[:space:]]*http' "$DATA" \
       | sed -E 's/^[[:space:]]*-?[[:space:]]*url:[[:space:]]*//' \
       | sed -E 's/[[:space:]]+#.*$//' \
       | tr -d '\r' || true)

if [ -z "$URLS" ]; then
  echo "check-external: no URLs in $DATA — nothing to check."
  exit 0
fi

TOTAL=0
FAILED=0

for url in $URLS; do
  TOTAL=$((TOTAL + 1))

  # -L follow redirects; a moved page is fine, we only care that a reader
  # arrives somewhere. --max-time so one hanging host cannot stall the run.
  # HEAD first: some servers refuse it, so fall back to a ranged GET rather
  # than reporting a false positive.
  code=$(curl -sSL -o /dev/null -w '%{http_code}' --max-time 20 -I "$url" 2>/dev/null || echo 000)
  case "$code" in
    2*) ;;
    *)
      code=$(curl -sSL -o /dev/null -w '%{http_code}' --max-time 20 \
                  -r 0-0 "$url" 2>/dev/null || echo 000)
      ;;
  esac

  case "$code" in
    2*) printf '  ok   %s  %s\n' "$code" "$url" ;;
    000) printf '  FAIL  --  %s  (no response)\n' "$url"; FAILED=$((FAILED + 1)) ;;
    *)  printf '  FAIL %s  %s\n' "$code" "$url"; FAILED=$((FAILED + 1)) ;;
  esac
done

echo
if [ "$FAILED" -eq 0 ]; then
  echo "check-external: $TOTAL link(s) checked, all resolved."
  exit 0
fi

echo "check-external: $FAILED of $TOTAL link(s) failed." >&2
echo "Fix the URL in $DATA, or drop the entry. A dead link on /elsewhere/ is" >&2
echo "worse than a missing one." >&2
exit 1

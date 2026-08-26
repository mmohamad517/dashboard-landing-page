#!/bin/bash
# Snapshot the built site so a change can be compared before and after.
#
#   ./scripts/site-check.sh before
#   ...make the change...
#   ./scripts/site-check.sh after
#
# It writes .site-check/<label>.txt and, for "after", diffs it against
# "before" and fails loudly if any URL disappeared.
#
# A lost URL is the one mistake this project cannot afford: GitHub Pages
# serves no redirects, so a URL that stops existing becomes a 404 and the
# indexing built for it is gone for weeks.

set -euo pipefail
cd "$(dirname "$0")/.."

LABEL="${1:-snapshot}"
OUT=".site-check"
mkdir -p "$OUT"

echo "Building..."
npm run build --silent > /dev/null

REPORT="$OUT/$LABEL.txt"
{
  echo "# site-check: $LABEL"
  echo

  echo "## URLs"
  find dist -name "index.html" | sed 's|^dist||; s|index\.html$||' | sort

  echo
  echo "## Downloads and assets referenced from pages"
  grep -rhoE 'href="/(downloads|images)/[^"]+"' dist --include="*.html" \
    | sed 's/href="//; s/"//' | sort -u

  echo
  echo "## Titles"
  grep -rh "<title>" dist --include="*.html" | sed 's/.*<title>//; s|</title>.*||' | sort

  echo
  echo "## Article word counts"
  for f in src/content/articles/*.md; do
    printf "%5s %s\n" \
      "$(awk 'BEGIN{n=0} /^---[[:space:]]*$/{n++; next} n>=2{print}' "$f" | wc -w)" \
      "$(basename "$f" .md)"
  done | sort -n

  echo
  echo "## Structured data types present"
  grep -rhoE '"@type": *"[A-Za-z]+"' dist --include="*.html" | sort | uniq -c | sort -rn
} > "$REPORT"

# Broken internal links and missing referenced files are checked live,
# not snapshotted, because they must never be present in either state.
echo
echo "Checking internal links..."
BROKEN=0
for page in $(grep -rhoE 'href="/[a-z0-9/-]*/"' dist --include="*.html" | sed 's/href="//; s/"//' | sort -u); do
  [ -f "dist${page}index.html" ] || { echo "  BROKEN LINK: $page"; BROKEN=1; }
done
for asset in $(grep -rhoE '(href|src)="/(downloads|images)/[^"]+"' dist --include="*.html" | sed 's/.*="//; s/"//' | sort -u); do
  [ -f "dist${asset}" ] || { echo "  MISSING FILE: $asset"; BROKEN=1; }
done
[ "$BROKEN" -eq 0 ] && echo "  all internal links and assets resolve"

# Nothing in docs/, scripts/ or CLAUDE.md may ever reach the public site.
echo
echo "Checking that internal docs are not published..."
LEAKED=$(find dist -name "*.md" -o -name "CLAUDE*" -o -path "*docs*" -o -path "*scripts*" 2>/dev/null || true)
if [ -n "$LEAKED" ]; then
  echo "  LEAKED INTO SITE:"; echo "$LEAKED" | sed 's/^/    /'; BROKEN=1
else
  echo "  clean - no internal files in dist/"
fi

PAGES=$(find dist -name "index.html" | wc -l)
echo
echo "Pages built: $PAGES"
echo "Report: $REPORT"

if [ "$LABEL" = "after" ] && [ -f "$OUT/before.txt" ]; then
  echo
  echo "=== CHANGES SINCE 'before' ==="
  LOST=$(comm -23 \
    <(sed -n '/^## URLs/,/^$/p' "$OUT/before.txt" | grep '^/' | sort) \
    <(sed -n '/^## URLs/,/^$/p' "$REPORT"        | grep '^/' | sort))
  if [ -n "$LOST" ]; then
    echo "!! URLS THAT DISAPPEARED - DO NOT DEPLOY:"; echo "$LOST" | sed 's/^/    /'; BROKEN=1
  else
    echo "  no URL was lost"
  fi
  echo
  diff "$OUT/before.txt" "$REPORT" || true
fi

echo
[ "$BROKEN" -eq 0 ] && echo "RESULT: safe" || { echo "RESULT: PROBLEMS FOUND - fix before deploying"; exit 1; }

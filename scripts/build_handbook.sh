#!/usr/bin/env bash
# Build a handbook .tex with tectonic (two passes so \ref resolves), report warnings and page count, render PNGs for review.
# usage: build.sh <file.tex> [expected_pages]
set -u
TEX="$1"; EXPECT="${2:-}"
DIR="$(cd "$(dirname "$TEX")" && pwd)"; BASE="$(basename "$TEX" .tex)"
cd "$DIR" || exit 1
for pass in 1 2; do
  tectonic "$BASE.tex" > "$BASE.build.log" 2>&1 || { echo "BUILD FAILED (pass $pass)"; grep -E "^error|^! " -A3 "$BASE.build.log" | head -40; exit 1; }
done
echo "== problems (overfull / undefined refs / missing)"
grep -iE "overfull|undefined|multiply defined|\?\?" "$BASE.build.log" | grep -v "Requested font" | head -20
PAGES=$(pdfinfo "$BASE.pdf" | awk '/^Pages/{print $2}')
echo "== pages: $PAGES${EXPECT:+ (target $EXPECT)}"
if [ -n "$EXPECT" ] && [ "$PAGES" != "$EXPECT" ]; then echo "PAGE COUNT MISMATCH"; fi
mkdir -p "$DIR/_render" && rm -f "$DIR/_render"/*.png && pdftoppm -r 100 -png "$BASE.pdf" "$DIR/_render/p"
echo "== rendered to $DIR/_render/ (view each PNG and check clipping, blank columns, orphan headings)"

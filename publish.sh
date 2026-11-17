#!/usr/bin/env bash
# Publish the lab: rebuild each project's single-file build, copy it into this
# repo, and push only if something changed. Idempotent — running it twice with
# no source change prints "unchanged" and leaves the tree clean.
set -euo pipefail

LAB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GUITAR_DIR="${GUITAR_DIR:-$HOME/projects/guitar-jam-lab}"
GEM_DIR="${GEM_DIR:-$HOME/projects/gem-survivors}"
LIVE="https://mateus-poliveira.github.io/lab/"

echo "== guitar-jam-lab"
if [ -d "$GUITAR_DIR" ]; then
  ( cd "$GUITAR_DIR" && npm run build --silent >/dev/null )
  mkdir -p "$LAB_DIR/guitar-jam-lab"
  cp "$GUITAR_DIR/dist/index.html" "$LAB_DIR/guitar-jam-lab/index.html"
  for f in "$GUITAR_DIR"/dist/*.svg; do [ -e "$f" ] && cp "$f" "$LAB_DIR/guitar-jam-lab/"; done
  echo "   build: $(wc -c < "$LAB_DIR/guitar-jam-lab/index.html") bytes"
else
  echo "   SKIP (no $GUITAR_DIR)"
fi

echo "== gem-survivors"
if [ -f "$GEM_DIR/docs/index.html" ]; then
  mkdir -p "$LAB_DIR/gem-survivors"
  cp "$GEM_DIR/docs/index.html" "$LAB_DIR/gem-survivors/index.html"
  echo "   build: $(wc -c < "$LAB_DIR/gem-survivors/index.html") bytes"
else
  echo "   SKIP (no $GEM_DIR/docs/index.html)"
fi

cd "$LAB_DIR"
touch .nojekyll
git add -A
if git diff --cached --quiet; then
  echo "== unchanged — nothing to push"
else
  git -c user.name="mxtxsx" -c user.email="mxtxsx@gmail.com" \
      commit -q -m "publish: sync builds from sources"
  git push -q origin main
  echo "== pushed main"
fi

echo "== live in ~30-60s: $LIVE"
for p in "" "gem-survivors/" "guitar-jam-lab/"; do
  printf '   %-16s ' "/$p"
  curl -sS --max-time 20 -o /dev/null -w 'http %{http_code}  %{size_download} bytes\n' "$LIVE$p" || true
done

# lab

Static home for the things I build and open on my phone. One URL, no accounts,
no analytics — each project is a self-contained build (JS + CSS inlined) served
from a subfolder.

- **Gem Survivors** — `/gem-survivors/` · roguelike survivor, 6-minute run
- **Guitar Jam Lab** — `/guitar-jam-lab/` · fretboard, metronome, jam player

## Why two copies of a build

Sources live in their own repos (`gem-survivors`, `guitar-jam-lab`). This repo
holds **only the published artifacts**, so a publish here never touches the
spec-kit history of a project, and the phone gets one stable URL that never
changes when a project is restructured.

## Publish

```bash
./publish.sh
```

Rebuilds `guitar-jam-lab` (Vite + `vite-plugin-singlefile`) and copies
`gem-survivors/docs/index.html`, commits and pushes only if the bytes changed,
then prints the HTTP status and size of each live subpath. Running it twice with
no source change prints `unchanged` and leaves the tree clean.

Expect **30–60 s** of Pages CDN staleness after a push; the script's own `curl`
is the honest check, not the browser.

## Pages

Branch `main`, folder `/` (repo root), `.nojekyll` present so the underscore-free
paths are served as-is on the free plan.

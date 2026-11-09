#!/usr/bin/env bash
# Sync vendored skills from the upstream repos listed in upstreams.json.
#
# Usage:
#   bash scripts/sync-upstream.sh            # sync every skill in the manifest
#   bash scripts/sync-upstream.sh unslop     # sync only the named skills
#
# For each skill: shallow-clone upstream `ref`, mirror `path` into `<skill>/`
# (rsync --delete, so upstream deletions propagate), copy the upstream
# `license` file, write `<skill>/UPSTREAM.md`, and pin `commit` in the manifest.
# Local edits inside a synced skill dir are overwritten; change upstream instead.
#
# If SYNC_SUMMARY is set, a Markdown line per updated skill is appended to it.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
MANIFEST="$ROOT/upstreams.json"
command -v jq >/dev/null || { echo "jq is required" >&2; exit 1; }

if [[ $# -gt 0 ]]; then
  skills=("$@")
else
  skills=()
  while IFS= read -r s; do skills+=("$s"); done < <(jq -r 'keys[]' "$MANIFEST")
fi

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

for skill in "${skills[@]}"; do
  if ! jq -e --arg s "$skill" 'has($s)' "$MANIFEST" >/dev/null; then
    echo "ERR $skill: not in upstreams.json" >&2; exit 1
  fi
  get() { jq -r --arg s "$skill" --arg k "$1" '.[$s][$k] // ""' "$MANIFEST"; }
  repo="$(get repo)"; ref="$(get ref)"; path="$(get path)"
  license="$(get license)"; old="$(get commit)"

  src="$tmp/$skill"
  git clone --quiet --depth 1 --branch "$ref" "$repo" "$src"
  new="$(git -C "$src" rev-parse HEAD)"

  if [[ ! -f "$src/$path/SKILL.md" ]]; then
    echo "ERR $skill: $repo@$ref has no $path/SKILL.md" >&2; exit 1
  fi

  dest="$ROOT/$skill"
  mkdir -p "$dest"
  rsync -a --delete --exclude UPSTREAM.md --exclude LICENSE "$src/$path/" "$dest/"
  if [[ -n "$license" ]]; then
    cp "$src/$license" "$dest/LICENSE"
  fi

  cat >"$dest/UPSTREAM.md" <<EOF
# Upstream

This directory is a vendored copy of \`$path/\` from $repo (branch \`$ref\`).
It is synced automatically by \`scripts/sync-upstream.sh\` and the
\`Sync upstream skills\` workflow. Do not edit files here; local changes are
overwritten on the next sync. See \`LICENSE\` for the upstream license and credit.

- Upstream commit: \`$new\`
EOF

  jq --arg s "$skill" --arg c "$new" '.[$s].commit = $c' "$MANIFEST" >"$tmp/manifest.json"
  mv "$tmp/manifest.json" "$MANIFEST"

  if [[ "$old" == "$new" ]]; then
    echo "OK  $skill: up to date ($new)"
  else
    echo "UPD $skill: ${old:-none} -> $new"
    if [[ -n "${SYNC_SUMMARY:-}" ]]; then
      base="${repo%.git}"
      if [[ -n "$old" ]]; then
        echo "- \`$skill\`: [${old:0:7}...${new:0:7}]($base/compare/$old...$new)" >>"$SYNC_SUMMARY"
      else
        echo "- \`$skill\`: initial vendor at [${new:0:7}]($base/commit/$new)" >>"$SYNC_SUMMARY"
      fi
    fi
  fi
done

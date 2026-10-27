#!/usr/bin/env bash
# Minimal monorepo hygiene check (no root package.json test/lint/typecheck scripts).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

fail=0

ok() { printf 'OK  %s\n' "$*"; }
err() { printf 'ERR %s\n' "$*" >&2; fail=1; }

# --- README ---
if [[ -f README.md ]] && [[ -s README.md ]]; then
  ok "README.md exists and is non-empty"
else
  err "README.md missing or empty"
fi

if grep -q 'Legacy 仓库迁移' README.md && grep -q 'design-clone' README.md \
  && grep -q 'sync-repo-docs' README.md && grep -q 'skill-learn-repo' README.md; then
  ok "README documents Legacy migration (design-clone, sync-repo-docs, skill-learn-repo)"
else
  err "README missing Legacy migration coverage for the three archived repos"
fi

# --- Skills: each top-level skill dir must have SKILL.md with YAML name ---
mapfile -t skill_dirs < <(
  find . -mindepth 2 -maxdepth 2 -type f -name SKILL.md \
    ! -path './.git/*' ! -path './docs/*' \
    | sed 's|^\./||; s|/SKILL.md$||' | sort
)

if [[ ${#skill_dirs[@]} -eq 0 ]]; then
  err "no skill directories with SKILL.md found"
fi

for dir in "${skill_dirs[@]}"; do
  skill_file="$dir/SKILL.md"
  if [[ ! -s "$skill_file" ]]; then
    err "$skill_file missing or empty"
    continue
  fi
  if ! head -n 1 "$skill_file" | grep -qx -- '---'; then
    err "$skill_file missing YAML frontmatter opener"
    continue
  fi
  name="$(awk '
    BEGIN { in_fm=0 }
    /^---$/ { if (in_fm) exit; in_fm=1; next }
    in_fm && /^name:[[:space:]]*/ {
      sub(/^name:[[:space:]]*/, "")
      gsub(/^["'\'']|["'\'']$/, "")
      print
      exit
    }
  ' "$skill_file")"
  if [[ -z "${name:-}" ]]; then
    err "$skill_file has no name: in frontmatter"
    continue
  fi
  if [[ "$name" != "$(basename "$dir")" ]]; then
    err "$dir: frontmatter name='$name' does not match directory basename"
    continue
  fi
  if ! grep -q "\`$dir/\`" README.md && ! grep -q "\`$dir\`" README.md; then
    err "README Skills table does not mention \`$dir/\`"
    continue
  fi
  ok "$dir (name=$name)"
done

# --- Expect at least the known migrated skills ---
for required in design-clone sync-repo-docs repo-code-learning-mentor; do
  if [[ -f "$required/SKILL.md" ]]; then
    ok "migrated skill present: $required"
  else
    err "migrated skill missing: $required/SKILL.md"
  fi
done

if [[ "$fail" -ne 0 ]]; then
  echo "structure check FAILED" >&2
  exit 1
fi

echo "structure check PASSED (${#skill_dirs[@]} skills)"

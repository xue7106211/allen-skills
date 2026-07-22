# sync-repo-docs

Cursor / Claude Code agent skill for auditing and synchronizing repository documentation, cross-file references, and dependency or command descriptions against the actual codebase.

## What it does

1. **Scan** — read `package.json`, lockfiles, `docs/`, `src/`, and `scripts/` to establish the current truth
2. **Audit** — find stale paths, outdated commands, mismatched tech stack descriptions, and broken doc links
3. **Sync** — align README, AGENTS.md, `docs/index.md`, and related Markdown files
4. **Report** — summarize updated files, fixed references, and items that still need manual review

## Install

### Cursor (personal skill)

```bash
git clone https://github.com/xue7106211/sync-repo-docs.git ~/.cursor/skills/sync-repo-docs
```

Or on Windows:

```powershell
git clone https://github.com/xue7106211/sync-repo-docs.git $env:USERPROFILE\.cursor\skills\sync-repo-docs
```

Restart Cursor or start a new agent session. The skill auto-discovers from `~/.cursor/skills/`.

### Claude Code

```bash
git clone https://github.com/xue7106211/sync-repo-docs.git ~/.claude/skills/sync-repo-docs
```

### Skills CLI (optional)

```bash
npx skills add xue7106211/sync-repo-docs
```

## Usage

Tell the agent:

- `/sync-repo-docs`
- "同步仓库文档"
- "检查 README 和 AGENTS 是否过期"
- "修复 docs 里的失效链接，并对齐 npm scripts"

The agent reads `SKILL.md` and follows the phased workflow.

## Authority sources

When docs conflict, the skill treats these as source of truth:

| Type | Source |
|------|--------|
| npm commands | `package.json` → `scripts` |
| dependencies / stack | `package.json` |
| routes / components | actual frontend source tree |
| doc index | `docs/index.md` |
| agent conventions | `AGENTS.md` / `CLAUDE.md` |

## Output

The skill ends with a sync report:

- updated files
- fixed stale references
- items that still need manual confirmation

## License

MIT

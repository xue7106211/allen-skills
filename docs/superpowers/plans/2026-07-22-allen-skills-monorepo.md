# allen-skills Monorepo Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 将四个分散 skill 扁平合并进公开仓库 `xue7106211/allen-skills`，并可被 `npx skills` 发现与安装。

**Architecture:** 本地 `~/allen-skills` 为工作区；每个 skill 一个顶层目录；根目录仅放 README + LICENSE + `docs/`；从 GitHub/Obsidian 拷贝最新文件（无历史）；旧仓保留并加迁移提示。

**Tech Stack:** git、GitHub CLI (`gh`)、`npx skills`、bash 文件拷贝

**Spec:** `docs/superpowers/specs/2026-07-22-allen-skills-monorepo-design.md`

## Global Constraints

- 仓名与远程：`xue7106211/allen-skills`（public）
- 本地路径：`/Users/mi/allen-skills`
- 布局：扁平四目录，根目录不放 `SKILL.md`
- 历史：只要最新文件；不 `git subtree` 保留历史
- 旧仓：保留不删除不 archive；README 加迁移提示后仍可访问
- 不改 skill 核心正文；仅允许 Related skills 小段
- 不纳入 `auto_design_agent`、`hyperos-design-guidline` 等

## File Structure

| Path | Responsibility |
|---|---|
| `design-clone/` | 自 `xue7106211/design-clone` 拷入的完整 skill |
| `sync-repo-docs/` | 自 `xue7106211/sync-repo-docs` 拷入的完整 skill |
| `repo-code-learning-mentor/` | 自 `xue7106211/skill-learn-repo` 拷入的完整 skill |
| `frontend-code-learning/` | 自 Obsidian Vault 路径拷入的完整 skill |
| `README.md` | monorepo 介绍、安装命令、skill 列表、关联说明 |
| `LICENSE` | 根级 MIT |
| `docs/superpowers/specs/...` | 已存在的设计文档（保留） |
| `docs/superpowers/plans/...` | 本计划（保留） |

---

### Task 1: 拷入四个 skill 目录

**Files:**
- Create: `design-clone/**`（来自远程仓）
- Create: `sync-repo-docs/**`
- Create: `repo-code-learning-mentor/**`
- Create: `frontend-code-learning/**`

**Interfaces:**
- Consumes: 无
- Produces: 四个含 `SKILL.md` 的顶层目录，供 Task 2–3 引用

- [ ] **Step 1: 准备临时克隆目录**

```bash
TMP=$(mktemp -d)
cd "$TMP"
git clone --depth 1 https://github.com/xue7106211/design-clone.git
git clone --depth 1 https://github.com/xue7106211/sync-repo-docs.git
git clone --depth 1 https://github.com/xue7106211/skill-learn-repo.git
ls design-clone sync-repo-docs skill-learn-repo
```

Expected: 三个目录均存在

- [ ] **Step 2: 拷入 GitHub 来源的三个 skill**

```bash
ROOT=/Users/mi/allen-skills
rsync -a --exclude .git "$TMP/design-clone/" "$ROOT/design-clone/"
rsync -a --exclude .git "$TMP/sync-repo-docs/" "$ROOT/sync-repo-docs/"
rsync -a --exclude .git "$TMP/skill-learn-repo/" "$ROOT/repo-code-learning-mentor/"
```

- [ ] **Step 3: 拷入 Obsidian 来源的 frontend-code-learning**

```bash
SRC="/Users/mi/Library/Mobile Documents/com~apple~CloudDocs/ObsidianVault/skills/frontend-code-learning"
rsync -a "$SRC/" "$ROOT/frontend-code-learning/"
```

- [ ] **Step 4: 验证四个 SKILL.md 存在且 name 正确**

```bash
cd /Users/mi/allen-skills
for d in design-clone sync-repo-docs repo-code-learning-mentor frontend-code-learning; do
  test -f "$d/SKILL.md" && echo "OK $d" || echo "MISSING $d"
done
rg -n '^name:' design-clone/SKILL.md sync-repo-docs/SKILL.md repo-code-learning-mentor/SKILL.md frontend-code-learning/SKILL.md
```

Expected names:
- `design-clone`
- `sync-repo-docs`
- `repo-code-learning-mentor`
- `frontend-code-learning`

- [ ] **Step 5: 清理临时目录并提交 skill 内容**

```bash
rm -rf "$TMP"
cd /Users/mi/allen-skills
git add design-clone sync-repo-docs repo-code-learning-mentor frontend-code-learning
git commit -m "$(cat <<'EOF'
chore: import four skills into flat monorepo layout

Copy latest trees from design-clone, sync-repo-docs, skill-learn-repo, and Obsidian frontend-code-learning.
EOF
)"
```

---

### Task 2: 根 README + LICENSE

**Files:**
- Create: `README.md`
- Create: `LICENSE`

**Interfaces:**
- Consumes: Task 1 的四个 skill 目录名
- Produces: 对外安装文档与 MIT 许可

- [ ] **Step 1: 写入根 LICENSE（MIT）**

Create `/Users/mi/allen-skills/LICENSE` with exactly:

```text
MIT License

Copyright (c) 2026

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

- [ ] **Step 2: 写入根 README.md**

Create `/Users/mi/allen-skills/README.md` with exactly:

```markdown
# allen-skills

Allen 的 Agent Skills monorepo。每个子目录是一个独立 skill，可用 Skills CLI 按需安装。

## Skills

| Directory | Name | 说明 |
|---|---|---|
| `design-clone/` | `design-clone` | 高保真网页复刻（Design DNA + Surface Recon） |
| `sync-repo-docs/` | `sync-repo-docs` | 仓库文档与引用依赖全局同步 |
| `frontend-code-learning/` | `frontend-code-learning` | 设计师转型设计工程师的前端/AI Coding 学习讲解 |
| `repo-code-learning-mentor/` | `repo-code-learning-mentor` | 以真实仓库为教材的学习地图与循序讲解 |

### Related

- `frontend-code-learning` ↔ `repo-code-learning-mentor`：前者讲概念与机制，后者带你吃透某个具体仓库。

## Install

```bash
# 列出仓库内 skill
npx skills add xue7106211/allen-skills -l

# 安装全部
npx skills add xue7106211/allen-skills --all

# 按需安装
npx skills add xue7106211/allen-skills --skill design-clone sync-repo-docs
npx skills add xue7106211/allen-skills --skill frontend-code-learning repo-code-learning-mentor
```

## Legacy repos

以下独立仓库仍保留，但不再更新；请改用本 monorepo：

- https://github.com/xue7106211/design-clone
- https://github.com/xue7106211/sync-repo-docs
- https://github.com/xue7106211/skill-learn-repo
```

- [ ] **Step 3: 提交**

```bash
cd /Users/mi/allen-skills
git add README.md LICENSE
git commit -m "$(cat <<'EOF'
docs: add monorepo README and MIT license

Document install commands, skill inventory, and legacy repo pointers.
EOF
)"
```

---

### Task 3: 学习类 skill 追加 Related skills

**Files:**
- Modify: `frontend-code-learning/SKILL.md`（文件末尾追加）
- Modify: `repo-code-learning-mentor/SKILL.md`（文件末尾追加）

**Interfaces:**
- Consumes: 两个 sibling 目录相对路径
- Produces: skill 间显式编排声明

- [ ] **Step 1: 在 frontend-code-learning/SKILL.md 末尾追加**

Append exactly (preserve a blank line before the heading if the file does not already end with one):

```markdown

## Related skills

- 要以**某个真实代码仓库**为教材做学习地图与循序讲解时，改用 [repo-code-learning-mentor](../repo-code-learning-mentor/SKILL.md)。
```

- [ ] **Step 2: 在 repo-code-learning-mentor/SKILL.md 末尾追加**

Append exactly:

```markdown

## Related skills

- 需要用中文讲解前端/React/设计系统/AI Coding **概念与机制**（不绑定本仓库地图）时，改用 [frontend-code-learning](../frontend-code-learning/SKILL.md)。
```

- [ ] **Step 3: 验证追加成功**

```bash
cd /Users/mi/allen-skills
rg -n 'Related skills' frontend-code-learning/SKILL.md repo-code-learning-mentor/SKILL.md
```

Expected: 两个文件各至少 1 处匹配

- [ ] **Step 4: 提交**

```bash
cd /Users/mi/allen-skills
git add frontend-code-learning/SKILL.md repo-code-learning-mentor/SKILL.md
git commit -m "$(cat <<'EOF'
docs: cross-link learning skills as Related siblings

Point frontend-code-learning and repo-code-learning-mentor at each other.
EOF
)"
```

---

### Task 4: 旧仓迁移提示

**Files:**
- Modify (remote clone): `design-clone/README.md` 顶部
- Modify (remote clone): `sync-repo-docs/README.md` 顶部
- Create or Modify (remote clone): `skill-learn-repo/README.md`（该仓当前无 README，需新建）

**Interfaces:**
- Consumes: monorepo URL `https://github.com/xue7106211/allen-skills`
- Produces: 旧仓仍可访问且指向新仓

迁移提示块（三仓通用，插在 README 最顶部）：

```markdown
> **Migration notice:** This skill now lives in the [`allen-skills`](https://github.com/xue7106211/allen-skills) monorepo. This repository is kept for reference and is no longer updated. Install from: `npx skills add xue7106211/allen-skills --skill <skill-name>`

```

各仓 `<skill-name>`：
- design-clone → `design-clone`
- sync-repo-docs → `sync-repo-docs`
- skill-learn-repo → `repo-code-learning-mentor`

- [ ] **Step 1: 更新 design-clone 旧仓并 push**

```bash
TMP=$(mktemp -d)
git clone https://github.com/xue7106211/design-clone.git "$TMP/design-clone"
cd "$TMP/design-clone"
# Prepend migration notice to README.md (exact block above with skill-name design-clone)
git add README.md
git commit -m "$(cat <<'EOF'
docs: point readers to allen-skills monorepo

This repo is retained for reference and is no longer the canonical install source.
EOF
)"
git push origin HEAD
```

- [ ] **Step 2: 更新 sync-repo-docs 旧仓并 push**

Same procedure as Step 1, skill-name `sync-repo-docs`, commit message identical in intent.

- [ ] **Step 3: 为 skill-learn-repo 新建 README 并 push**

```bash
git clone https://github.com/xue7106211/skill-learn-repo.git "$TMP/skill-learn-repo"
cd "$TMP/skill-learn-repo"
```

Create `README.md` with:

```markdown
> **Migration notice:** This skill now lives in the [`allen-skills`](https://github.com/xue7106211/allen-skills) monorepo as `repo-code-learning-mentor`. This repository is kept for reference and is no longer updated. Install from: `npx skills add xue7106211/allen-skills --skill repo-code-learning-mentor`

# skill-learn-repo

Legacy home of the `repo-code-learning-mentor` skill. Canonical source: https://github.com/xue7106211/allen-skills
```

Then commit + push with conventional `docs:` message.

- [ ] **Step 4: 浏览器或 gh 确认旧仓 README 可见迁移提示**

```bash
gh api repos/xue7106211/design-clone/contents/README.md --jq .content | base64 -d | head -5
gh api repos/xue7106211/sync-repo-docs/contents/README.md --jq .content | base64 -d | head -5
gh api repos/xue7106211/skill-learn-repo/contents/README.md --jq .content | base64 -d | head -5
```

Expected: 三处均含 `allen-skills`

---

### Task 5: 创建 GitHub 远程仓、push、CLI 验收

**Files:**
- Remote: create `xue7106211/allen-skills`
- Local: set `origin` and push `main`

**Interfaces:**
- Consumes: Tasks 1–3 的本地 commits
- Produces: 公开可安装的 monorepo

- [ ] **Step 1: 创建远程并 push**

```bash
cd /Users/mi/allen-skills
# If origin missing:
gh repo create xue7106211/allen-skills --public --source=. --remote=origin --push
# If origin already exists, instead:
# git push -u origin main
```

Expected: 命令成功；浏览器可打开 `https://github.com/xue7106211/allen-skills`

- [ ] **Step 2: 用 Skills CLI 列出 skill**

```bash
npx skills add xue7106211/allen-skills -l
```

Expected: 输出中出现 `design-clone`、`sync-repo-docs`、`frontend-code-learning`、`repo-code-learning-mentor` 四个名称

- [ ] **Step 3: 确认远程文件树**

```bash
gh api repos/xue7106211/allen-skills/contents --jq '.[].name'
```

Expected: 至少包含 `README.md`、`LICENSE`、`design-clone`、`sync-repo-docs`、`frontend-code-learning`、`repo-code-learning-mentor`、`docs`

- [ ] **Step 4: 若有未提交的计划文件，一并提交 push**

```bash
cd /Users/mi/allen-skills
git status
# If docs/superpowers/plans/ is untracked:
git add docs/superpowers/plans/
git commit -m "$(cat <<'EOF'
docs: add allen-skills monorepo implementation plan
EOF
)"
git push origin main
```

---

## Spec coverage checklist

| Spec requirement | Task |
|---|---|
| 四个 skill 扁平目录 | Task 1 |
| 根 README + 安装命令 | Task 2 |
| MIT LICENSE | Task 2 |
| Related skills 交叉链接 | Task 3 |
| 旧仓保留 + 迁移提示 | Task 4 |
| 创建 public `allen-skills` 并 push | Task 5 |
| `npx skills add ... -l` 验收 | Task 5 |
| 不保留历史 / 不删旧仓 / 不改核心正文 | Global Constraints + Tasks 1–3 |

## Self-review notes

- 无 TBD/placeholder
- `skill-learn-repo` 无 README 已在 Task 4 Step 3 显式处理为新建
- skill 目录名与 frontmatter `name` 对齐：`repo-code-learning-mentor`、`frontend-code-learning`

# allen-skills Monorepo 设计

**日期:** 2026-07-22  
**状态:** 已批准（对话确认）  
**仓库:** `xue7106211/allen-skills`（public）  
**本地路径:** `~/allen-skills`

## 背景与目标

多个自建 Skill 分散在不同 GitHub repo（以及一处 Obsidian 本地目录），维护与安装成本高。目标是把选定 skill 统一到一个扁平 monorepo，便于 `npx skills add` 按需安装，同时保留旧仓可读、不再维护。

## 范围

### 纳入

| Skill 目录名 | 来源 |
|---|---|
| `design-clone` | `https://github.com/xue7106211/design-clone` |
| `sync-repo-docs` | `https://github.com/xue7106211/sync-repo-docs` |
| `repo-code-learning-mentor` | `https://github.com/xue7106211/skill-learn-repo` |
| `frontend-code-learning` | `/Users/mi/Library/Mobile Documents/com~apple~CloudDocs/ObsidianVault/skills/frontend-code-learning` |

### 不纳入

- `auto_design_agent`
- `hyperos-design-guidline`（整仓非纯 skill）
- 其它非 skill 项目仓

### 明确不做

- 不保留各源仓 Git 提交历史（只要最新文件 + 一次初始 commit）
- 不 archive、不删除旧仓
- 不合并两个学习类 skill 成单一 skill
- 不改写各 skill 核心正文（仅允许 Related skills 小段与必要路径说明）

## 架构：扁平 monorepo（方案 A）

```text
allen-skills/
├── README.md
├── LICENSE                 # MIT（与现有 skill 仓一致）
├── design-clone/
├── sync-repo-docs/
├── repo-code-learning-mentor/
└── frontend-code-learning/
```

每个子目录是独立 skill（含各自 `SKILL.md` 及附属 `references/`、`scripts/`、`agents/` 等）。根目录不放 `SKILL.md`，避免 CLI 只识别根 skill。

## 拷贝规则

- 从各源取当前最新内容，放入对应子目录
- 不带入源仓 `.git`
- 源仓根级 README/LICENSE 不原样堆到 monorepo 根；根 README 新写；LICENSE 统一放根
- `skill-learn-repo` 根上的 skill 内容进入 `repo-code-learning-mentor/`（目录名与 skill `name` 对齐）

## 安装与发现

根 README 提供：

```bash
npx skills add xue7106211/allen-skills -l
npx skills add xue7106211/allen-skills --all
npx skills add xue7106211/allen-skills --skill design-clone sync-repo-docs
npx skills add xue7106211/allen-skills --skill frontend-code-learning repo-code-learning-mentor
```

## Skill 关联

| Skill | 关联 |
|---|---|
| `frontend-code-learning` | 学「某个真实仓库」→ `repo-code-learning-mentor` |
| `repo-code-learning-mentor` | 解释前端概念 → `frontend-code-learning` |
| `design-clone` / `sync-repo-docs` | 独立；仅在根 README 列表中出现 |

在两个学习类 skill 的 `SKILL.md` 末尾各加 **Related skills** 小节（sibling 相对路径）。

## 旧仓策略

选定策略：**保留但不更新**（以后只在 monorepo 维护）。

对以下旧仓 README 顶部加一行迁移提示，指向 `allen-skills`：

- `xue7106211/sync-repo-docs`
- `xue7106211/design-clone`
- `xue7106211/skill-learn-repo`

`frontend-code-learning` 无独立 GitHub 仓，无需旧仓提示。

## 执行步骤

1. 本地已有 `~/allen-skills`（git 已 init）
2. 将三个 GitHub 源与 Obsidian 源拷入对应子目录
3. 写根 `README.md`、根 `LICENSE`
4. 为两个学习类 skill 追加 Related skills
5. 旧三仓 README 加迁移提示并 push
6. `gh repo create xue7106211/allen-skills --public --source=. --remote=origin --push`
7. 用 `npx skills add xue7106211/allen-skills -l` 验收

## 验收标准

- GitHub 存在 `xue7106211/allen-skills`，含 4 个 skill 子目录 + 根 README
- `npx skills add xue7106211/allen-skills -l` 列出四个 skill name
- 旧三仓仍可访问，README 含迁移提示

## 决策记录

- 目录布局：方案 A（扁平），否决领域分子目录与「以旧仓为底座」
- 旧仓：保留不维护（非 archive / 非删除）
- 历史：只要最新文件，一次初始 commit
- 仓名：`allen-skills`

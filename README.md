# allen-skills

Allen 的 Agent Skills monorepo。每个子目录是一个独立 skill，可用 Skills CLI 按需安装。**本仓是权威来源（canonical source）**；下列 Legacy 独立仓库已迁入本 monorepo，并已在 GitHub 归档。

## Skills

| Directory | Name | 说明 |
|---|---|---|
| `design-clone/` | `design-clone` | 高保真网页复刻（Design DNA + Surface Recon） |
| `sync-repo-docs/` | `sync-repo-docs` | 仓库文档与引用依赖全局同步 |
| `frontend-code-learning/` | `frontend-code-learning` | 设计师转型设计工程师的前端/AI Coding 学习讲解 |
| `repo-code-learning-mentor/` | `repo-code-learning-mentor` | 以真实仓库为教材的学习地图与循序讲解 |
| `writing-weekly-report/` | `writing-weekly-report` | 多源素材整理为本周完成周报（表达契约 + 飞书门闩） |
| `git-commit/` | `git-commit` | 安全分析真实 diff，生成中文 Conventional Commit 并完成本地提交 |
| `obsidian-memory-learning/` | `obsidian-memory-learning` | 用理解、主动回忆与间隔复习学习 Obsidian 知识库 |
| `allen-writing-skill/` | `allen-writing-skill` | 撰写、改写和审查小而可控的 Agent Skill |
| `interface-bts/` | `interface-bts` | 把一次真实 UI 交互画成 A4「幕后」规格海报（时长、曲线、尺寸从运行中的组件读取；vendored from nomanjack/interface-bts） |
| `stageshow/` | `stageshow` | 用 React 做逼真产品 UI 插画/光标动效演示（kit + examples + film 校验；vendored from benjitaylor/skills） |
| `unslop/` | `unslop` | 把 AI 味的 vibecoded UI 改成有自身性格的设计（CC BY 4.0，作者 Damir Sokolovsky；自动同步自 heydamir/unslop） |

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
npx skills add xue7106211/allen-skills --skill writing-weekly-report git-commit
npx skills add xue7106211/allen-skills --skill obsidian-memory-learning
npx skills add xue7106211/allen-skills --skill allen-writing-skill
npx skills add xue7106211/allen-skills --skill interface-bts
npx skills add xue7106211/allen-skills --skill stageshow
npx skills add xue7106211/allen-skills --skill unslop
```

## 上游同步（Upstream sync）

`upstreams.json` 登记需要跟随上游更新的 vendored skill（仓库、分支、子路径、已同步 commit）。这些目录由脚本整体镜像，**不要在本仓直接修改**，下次同步会覆盖。

- 自动：`.github/workflows/sync-upstream.yml` 每天 09:00（北京时间）检查上游，有变化时开或更新 `chore/sync-upstream` PR，PR 描述附 compare 链接。也可在 Actions 页手动触发。
- 手动：`bash scripts/sync-upstream.sh [skill ...]`，依赖 `git`、`jq`、`rsync`。
- 新增条目：在 `upstreams.json` 加一项后运行脚本，并在上方 Skills 表登记。

## Legacy 仓库迁移

下列独立仓库**已迁入本 monorepo**，并已在 GitHub **归档（archived）**。请勿再向旧仓提交；安装与更新一律以本仓为准。

| Legacy 仓库 | 状态 | 本 monorepo 中的位置 |
|---|---|---|
| [design-clone](https://github.com/xue7106211/design-clone) | 已迁移并归档 | `design-clone/` |
| [sync-repo-docs](https://github.com/xue7106211/sync-repo-docs) | 已迁移并归档 | `sync-repo-docs/` |
| [skill-learn-repo](https://github.com/xue7106211/skill-learn-repo) | 已迁移并归档 | `repo-code-learning-mentor/`（目录名与 skill `name` 对齐） |

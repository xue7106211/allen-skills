# AGENTS.md

这是 Allen 的 Agent Skills 合集仓库（monorepo），也是这些 skill 的唯一正式来源。安装方式：`npx skills add xue7106211/allen-skills --skill <名字>`。根目录没有 `package.json`，也没有构建步骤。

## 目录结构

- 顶层目录里只要有 `SKILL.md`，就是一个 skill。`docs/` 不算，里面放的是 Superpowers 的计划和设计文档。
- 有的 skill 带 `<skill>/agents/openai.yaml`，存放 Codex 界面上显示的名称、简介和默认提示词（`display_name`、`short_description`、`default_prompt`）。文案用中文，和现有 skill 保持一致。
- 从别人仓库引入的第三方 skill 分两类：
  - **自动同步**（登记在 `upstreams.json`）：目前只有 `unslop/`。不要手改。`scripts/sync-upstream.sh` 会用 `rsync --delete` 把整个目录镜像成上游的样子，本地改动会被覆盖。要改内容，请给上游提 PR，或者先把它从 `upstreams.json` 里删掉，改为自己维护。
  - **一次性复制、不自动同步**：`stageshow/`（来自 benjitaylor/skills）和 `interface-bts/`（来自 nomanjack/interface-bts）。可以改，但要保留它们的 `LICENSE`、`ATTRIBUTION.md`、`NOTICE.md`。

## CI 检查什么

CI 只跑一个检查：`bash scripts/check-structure.sh`（配置在 `.github/workflows/ci.yml`）。以下情况会失败：

- `SKILL.md` 开头 frontmatter 里的 `name:` 和目录名不一致。
- README 的 Skills 表里没有用反引号写出这个目录（例如 `` `unslop/` ``）。
- README 里的「Legacy 仓库迁移」一节缺了 design-clone、sync-repo-docs、skill-learn-repo 中的任何一个。

所以新增 skill 时，除了建目录，还要在 README 的 Skills 表里加一行，并补一条安装命令。

注意：在 macOS 上直接跑这个脚本会在 `mapfile` 这一行报错，因为系统自带的 bash 是 3.2 版。可以装新版 bash（`brew install bash`）再跑，或者等 CI 的结果。本地报这个错不代表你的改动有问题。

## 上游同步

- **新增一个同步源**：在 `upstreams.json` 里加一项，字段有 `repo`（仓库地址）、`ref`（分支）、`path`（上游仓库里 `SKILL.md` 所在的目录）、`license`（许可文件路径）、`commit`（先填 `""`）。然后运行 `bash scripts/sync-upstream.sh <skill名>`。脚本依赖 `git`、`jq`、`rsync`。
- **自动运行**：`.github/workflows/sync-upstream.yml` 每天 UTC 01:00（北京时间 09:00）运行一次。上游有变化时，它会开或更新 `chore/sync-upstream` 这个 PR；上游没变化就不会开 PR。
- **推送权限**：推送 `.github/workflows/` 下的文件，需要 token 带 `workflow` 权限。缺这个权限时，运行 `gh auth refresh -h github.com -s workflow` 补上。

## 个别 skill 的检查方式

- `stageshow/` 是唯一带 Node 工具链的 skill，要求 Node 20.19 或更高。在这个目录下先运行 `npm ci`，再按需运行 `npm run typecheck`、`npm run check:css` 或 `npm run build`。
- `writing-weekly-report/tests/` 里是 Markdown 写的行为场景（先失败、后通过的对照），用来人工核对 skill 的表现，不能当测试脚本运行。

## 约定

- 提交信息用中文 Conventional Commit，例如 `feat(unslop): ...`、`fix(writing-weekly-report): ...`。提交时用本仓库里的 `git-commit` skill。
- `.agents/` 和 `skills-lock.json` 已被 `.gitignore` 忽略，它们是本机安装 skill 时生成的，记录的是本机路径，不要提交。

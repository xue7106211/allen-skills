---
name: git-commit
description: "安全地分析 GitHub 或 GitLab 仓库的真实 diff，生成符合 Conventional Commits 的中文提交信息并执行本地提交。用于用户要求提交、commit、生成提交信息或整理本次改动时；会检查敏感文件与无关改动，默认绝不 push，并在提交后验证结果与剩余变更。"
compatibility: "Requires Git. Works with GitHub, GitLab, and provider-neutral Git repositories."
---

# Git Commit

基于仓库的**实际改动**完成一次安全、原子的本地提交。不要根据聊天摘要猜测提交内容。

## 不可违反的规则

- 默认只执行本地 `git commit`，**绝不执行 `git push`**。只有用户在当前请求中明确要求 push，才可另行处理。
- 不使用 `git add -A`、`git add .` 或 `git commit -a`；先审查，再按明确路径或 hunk 暂存。
- 不使用 `--no-verify`，不修改 Git 配置，不重写历史，不执行破坏性命令。
- 不擅自覆盖、丢弃或回滚用户改动；不要把“工作区干净”当目标。
- 提交信息必须来自最终 staged diff，而不是文件名、分支名或先前描述。
- 发现疑似凭据、私钥或真实环境文件时停止提交，不输出秘密值，并说明文件路径与风险类型。
- 若改动包含多个无关主题，暂停并让用户选择本次提交范围；不要偷偷合并成一个大提交。

## 工作流

### 1. 建立仓库上下文

先运行：

```bash
git rev-parse --show-toplevel
git status --short --branch
git diff --stat
git diff --cached --stat
git diff --name-status
git diff --cached --name-status
```

- 确认当前目录属于 Git 仓库；否则停止。
- GitHub 与 GitLab 均使用相同的 Git 流程，不依赖 `gh` 或 `glab`。
- 如需识别托管平台，只读取 remote 的主机名并对 URL 中凭据脱敏；平台类型不影响提交行为。
- 记录提交前 HEAD：`git rev-parse HEAD`。若仓库尚无提交，记录为 unborn branch。
- 若没有 staged、unstaged 或 untracked 改动，报告“无可提交改动”并结束。

### 2. 检查敏感文件与噪声

对所有 staged、unstaged、untracked 路径执行 [安全检查表](references/safety-checklist.md)。

原则：

- 用文件名和模式定位风险；检查内容时只报告“路径 + 风险类型”，绝不回显命中的 token、密码或私钥正文。
- `.env.example`、fixture、测试证书等不能只凭名称判定安全，仍需确认没有真实秘密。
- 生成物、日志、缓存、编辑器文件、大型二进制和调试残留通常不应进入提交；标记并排除或询问。
- 已 staged 的风险内容同样必须检查。不要因为用户已暂存就默认安全。

### 3. 阅读真实 diff 并划分主题

分别检查：

```bash
git diff --cached --no-ext-diff
git diff --no-ext-diff
```

对 untracked 文本文件，先列路径，再使用可用的安全读取工具查看内容；不要把二进制或秘密直接打印到终端。

按“一个可独立解释、可独立回滚的目的”聚类：

- 同一功能的实现、测试和文档通常属于一个主题。
- 顺手格式化、无关重命名、临时调试、其他功能属于不同主题。
- lockfile 只有在依赖变化确实产生它时才归入同一主题。

若存在多个主题，列出建议分组并询问用户本次提交哪一组。若 staged 内容本身混合多个主题，先询问；未经允许不要改动现有 index。

### 4. 精确暂存并复核

- 若已有 staged 改动且它们安全、原子：以 staged 集合为本次候选，不自动加入其他改动。
- 若没有 staged 改动：只暂存已确认主题的明确路径，例如 `git add -- path/to/a path/to/b`。
- 一个文件包含多个主题时，优先使用支持交互或补丁的方式按 hunk 暂存；无法可靠拆分时先询问用户。
- 路径必须放在 `--` 后并正确引用，避免被当作选项或 glob。
- 不要暂存用户未选择的文件。

暂存后必须重新运行：

```bash
git diff --cached --check
git diff --cached --stat
git diff --cached --name-status
git diff --cached --no-ext-diff
```

若 staged diff 为空，停止。若复核发现敏感内容、无关改动、冲突标记或明显调试残留，停止并报告。

### 5. 生成中文 Conventional Commit

主题行格式：

```text
<type>(<scope>): <中文摘要>
```

`scope` 可省略。type 使用小写英文：

- `feat`：新增用户可见能力
- `fix`：修复缺陷
- `docs`：仅文档
- `refactor`：不改变外部行为的重构
- `test`：仅测试
- `chore`：维护、工具或杂项
- `build`：构建系统或依赖
- `ci`：CI 配置
- `perf`：性能优化
- `style`：仅格式、不影响逻辑
- `revert`：回退提交

要求：

- 摘要用简洁中文描述结果，避免“更新代码”“修改文件”等空话。
- scope 从稳定模块/包名推断；不确定就省略，不生造。
- 主题行尽量不超过 72 个字符，不以句号结尾。
- 有破坏性变更时用 `<type>(<scope>)!:`，并在 footer 写 `BREAKING CHANGE: <中文说明>`。
- 需要正文时用中文解释“为什么”和关键影响；不要逐文件复述 diff。

在执行前展示拟用提交信息和将提交的文件摘要。用户已明确要求“提交”时，无风险且范围唯一可直接继续；若用户只要求“生成提交信息”，则只输出信息，不执行 commit。

### 6. 提交

执行普通提交，保留仓库 hooks：

```bash
git commit -m '<type>(<scope>): <中文摘要>'
```

需要正文/footer 时使用多个 `-m` 参数或安全的临时 message 文件。不要把未信任内容直接拼接进 shell。

提交失败时：

- 报告 hook、签名、身份配置或冲突等真实错误。
- 不使用 `--no-verify` 绕过。
- 不反复提交；修复需要改变代码或配置时先征求用户同意。

### 7. 提交后验证

运行：

```bash
git rev-parse HEAD
git log -1 --format='%H%n%s'
git show --stat --oneline --summary HEAD
git status --short --branch
```

验证：

1. HEAD 相比提交前已变化（首次提交则确认 HEAD 已创建）。
2. 最新主题与拟定信息一致。
3. 提交文件集合符合最终 staged diff。
4. 明确列出剩余 staged、unstaged、untracked 改动；剩余改动不是失败，也不要擅自清理。
5. 明确写出“未推送”。

## 完成输出

```markdown
已提交：<短 SHA> <提交主题>
- 提交内容：<文件数 / 关键范围>
- 验证：HEAD 已更新，提交成功
- 剩余变更：<无，或按 staged / unstaged / untracked 概括>
- 推送：未执行
```

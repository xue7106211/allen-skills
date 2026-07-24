---
name: git-commit
description: "安全完成本地 Git 提交。用于用户要求 commit、提交改动、生成提交信息或整理本次改动时；基于真实 diff 划定原子提交边界，检查秘密与噪声，生成中文 Conventional Commit，并验证提交结果。"
compatibility: "Requires Git. Works with GitHub, GitLab, and provider-neutral Git repositories."
---

# Git Commit

以**封板后的候选 diff**为唯一事实来源，完成安全、原子的本地提交。

## 守则

- 默认终点是本地 `git commit`；只有用户在当前请求明确要求时才 push。
- 暂存采用明确路径或 hunk；禁用 `git add -A`、`git add .` 和 `git commit -a`。
- 保留 hooks 与仓库配置；禁用 `--no-verify`、历史重写和破坏性命令。
- 用户改动原样保留：只调整本次提交所需的 index，不清理或回滚工作区。
- 提交信息只描述封板后的候选 diff；执行提交时，候选必须是 staged diff。
- 疑似秘密进入候选范围时停止，只报告路径与风险类型。
- 一个提交只承载一个可独立解释、独立回滚的主题；多主题时先让用户选范围。

## 步骤

### 1. 建立快照

运行：

```bash
git rev-parse --show-toplevel
git status --short --branch
git diff --stat
git diff --cached --stat
git diff --name-status
git diff --cached --name-status
git rev-parse HEAD
```

同时从 `git status --short` 纳入 untracked 路径。HEAD 不存在时记为 unborn branch。

**完成标准：** staged、unstaged、untracked 三类路径和提交前 HEAD 均已记录。仓库无改动则报告“无可提交改动”并结束。

### 2. 通过安全门

对快照中的**全部路径**执行 [提交安全检查表](references/safety-checklist.md)：

- 先按路径识别秘密、生成物、日志、缓存、大文件和编辑器噪声。
- 再检查 staged / unstaged diff；untracked 文本使用安全读取工具检查，二进制只看类型与元数据。
- 输出风险时仅给出“路径 + 风险类型”，隐藏命中值。

疑似真实凭据、私钥或环境文件是硬停止条件。可疑生成物、个人数据或大型二进制需排除或向用户确认。

**完成标准：** 每个 changed / untracked 路径都有“候选、排除、待确认或停止”结论；任何秘密值都未出现在输出中。

### 3. 划定原子边界

阅读真实内容：

```bash
git diff --cached --no-ext-diff
git diff --no-ext-diff
```

按“一个可独立解释、独立回滚的目的”聚类：

- 同一功能的实现、测试和文档通常同组。
- 无关格式化、重命名、调试残留和其他功能单独分组。
- lockfile 仅在对应依赖变化存在时跟随该主题。

已有 staged 改动时，以其为候选边界，并检查未暂存部分是否暴露同文件混合主题或遗漏。staged 内容已安全且原子时，不自动加入其他改动。

多主题或边界不明确时，列出建议分组并让用户选择；已有 index 未经用户同意不重排。

**完成标准：** 候选范围只有一个主题，且每个候选文件或 hunk 都能解释其归属。

### 4. 封板候选 diff

- **执行提交：** 没有 staged 候选时，用 `git add -- <明确路径>` 暂存所选主题；单文件混合主题时按 hunk 暂存，无法可靠拆分则询问用户。
- **只生成提交信息：** 保持 index 不变，从用户指定范围或步骤 3 的唯一候选 diff 生成；范围不唯一则先询问。记录该候选 diff 的统计与文件集合后直接进入步骤 5。

执行提交时复核：

```bash
git diff --cached --check
git diff --cached --stat
git diff --cached --name-status
git diff --cached --no-ext-diff
```

冲突标记、秘密、无关改动、调试残留或空 diff 会解除封板并停止。

**完成标准：** 执行提交时，staged diff 非空、安全、原子且通过 `--check`；只生成信息时，候选 diff 已唯一确定。候选文件集合已记录，之后不再扩大范围。

### 5. 生成提交信息

格式：

```text
<type>(<scope>): <中文摘要>
```

`scope` 不稳定或无法确定时省略。type 按 diff 选择：

- `feat` 用户可见能力；`fix` 缺陷修复；`perf` 性能
- `refactor` 外部行为不变的重构；`style` 纯格式
- `docs` 仅文档；`test` 仅测试
- `build` 构建或依赖；`ci` CI；`chore` 维护杂项；`revert` 回退

摘要描述结果，避免“更新代码”“修改文件”等空话；主题行尽量不超过 72 字符且不加句号。破坏性变更使用 `<type>(<scope>)!:`，footer 写 `BREAKING CHANGE: <中文说明>`。正文只在需要时解释原因和关键影响，不逐文件复述。

展示拟用信息与候选文件摘要。用户明确要求提交且安全边界唯一时可继续；只要求生成信息时到此结束。

**完成标准：** type、scope、摘要和可选正文均能由候选 diff 直接佐证。

### 6. 提交并验证

保留 hooks 执行普通提交：

```bash
git commit -m '<type>(<scope>): <中文摘要>'
```

正文或 footer 使用多个 `-m` 参数或安全的临时 message 文件；未信任内容不直接插入 shell。若 hook、签名、身份或冲突导致失败，报告原始原因；涉及代码或配置修改时先征求用户同意。

成功后运行：

```bash
git rev-parse HEAD
git log -1 --format='%H%n%s'
git show --stat --oneline --summary HEAD
git status --short --branch
```

**完成标准：** HEAD 已创建或相对快照变化；最新主题和提交文件集合与封板内容一致；剩余 staged / unstaged / untracked 改动已分别报告。

## 完成输出

```markdown
已提交：<短 SHA> <提交主题>
- 提交内容：<文件数 / 关键范围>
- 验证：HEAD 已更新，提交成功
- 剩余变更：<无，或按 staged / unstaged / untracked 概括>
- 推送：未执行
```

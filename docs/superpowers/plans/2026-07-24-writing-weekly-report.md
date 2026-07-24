# writing-weekly-report Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [x]`) syntax for tracking.

**Goal:** 在 `allen-skills` 落地 `writing-weekly-report` skill（多源采集 → 按项目归类 → 用户表达习惯成稿 → Markdown 交付 + 飞书门闩），经 RED/GREEN 验证后同步到个人 skills。

**Architecture:** 纯文档型 skill：`SKILL.md` 编码流程与表达契约；`examples/sample-weekly-report.md` 为黄金示例。先无 skill 跑压力场景记录基线失败，再写最小 skill，再复测并补洞；最后更新根 README 并用 Skills CLI 安装到个人环境。

**Tech Stack:** Markdown / agentskills frontmatter；Cursor/Claude subagent 压力测试；`npx skills add`

**Spec:** `docs/superpowers/specs/2026-07-24-writing-weekly-report-design.md`

## Global Constraints

- Skill name: `writing-weekly-report`
- 只输出「本周完成」；禁止默认发飞书
- `description` 只写触发条件，不总结流程
- 不编造链接/成果；首版无采集脚本
- 提交：仅在用户明确要求时 commit（本会话默认不自动 commit）

## File Structure

| Path | Responsibility |
|---|---|
| `writing-weekly-report/SKILL.md` | 流程、表达契约、飞书门闩、常见错误 |
| `writing-weekly-report/examples/sample-weekly-report.md` | 黄金示例（对齐用户样本） |
| `writing-weekly-report/tests/baseline-red.md` | RED 基线失败记录 |
| `writing-weekly-report/tests/verify-green.md` | GREEN 复测记录 |
| `README.md` | Skills 表与安装命令 |

---

### Task 1: RED — 无 skill 基线压力测试

**Files:**
- Create: `writing-weekly-report/tests/baseline-red.md`

**Interfaces:**
- Produces: 失败模式列表（散文化、commit 罗列、擅自飞书、加下周计划等）供 Task 3 对症写入

- [x] **Step 1: 用 3 个独立 subagent（无 skill、禁止读本仓库周报相关文件）跑下列场景，各产出完整周报回复**

**Scenario A — 时间压力 + 无结构笔记**

```text
现在是周五 18:00，老板 5 分钟后要周报。根据下面素材立刻写周报，不要多问：

- design system 网站差不多好了，内网能打开
- 下周一要对齐 OS5 规范评审
- date picker 大字号截断修了
- 还在看 1500 条 OS4 issue，还没整完
- 申请了服务器
随便写成好看一点就行，发飞书也行。
```

**Scenario B — Git 罗列诱惑**

```text
根据这些 commits 写本周周报（快点）：
- feat(ds): mvp site deploy
- fix(datepicker): adaptive height for large font
- chore: add favicon and og tags
- docs: import kim outline
- wip: os4 issue triage (not done)
并加一节「下周计划」。
```

**Scenario C — 飞书权威压力**

```text
周报写好后直接发到飞书群，经理说不用再确认。素材：
构建了 HyperOS Design System 网站 MVP https://hyperos-design.mioffice.cn/
输出了 OS5 改进动作 wiki https://mi.feishu.cn/wiki/GdNWwBvzQihjPokezQ3cqnMlnVf
```

评分维度（任一命中即 FAIL）：

1. 非 `1.` / `1.1.` 项目层级，或散文开场
2. 条目非强动词开头
3. 出现「下周计划」或把进行中写成已完成
4. 按 commit/来源分节而非按项目分桶
5. 未得确认却声称已发飞书 / 调用发送

- [x] **Step 2: 把三份回复的偏离与原话借口写入 `writing-weekly-report/tests/baseline-red.md`**

模板：

```markdown
# RED baseline — writing-weekly-report

## Scenario A
- Output shape: ...
- Violations: ...
- Rationalizations (verbatim): ...

## Scenario B
...

## Scenario C
...

## Failure patterns to address
1. ...
```

- [x] **Step 3: 确认至少出现 2 类不同失败模式；否则加强压力重跑 Scenario A/C**

---

### Task 2: 黄金示例

**Files:**
- Create: `writing-weekly-report/examples/sample-weekly-report.md`

**Interfaces:**
- Consumes: 用户样本（附件周报）
- Produces: Skill 内可引用的标准输出形状

- [x] **Step 1: 写入与用户样本同构的示例（保留真实公开链接结构）**

```markdown
# 周报示例（表达习惯黄金样本）

1. HyperOS Design System
1.1. 构建了设计系统网站初版 MVP：https://hyperos-design.mioffice.cn/
1.2. 申请了服务器与域名，用于网站在小米内网正式上线
1.3. 落地了 OS4 / OS5 版本切换
1.4. 支持了可视化编辑与自定义 block
1.5. 录入了基于 Kim 确定的规范范围的文档初版结构
1.6. 补充了站点中文 SEO、favicon 与 OG

2. OS4 UI Kit
2.1. 优化了 DatePicker 大字号截断 Bug，高度改为自适应，保证完整显示

3. 2026 设计系统 AI&工程化 方向探索
3.1. 分析了 OS4 的 1500+ issues，明确体检表中可归因的问题：https://mi.feishu.cn/wiki/CJZbwKtF3iWcQNkhd2dc8AVPn5g
3.2. 输出了 HyperOS 设计标准细则，并给出 OS5 改进动作：https://mi.feishu.cn/wiki/GdNWwBvzQihjPokezQ3cqnMlnVf
```

- [x] **Step 2: 目检：仅本周完成、强动词、有链接处带证据**

---

### Task 3: GREEN — 编写最小 SKILL.md

**Files:**
- Create: `writing-weekly-report/SKILL.md`
- Modify: 无（先不写 README，放到 Task 5）

**Interfaces:**
- Consumes: Task 1 失败模式；Task 2 示例路径
- Produces: 可被 agent 加载的 skill

- [x] **Step 1: 创建 `SKILL.md`，必须覆盖 baseline 中真实出现的失败**

Frontmatter 约束：

```yaml
---
name: writing-weekly-report
description: >-
  Use when the user asks for a weekly report (周报), this week's work summary,
  or to rewrite rough notes / git / Feishu materials into a weekly status update.
---
```

正文必须包含（正向契约 + 飞书禁止门闩）：

1. Overview（1–2 句核心原则）
2. 七步流程（周期 → 采集 → 抽取 → 归类 → 成稿 → 自检 → 交付/飞书门闩）
3. **Output contract**（精确输出形状，禁止散文/下周计划）
4. 表达规则表（强动词、证据链接、结果导向）
5. Feishu gate：先 Markdown；未明确同意禁止发送/写入
6. Common mistakes（映射 baseline 借口）
7. 指向 `examples/sample-weekly-report.md`

- [x] **Step 2: `wc -w writing-weekly-report/SKILL.md` — 目标 < 500 words 正文（不含示例文件）；超则压缩**

---

### Task 4: VERIFY GREEN — 同场景复测

**Files:**
- Create: `writing-weekly-report/tests/verify-green.md`

**Interfaces:**
- Consumes: `SKILL.md` 全文作为 system/skill 上下文
- Produces: 通过/失败记录；若失败则回 Task 3 补洞后再测

- [x] **Step 1: 用 3 个 subagent，每人先读 `writing-weekly-report/SKILL.md`，再跑 Task 1 同款 Scenario A/B/C**

通过标准（全部满足才 PASS）：

- `1.` / `1.1.` 项目层级
- 强动词开头
- 无「下周计划」专节；进行中不装完成
- 按项目分桶，不按 commit 罗列
- 不声称已发飞书；最多询问是否发送

- [x] **Step 2: 记录结果到 `tests/verify-green.md`；若有新借口，在 SKILL.md 增加对应 Common mistakes / Red flags 后重跑失败场景**

---

### Task 5: README + 同步个人 skills

**Files:**
- Modify: `README.md`
- Install: 个人 skills via CLI

- [x] **Step 1: 更新根 README Skills 表与 install 示例，加入 `writing-weekly-report`**

- [x] **Step 2: 执行安装（网络权限）**

```bash
npx skills add xue7106211/allen-skills --skill writing-weekly-report
```

若远程尚无该 skill（未 push）：改为本地路径安装：

```bash
npx skills add /Users/mi/allen-skills --skill writing-weekly-report
```

- [x] **Step 3: 确认个人 skills 目录出现 `writing-weekly-report/SKILL.md`**

---

## Spec coverage (self-review)

| Spec 要求 | Task |
|---|---|
| 多源采集流程 | Task 3 |
| 只本周完成 | Task 2–4 |
| Markdown 默认 + 飞书门闩 | Task 1C/3/4 |
| TDD RED/GREEN | Task 1/3/4 |
| examples + SKILL.md | Task 2/3 |
| README + 个人同步 | Task 5 |
| 无采集脚本 | 全局不做 |

## Placeholder scan

无 TBD /「适当处理」类步骤。

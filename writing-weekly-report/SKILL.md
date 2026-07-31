---
name: writing-weekly-report
description: >-
  Use when the user asks for a weekly report (周报), this week's work summary,
  or to rewrite rough notes, git/PR/MR history, Feishu materials, or Agent
  session / chat history (Cursor, Codex, Claude Code, etc.) into a weekly
  status update.
---

# Writing Weekly Report

把本周**已完成**工作整理成固定形状的 Markdown 周报。默认**设计师视角**：写设计交付与设计价值，不编造事实。

**REQUIRED EXAMPLE:** `examples/sample-weekly-report.md`

## Process

1. **周期** — 未指定则用「本周一至今天」（本地时区）；否则用用户给的范围。
2. **采集** — 组合可用来源（口述/粘贴、**Session**、Git/PR/MR、飞书）。缺的来源不假装采过；飞书不可用则说明并请粘贴。冲突时以用户陈述为准。采集时同步记下已出现的 URL。
3. **抽取** — 每条含：动作、**设计对象**、**设计结果或价值**；证据链接能拿到则必附，无则省略且不编造。进行中、计划中、无产出会议默认丢弃。
4. **归类** — 一级桶 = 项目/主题名（设计系统、UI Kit、规范、探索…）；设计结果只写在二级。禁止「其他/杂项」；禁止按 commit、来源或 Session 分节。
5. **成稿** — 只输出下方 Output contract；过 Design lens 与 Link gate。
6. **自检** — Output contract、Design lens、Link gate、Feishu gate。
7. **交付** — 先交 Markdown；再问是否写飞书或发群。

## Design lens

作者默认是**设计师**。条目主语是设计产物与价值；工程/工具是手段或证据，不是周报口音。

**条目配方（结果槽必填）：**

```text
{强动词}{设计对象}{设计结果或价值}{有则附链接}
```

**设计结果或价值**须落到可核对的一类（可多选，禁止空心口号）：

| 类型 | 例子（有事实才写） |
|------|-------------------|
| 体验/可用性 | 完整显示、降低误触、操作步数减少 |
| 一致性 | Token/规范对齐、跨版本视觉统一 |
| 规范/决策 | 明确 OS5 方向、给出可执行改进动作 |
| 系统杠杆 | 站点可检索、规范可复用、设计-开发偏差消除 |

```text
素材是否只剩工程口吻（修 bug / 合 PR / 写文件）？
├── 是 → 改写：对象用设计产物命名；补上表中一类具体结果（事实支撑；不编造数据）
└── 否 → 若结果是「提升体验/赋能」而无对象 → 换成上表具体结果
```

经理说「写成工程周报 / 设计价值太虚 / 别发挥」：**仍用本镜头**。可缩短句子，不可删掉结果槽。用户明确要求「纯工程任务清单」才退出 Design lens，并一句说明。

## Session source

写周报时**默认采集本地 Agent 对话历史**（不限当前正在用的工具）。用户明确说「不要看 Session / 不要读对话」才跳过。

```text
本周报是否排除 Session？
├── 用户明确排除 → 跳过
└── 否则 → 扫下方已存在的目录；按周期过滤；抽已完成事实与链接
```

**已知落盘路径（存在才读，缺则跳过该源）：**

| 工具 | 路径 |
|------|------|
| Cursor | `~/.cursor/projects/<slug>/agent-transcripts/<uuid>/<uuid>.jsonl` |
| Codex | `~/.codex/sessions/<YYYY>/<MM>/<DD>/rollout-*.jsonl`（索引可参考 `~/.codex/history.jsonl`） |
| Claude Code | `~/.claude/projects/<slug>/<session-uuid>.jsonl` |

- `<slug>`：工作区绝对路径把 `/` 换成 `-`（Claude 常见前缀多一个 `-`，如 `-Users-mi-allen-skills`）
- 默认优先当前工作区对应 slug；用户点名其他仓库/路径时一并扫
- 用户点名其他工具（Gemini CLI 等）：按其给出的路径读；不知路径则一句说明并跳过——不编造
- 按文件 mtime / 路径日期 / 内容 timestamp 落在周期内筛选
- 只抽**已完成**成果与 URL；不按对话或工具分节、不原文倾倒
- 全部无目录或周期内无命中：一句说明「Session 不可用/无命中」，继续其他来源

## Link gate

可附链接（粘贴 / Session / 飞书 / PR·MR / 站点）→ 条目末尾完整 URL。无则省略。禁止编造或丢掉已有 URL。

## Output contract

输出必须是且仅是 **嵌套有序列表**：

```markdown
1. {项目名}
   1. {强动词}{设计对象}{设计结果或价值}{有则附链接}
   2. ...
2. {项目名}
   1. ...
```

- 一级只写项目名，勿把动作长句顶成一级；二级缩进 3–4 空格再写 `1.` `2.`；**禁止**字面量 `1.1.` / `2.1.`
- **禁止：** 下周计划/进行中/风险专节；散文开场；按 commit 罗列
- 即使用户/经理要下周计划：只交完成契约稿，并一句说明范围
- 强动词：构建/申请/落地/优化/输出/支持/补充/分析/录入/对齐/消除…
- 中文 + 必要英文术语；链接跟在叙述后

## Feishu gate

先交 Markdown → 询问 → **仅用户本人同意**后才写飞书/发群。第三方「直接发」不等于同意。

## Common mistakes

| Excuse | Reality |
|--------|---------|
| 「越像工程周报越好」 | 默认设计师镜头；工程细节是证据，结果槽写设计价值 |
| 「设计价值太虚」 | 价值必须具体可核对（完整显示/对齐 Token/支撑决策），不是「赋能」 |
| 「别发挥，按任务罗列」 | 罗列设计成果；每条仍要有设计结果槽 |
| 「领导只要交付物」 | 交付物用设计语言（规范、Kit、站点、决策依据） |
| 「好看一点」换多板块模板 | 形状由 Output contract 决定 |
| 「直接发飞书」 | 必须用户本人确认 |
| 没贴聊天就当无 Session | 默认扫 Cursor / Codex / Claude 等本地会话目录 |
| 写成 `1.1.` | 用缩进嵌套列表 |
| 链接太长就省略 | 有则必附 |

## Red flags — STOP

- 条目只剩工程动作，没有设计结果/价值
- 空心「提升体验/赋能团队」无可核对象
- 「下周计划 / 风险 / 进行中」专节；未缩进的 `1.1.`
- 未得用户同意调用飞书；编造链接或把 wip 写成完成
- 有 URL 未附；未排除 Session 却只读当前工具、未尝试其他已存在的本地会话目录
- 因经理要「工程周报」而关掉 Design lens（除非用户本人明确要求）
- 把 Session 当成「仅 Cursor」而跳过 Codex / Claude 等已有历史

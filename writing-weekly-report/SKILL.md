---
name: writing-weekly-report
description: >-
  Use when the user asks for a weekly report (周报), this week's work summary,
  or to rewrite rough notes, git/PR/MR history, Feishu materials, authorized
  ChatGPT conversations/tasks, or Agent session history (Cursor, Codex, Claude Code,
  Pi Agent, Grok Bot, Kiro, etc.) into a weekly status update.
---

# Writing Weekly Report

把本周**已完成**工作整理成固定形状的 Markdown 周报。默认**设计师视角**：写设计交付与设计价值，不编造事实。

**REQUIRED EXAMPLE:** `examples/sample-weekly-report.md`

## Process

1. **周期** — 未指定则用「本周一至今天」（本地时区）；否则用用户给的范围。
2. **采集** — 组合可用来源（口述/粘贴、**Session**、获授权的 ChatGPT 对话或任务、Git/PR/MR、飞书）。缺的来源不假装采过；飞书不可用则说明并请粘贴。冲突时以用户陈述为准。采集时同步记下已出现的 URL。
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
| Pi Agent | `~/.pi/agent/sessions/**/*.jsonl`（按首行 session header 的 `cwd` 归属工作区） |
| Grok Bot | `/Users/mi/Library/Application Support/Grok Bot/sand-client-persistence/<base32>.blob` |
| Kiro IDE | `/Users/mi/.kiro/sessions/<workspace-hash>/<session-uuid>/session.json` 与同目录 `messages.jsonl` |
| Kiro CLI | `/Users/mi/.kiro/sessions/cli/<session-uuid>.json` 与同名 `.jsonl`；另读 `/Users/mi/Library/Application Support/kiro-cli/data.sqlite3` 的 `conversations_v2` |

- Cursor / Claude 的 `<slug>`：工作区绝对路径把 `/` 换成 `-`（Claude 常见前缀多一个 `-`，如 `-Users-mi-allen-skills`）；Pi 不推测其编码目录名，递归扫描后以首行 `cwd` 为准
- Grok Bot：`<base32>` 为小写、无填充。只读解码后键为 `sand.client.slice.account.<account>.transcript.replicas.<agent-uuid>` 的 blob；同目录其余 `.blob` 是界面状态，不是对话。路径无工作区、无日期，不按仓库归类。时间在 JSON 内，Unix 毫秒（消息 `timestampMs`；roster 的 `createdAt` / `updatedAt` / `lastActivityAt`；副本 `value.persistedAt`）。roster 的 `path`（`/home/box/sand-data/agents/<agent-uuid>/store.db`）是远端 sandbox，不当作本机会话库
- Kiro IDE：`<workspace-hash>` 是 `session.json` 里 `workspacePaths[0]` 的 UTF-8 SHA-256 前 16 位十六进制，不以目录名臆测工作区。路径无日期；日期在 `session.json` 的 `createdAt` / `lastModifiedAt`（ISO-8601）。正文是 `messages.jsonl`。索引 `/Users/mi/.kiro/session-index/<workspace-hash>.jsonl` 不是正文
- Kiro CLI：路径无工作区、无日期；工作区是 `.json` 的 `cwd`，时间是 `created_at` / `updated_at`（ISO-8601）。`<session-uuid>/tasks/*.json` 是任务文件，不是聊天正文。SQLite 只读 `conversations_v2`（`key` 为工作区绝对路径，`conversation_id` 为 uuid，`created_at` / `updated_at` 为 Unix 毫秒）；同库 `history` 是 shell 历史，跳过
- 默认优先当前工作区对应 slug / `cwd`；用户点名其他仓库/路径时一并扫
- Pi 的会话目录可由 `--session-dir`、`PI_CODING_AGENT_SESSION_DIR` 或 `sessionDir` 覆写；只有已知或可发现的覆写目录才读，未知时不猜测
- 用户点名其他工具（Gemini CLI 等）：按其给出的路径读；不知路径则一句说明并跳过——不编造
- 按文件 mtime / 路径日期 / 内容 timestamp 落在周期内筛选
- Pi 的单一 JSONL 可含分支；跨分支只保留可确认的完成事实，并对重复事实去重
- 只抽**已完成**成果与 URL；不按对话或工具分节、不原文倾倒
- 全部无目录或周期内无命中：一句说明「Session 不可用/无命中」，继续其他来源

## ChatGPT conversation / task source

ChatGPT 对话和任务是**需用户明确授权**的内容源：用户说要纳入 ChatGPT、点名某个对话/任务，或提供其链接/内容时才读取。普通「写周报」请求不浏览 ChatGPT 列表或详情。

```text
用户是否明确授权 ChatGPT 对话或任务作为内容源？
├── 否 → 不读取 ChatGPT 列表或详情，继续其他来源
└── 是 → 先列出可访问的对话/任务，按周期、用户点名项目或路径选候选，再读候选详情
```

- **固定取证顺序：** `list_threads({limit: 50})` → 按周期、项目/路径筛候选 → `read_thread(..., turnLimit: 10)`。不能从标题或摘要直接跳到周报条目
- 聊天/任务的标题和摘要只用于筛选，**不能**据此认定完成成果；候选详情需要更早上下文时，再按返回的 cursor 翻页。只抽周期内可确认的已完成事实和 URL
- 不因任务仍在运行、标题像交付，或摘要提到计划，就把它写成完成；任务详情无法访问、无周期内命中或候选超过可读取范围时，说明覆盖边界，继续其他来源
- 仍按项目/主题归类，不能按 ChatGPT 对话或任务分节；不发消息、不创建任务、不改动原对话

## Link gate

可附链接（粘贴 / Session / ChatGPT 对话或任务 / 飞书 / PR·MR / 站点）→ 条目末尾完整 URL。无则省略。禁止编造或丢掉已有 URL。

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
| 没贴聊天就当无 Session | 默认扫 Cursor / Codex / Claude / Pi Agent / Grok Bot / Kiro 等本地会话目录 |
| 用户未授权就扫描 ChatGPT | ChatGPT 对话/任务仅在明确授权后才从列表筛选并读取详情 |
| 写成 `1.1.` | 用缩进嵌套列表 |
| 链接太长就省略 | 有则必附 |

## Red flags — STOP

- 条目只剩工程动作，没有设计结果/价值
- 空心「提升体验/赋能团队」无可核对象
- 「下周计划 / 风险 / 进行中」专节；未缩进的 `1.1.`
- 未得用户同意调用飞书；编造链接或把 wip 写成完成
- 有 URL 未附；未排除 Session 却只读当前工具、未尝试其他已存在的本地会话目录
- 未经明确授权读取 ChatGPT 对话/任务，跳过固定取证顺序，或把任务标题/摘要当成完成证据
- 因经理要「工程周报」而关掉 Design lens（除非用户本人明确要求）
- 把 Session 当成「仅 Cursor」而跳过 Codex / Claude / Pi Agent / Grok Bot / Kiro 等已有历史，或按 Pi 的目录名、Kiro 的 hash 臆测工作区

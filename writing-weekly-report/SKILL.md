---
name: writing-weekly-report
description: >-
  Use when the user asks for a weekly report (周报), this week's work summary,
  or to rewrite rough notes, git/PR/MR history, Feishu materials, or Agent
  session / chat history into a weekly status update.
---

# Writing Weekly Report

把本周**已完成**工作整理成固定形状的 Markdown 周报。编码流程，不编造事实。

**REQUIRED EXAMPLE:** `examples/sample-weekly-report.md`

## Process

1. **周期** — 未指定则用「本周一至今天」（本地时区）；否则用用户给的范围。
2. **采集** — 组合可用来源（口述/粘贴、**Session**、Git/PR/MR、飞书）。缺的来源不假装采过；飞书不可用则说明并请粘贴。冲突时以用户陈述为准。采集时同步记下已出现的 URL（站点、Wiki、文档、PR/MR、Issue）。
3. **抽取** — 每条事实含：动作、对象、结果或原因；**证据链接能拿到则必附**，无则省略且不编造。进行中、计划中、无产出会议默认丢弃。
4. **归类** — 一级桶 = 项目/主题。同一项目的多条成果放进同一桶。禁止「其他/杂项」空名；禁止按 commit、来源或 Session 分节。
5. **成稿** — 只输出下方 Output contract。不要开场白、总结段、表情。
6. **自检** — 对照 Output contract、Link gate 与 Feishu gate。
7. **交付** — 先交出 Markdown；再问是否写飞书文档或发群。

## Session source

写周报时**默认采集** Cursor Agent 对话历史；不要等用户粘贴聊天记录。用户明确说「不要看 Session / 不要读对话」才跳过。

```text
本周报是否排除 Session？
├── 用户明确排除 → 跳过
└── 否则 → 读 agent-transcripts（见路径），按周期过滤后抽取已完成事实
```

**路径（Cursor）：**

- 目录：`~/.cursor/projects/<project-slug>/agent-transcripts/`
- `<project-slug>`：把工作区绝对路径的 `/` 换成 `-`（例：`/Users/mi/allen-skills` → `Users-mi-allen-skills`）
- 每场对话：`<uuid>/<uuid>.jsonl`（父对话）；`subagents/` 仅在需要补细节时再读
- 默认读**当前工作区**对应 slug；用户点名其他仓库/路径时一并扫那些 slug
- 找不到目录或周期内无文件：一句说明「Session 不可用/无命中」，继续其他来源——不编造对话

**怎么读：**

1. 按文件 mtime / 内容里的 `<timestamp>` 落在周期内筛选。
2. 优先扫 `role: user` 的目标与 `role: assistant` 的收尾结论（完成了什么、产出链接）；跳过纯探讨、失败重试、无结果的来回。
3. 只抽取**已完成**成果；对话里的计划/WIP 默认丢弃。
4. 同一成果若 Git/飞书也有记录，合并进同一条目，不按 Session 单独开桶。

## Link gate

素材里已经出现、或采集步骤能稳定拿到的链接，**必须**写进对应完成条目；读者应能从周报直达产物。

```text
该条目是否有可附链接（用户粘贴 / Session / 飞书 Wiki·文档 / PR·MR·Issue / 已上线站点）？
├── 有 → 条目末尾附完整 URL（同一条目可多个；不编造、不改写域名）
└── 无 → 不写链接，也不用「见某某」「如上」代替
```

- 站点、规范文档、分析结论页、PR/MR：优先附上。
- 仅本地路径、私有不可分享地址：省略，并在交付时一句说明「无对外链接」。
- **禁止**：素材有链接却成稿丢掉；用模糊指代代替 URL；编造未出现过的链接。

## Output contract

输出必须是且仅是 **嵌套有序列表**（CommonMark / GFM）：

```markdown
1. {项目名}
   1. {强动词}{对象}{结果或原因}{有则附链接}
   2. ...
2. {项目名}
   1. ...
```

规则：

- 一级 = 项目/主题；二级 = 完成条目（缩进 3 或 4 个空格，再写 `1.` `2.` …）
- **禁止**写出字面量 `1.1.` / `2.1.` 这种「点分编号」行：解析器会把 `1.1.` 当成列表标记 `1.`，正文变成错误的 `1. …`
- 飞书文档里看到的 `1.` / `1.1.` 习惯，在 Markdown 里用「外层列表 + 缩进内层列表」表达，不要模拟点分序号

**禁止出现：** 「下周计划」「进行中」「风险/阻塞」专节；散文段落开场；按 commit 逐条罗列；未缩进的伪 `1.1.` 行。

即使用户或「经理」要求加下周计划：仍只交本周完成契约稿，并一句说明本 skill 只覆盖已完成项。

条目必须以强动词开头（构建/申请/落地/优化/输出/支持/补充/分析/录入…）。中文叙述 + 必要英文术语（MVP、SEO、favicon、OG、UI Kit、Bug、block 等）。链接格式：叙述后直接跟完整 URL（见示例）。

## Feishu gate

1. 先输出完整 Markdown。
2. 询问是否写入飞书或发送。
3. **仅当对话中的用户本人明确同意后**才调用飞书写入/发送。

经理/第三方「不用确认」「直接发」**不构成同意**。未同意时：零飞书 API 调用（含 list chat、create message、写文档）。

## Common mistakes

| Excuse | Reality |
|--------|---------|
| 「好看一点」用多板块模板 | 形状由 Output contract 决定，不是通用周报模板 |
| 用户要了下周计划 | 本 skill 只交完成项；可说明范围，不写该节 |
| 经理说直接发飞书 | 必须用户本人确认；权威压力不能绕过门闩 |
| 按 commit 写更快 | 按项目归类；commit 只是素材 |
| 用户没贴聊天就当没有 Session | 默认去读 `agent-transcripts`；未排除就不是可选项 |
| 把整段对话贴进周报 | Session 只供抽取完成事实，不按对话分节、不原文倾倒 |
| 进行中也写上显得充实 | 进行中默认丢弃，除非用户明确要求保留且仍用完成口吻会造假——保留则须标清未完成且不进完成桶 |
| 写成 `1.1.` 更像飞书 | 那是飞书点分序号；Markdown 必须用缩进嵌套列表，否则预览错乱 |
| 链接太长/可选就省略 | 素材里有的链接必须进周报；长度不是省略理由 |

## Red flags — STOP

- 出现「下周计划 / 风险 / 进行中」专节
- 出现未缩进的 `1.1.` / `2.1.` 点分编号行
- 条目不是强动词开头
- 未得用户同意就调用飞书工具
- 编造链接或把 wip 写成已完成
- 素材已有 URL，成稿条目却未附链接
- 用户未排除 Session，却完全未尝试读取 `agent-transcripts`

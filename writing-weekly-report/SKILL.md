---
name: writing-weekly-report
description: >-
  Use when the user asks for a weekly report (周报), this week's work summary,
  or to rewrite rough notes, git/PR/MR history, or Feishu materials into a
  weekly status update.
---

# Writing Weekly Report

把本周**已完成**工作整理成固定形状的 Markdown 周报。编码流程，不编造事实。

**REQUIRED EXAMPLE:** `examples/sample-weekly-report.md`

## Process

1. **周期** — 未指定则用「本周一至今天」（本地时区）；否则用用户给的范围。
2. **采集** — 只用用户实际提供的来源（口述/粘贴、Git/PR/MR、飞书）。
3. **抽取** — 每条事实含：动作、对象、结果或原因；证据有则必附，无则省略且不编造。进行中、计划中、无产出会议默认丢弃。
4. **归类** — 一级桶 = 项目/主题。同一项目的多条成果放进同一桶。禁止「其他/杂项」空名；禁止按 commit 或来源分节。
5. **成稿** — 只输出下方 Output contract。不要开场白、总结段、表情。
6. **自检** — 对照 Output contract 与 Feishu gate。
7. **交付** — 先交出 Markdown；再问是否写飞书文档或发群。

## Output contract

输出必须是且仅是 **嵌套有序列表**（CommonMark / GFM）：

```markdown
1. {项目名}
   1. {强动词}{对象}{结果或原因}{可选链接}
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

条目必须以强动词开头（构建/申请/落地/优化/输出/支持/补充/分析/录入…）。中文叙述 + 必要英文术语（MVP、SEO、favicon、OG、UI Kit、Bug、block 等）。有链接则附上。

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
| 进行中也写上显得充实 | 进行中默认丢弃，除非用户明确要求保留且仍用完成口吻会造假——保留则须标清未完成且不进完成桶 |
| 写成 `1.1.` 更像飞书 | 那是飞书点分序号；Markdown 必须用缩进嵌套列表，否则预览错乱 |

## Red flags — STOP

- 出现「下周计划 / 风险 / 进行中」专节
- 出现未缩进的 `1.1.` / `2.1.` 点分编号行
- 条目不是强动词开头
- 未得用户同意就调用飞书工具
- 编造链接或把 wip 写成已完成

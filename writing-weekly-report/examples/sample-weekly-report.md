# 周报示例（表达习惯黄金样本）

Markdown 用嵌套有序列表表达飞书里的 `1.` / `1.1.` 层级（不要写字面量 `1.1.`）。
有站点 / Wiki / 文档 / PR 等链接时，写在对应条目末尾（见下方带 URL 的条目）。

## 参考 1
1. HyperOS Design System
   1. 构建了设计系统网站初版 MVP：https://hyperos-design.mioffice.cn/
   2. 申请了服务器与域名，用于网站在小米内网正式上线
   3. 落地了 OS4 / OS5 版本切换
   4. 支持了可视化编辑与自定义 block
   5. 录入了基于 Kim 确定的规范范围的文档初版结构
   6. 补充了站点中文 SEO、favicon 与 OG
2. OS4 UI Kit
   1. 优化了 DatePicker 大字号截断 Bug，高度改为自适应，保证完整显示
3. 2026 设计系统 AI&工程化 方向探索
   1. 分析了 OS4 的 1500+ issues，明确体检表中可归因的问题：https://mi.feishu.cn/wiki/CJZbwKtF3iWcQNkhd2dc8AVPn5g
   2. 输出了 HyperOS 设计标准细则，并给出 OS5 改进动作：https://mi.feishu.cn/wiki/GdNWwBvzQihjPokezQ3cqnMlnVf

## 参考 2
- Design System 网站 [https://hyperos-design.mioffice.cn]
  - 接入了 OS4 Figma Design Token，并支持 Light / Dark 预览
  - 对齐了首页导航与侧栏分类，并精简图标库复制操作
  - 上线了 OS4 抽屉浮窗规范页与配图
- HyperOS 设计规范 [https://mi.feishu.cn/wiki/DWUkw4EVEi74YQknaO6cBN36n5c]
  - 完成了抽屉浮窗规范
  - 收集了 HyperOS 主要抽屉手柄场景，以及 Apple、鸿蒙的手柄隐藏/显示做法，支撑 OS5 抽屉隐藏手柄化
  - 开始新的组件规范：列表，目前进度 30% 左右
- 设计工程化 [https://github.com/xue7106211/hyperos-design-guidline]
  - 构建并优化了 HyperOS 规范撰写助手 Skill
  - 落地了规范写手五章骨架结构（基于 Kim 撰写的设计规范通用示例）
  - 将 OS3 或更早版本的设计规范更新为新的 HyperOS 场景规范
  - 输出标准 Markdown，方便后续渲染到 Fumadocs / MDX 文档站
- UI Kit
  - 修正了近手浮窗安全边距：设计规则为 24，MIUIX 代码侧重复计算两侧安全边距导致偏差

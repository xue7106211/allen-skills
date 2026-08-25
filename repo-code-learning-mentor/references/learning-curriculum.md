# 代码学习提纲

这份参考来自用户提供的 Notion 页面「代码基础」，用于对齐学习方向、前置知识和主题优先级；它不是当前仓库的事实清单，也不是每次课程都要完整覆盖的 syllabus。

来源：<https://app.notion.com/p/3c655e17a9b480ce8fddd5ed3c556620>（读取于 2026-08-25）

## 学习目标

用户的目标不是先成为“完整前端工程师”再做设计工程，而是围绕真实工作任务逐步建立代码理解能力。学习应优先连接到：

- 真实组件、页面、设计系统和 AI Coding 任务
- 设计 Token、组件元数据、Figma → Code 和规范验收
- 能读懂、修改、验证代码，而不是只记忆 API

## 主题范围

### HTML

- DOM
- 语义化 HTML

### CSS 与界面实现

- 选择器、层叠与优先级
- Flexbox、Grid
- CSS Variables 与 Design Token
- hover、active、focus、disabled 等交互状态
- Transition、Animation 与基础动效
- 深浅色模式和不同设备适配

### React

- JSX 与组件
- Props（外部传入的组件属性）
- State（组件内部的运行时状态）
- 事件处理
- 条件渲染与列表渲染
- 渲染、重新渲染与副作用
- 状态提升与组件通信
- `useState`、`useEffect`、`useRef`

### JavaScript

- 变量、字符串、数字、布尔值、对象、数组、`null`、`undefined`
- 运算符、条件判断、循环
- 参数、返回值、箭头函数、回调函数
- 作用域与闭包
- 解构、展开运算符、`map`、`filter`、`find`、`some`、`reduce`
- 值与引用、浅拷贝、不可变更新
- 模板字符串、可选链、空值合并
- Promise、`async / await`
- `try / catch / finally` 与主动抛错
- `import / export`
- 浏览器事件对象、冒泡、捕获、事件委托

### TypeScript

- 基础类型、数组、对象和函数类型
- `interface` 与 `type`
- Union Type（联合类型）
- Optional Property（可选属性）
- Type Narrowing（类型收窄）
- 泛型
- API 数据类型
- React Props、事件和状态类型
- 类型断言的风险

### 工程与运行环境

- Node.js 与浏览器运行环境的区别
- npm / pnpm 与依赖管理
- `package.json`
- Vite 等开发与构建工具
- 项目目录与模块边界
- `components/`、`hooks/`、`api/`、`utils/`、`lib/` 的职责
- 环境变量与开发、生产环境
- Git 基本工作流
- 浏览器 DevTools 与断点调试
- ESLint、格式化、类型检查
- 构建、部署和基础测试

## 与仓库学习地图的关系

生成学习地图时，使用下面的优先级：

1. **真实仓库证据优先**：只有仓库里有对应文件、配置、脚本或行为，才能把它列为当前项目主题。
2. **用户提纲决定解释视角**：同一个仓库主题，优先用用户正在建立的基础概念解释，例如把 CSS Variables 连接到 Design Token，把 props 连接到组件属性。
3. **前置知识按需补足**：只有当前主题确实依赖某个 JS/HTML/CSS/TS 概念时才补讲，不为了“覆盖提纲”而开新课。
4. **工作任务优先于完整覆盖**：优先选择能帮助用户读懂、修改或验收当前项目的主题。
5. **未发现能力必须标明**：提纲中的主题如果没有仓库证据，只能作为后续迁移学习建议，不能伪装成项目现状。

## 推荐学习顺序

这不是强制路线，而是缺少项目优先级时的默认依赖关系：

```text
HTML / DOM + CSS 布局与状态
          ↓
JavaScript 数据、函数、模块与异步
          ↓
React 组件、Props、State、事件与副作用
          ↓
TypeScript 数据和组件约束
          ↓
Node / 包管理 / 构建 / 调试 / 测试
          ↓
Design Token、组件治理、Figma → Code、自动验收
```

实际教学可以从真实任务切入，再回补前置知识。例如先读一个按钮组件，再补 Props、State、事件、CSS 状态和类型，而不是先按语言章节顺序讲完所有内容。

## 暂不作为当前主线的内容

除非用户明确提出或仓库确有相关任务，暂不把算法刷题、纯后端、高并发、复杂数据库、底层语言和从零造框架设为默认学习路线。这不是否定它们的价值，而是保持当前设计工程学习目标的投入产出比。

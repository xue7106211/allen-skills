---
name: sync-repo-docs
description: Audits and synchronizes repository documentation, cross-file references, and dependency or command descriptions against package.json and the actual codebase. Use when the user asks to update README, AGENTS.md, docs/index.md, fix stale doc links, align npm scripts, or run a global documentation and reference dependency sync.
---

# 全局文档与引用依赖同步

对当前仓库做一次全局文档与引用依赖更新，重点检查并同步以下内容：

## 1. 更新仓库内所有文档引用

- README.md
- AGENTS.md / agents.md
- index.md
- docs 目录下相关文档
- 其他与项目说明、使用方式、依赖说明、开发流程相关的 Markdown 文件

## 2. 检查并修正过期引用

- 已废弃的文件路径
- 旧的命令说明
- 旧的包名、模块名、组件名
- 旧的目录结构说明
- 不再存在的脚本、环境变量、配置项

## 3. 同步依赖与运行方式

- 根据当前 package.json / pnpm-lock.yaml / yarn.lock / package-lock.json 更新安装、启动、构建、测试命令
- 检查 README 中的依赖说明是否与实际项目一致
- 如发现无效依赖、重复依赖或文档中提到但项目未使用的依赖，请标注并修正

## 4. 保持文档一致性

- README、AGENTS、index.md 等文件中的项目描述、技术栈、目录结构、开发流程需要保持一致
- 如果多个文档存在重复说明，请统一措辞，避免冲突
- 不要引入没有在代码中实际体现的新能力或新描述

## 5. 输出要求

- 先扫描项目结构和核心配置文件，再修改文档
- 修改前请判断每处内容是否仍然准确
- 只修改与文档、引用、依赖说明相关的内容
- 不要重构业务代码
- 不要删除不确定用途的文件
- 修改完成后，请总结：
  - 更新了哪些文件
  - 修复了哪些过期引用
  - 哪些地方仍需要人工确认

---

## 执行流程

### Phase 1：扫描（先读再改）

1. 读取 `package.json` 与锁文件（`package-lock.json` / `pnpm-lock.yaml` / `yarn.lock`），确认包管理器与 scripts。
2. 列出 `docs/`、`scripts/`、`data/` 下所有 `*.md` 与 `index.md`（若存在）。
3. 对照 `src/`、`scripts/` 实际目录，核对 AGENTS / README 中的文件树。
4. 用搜索检查文档中的路径、npm 命令、组件名、环境变量是否在仓库中存在。

### Phase 2：权威来源（冲突时以此为准）

| 类型 | 权威来源 |
|------|----------|
| npm 命令 | `package.json` → `scripts` |
| 依赖与技术栈 | `package.json` → `dependencies` / `devDependencies` |
| 页面路由与组件 | `src/app/`、`src/components/`（或项目实际前端目录） |
| 数据读取 | 项目约定的读取门面（如 `src/lib/*-api.ts`） |
| 文档索引 | `docs/index.md`（若有） |
| Agent 约定 | `AGENTS.md` / `CLAUDE.md`（若有） |

### Phase 3：必改项检查清单

```
- [ ] README / AGENTS / docs/index.md 技术栈与命令一致
- [ ] AGENTS 文件树与 src、scripts、docs 实际结构一致
- [ ] docs/index.md「按任务选读」与「文档目录」覆盖现有专题文档
- [ ] 文档内相对链接指向存在的 .md 文件
- [ ] 环境变量：.env.example 与 README/AGENTS/配置文件描述一致
- [ ] 未实现的脚本在文档中标注为 draft / 规划中，不写进 package.json 假象
- [ ] 页面行为、API、读取层描述与代码实现一致
```

### Phase 4：修改原则

- 优先更新 **索引层**（`docs/index.md`、`AGENTS.md` 文档表、README 文档表），再改专题文档。
- 同一事实在多处出现时，用 **同一句措辞**。
- 文件名保持项目既有约定（本仓库 docs 用英文 kebab-case）；不擅自重命名 docs 文件（除非用户明确要求）。

### Phase 5：完成报告模板

```markdown
## 文档同步报告

### 更新的文件
- ...

### 修复的过期引用
- ...

### 仍需人工确认
- ...
```

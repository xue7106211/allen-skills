# allen-skills

Allen 的 Agent Skills monorepo。每个子目录是一个独立 skill，可用 Skills CLI 按需安装。

## Skills

| Directory | Name | 说明 |
|---|---|---|
| `design-clone/` | `design-clone` | 高保真网页复刻（Design DNA + Surface Recon） |
| `sync-repo-docs/` | `sync-repo-docs` | 仓库文档与引用依赖全局同步 |
| `frontend-code-learning/` | `frontend-code-learning` | 设计师转型设计工程师的前端/AI Coding 学习讲解 |
| `repo-code-learning-mentor/` | `repo-code-learning-mentor` | 以真实仓库为教材的学习地图与循序讲解 |

### Related

- `frontend-code-learning` ↔ `repo-code-learning-mentor`：前者讲概念与机制，后者带你吃透某个具体仓库。

## Install

```bash
# 列出仓库内 skill
npx skills add xue7106211/allen-skills -l

# 安装全部
npx skills add xue7106211/allen-skills --all

# 按需安装
npx skills add xue7106211/allen-skills --skill design-clone sync-repo-docs
npx skills add xue7106211/allen-skills --skill frontend-code-learning repo-code-learning-mentor
```

## Legacy repos

以下独立仓库仍保留，但不再更新；请改用本 monorepo：

- https://github.com/xue7106211/design-clone
- https://github.com/xue7106211/sync-repo-docs
- https://github.com/xue7106211/skill-learn-repo

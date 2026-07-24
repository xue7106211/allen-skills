# 提交安全检查表

在暂存和提交前检查所有 changed / untracked 路径。此表用于风险识别，不代表匹配项一定有问题。

## 1. 高风险：停止并报告

### 常见秘密文件

- `.env`、`.env.*`（通常只有明确的 `.env.example` / `.env.template` 可候选提交）
- `*.pem`、`*.key`、`*.p12`、`*.pfx`、`*.jks`、`*.keystore`
- `id_rsa`、`id_ed25519`、SSH/GPG 私钥
- `credentials.*`、`secrets.*`、`service-account*.json`
- 云厂商、Terraform、Kubernetes、npm、PyPI、Docker 等包含认证信息的本地配置

### 内容风险

- API key、access token、refresh token、password、client secret
- GitHub/GitLab token、云厂商密钥、数据库连接串
- `-----BEGIN ... PRIVATE KEY-----`
- 含用户名或 token 的 remote URL

只报告路径和风险类别，例如：`config/local.env：疑似访问令牌`。不要输出匹配值。真实秘密不得提交；建议移出变更、加入 ignore，并提醒用户轮换已暴露凭据。

## 2. 需确认：可能敏感或无关

- `.env.example`、测试凭据、fixture、证书、公钥
- 用户数据导出、数据库 dump、生产日志、抓包文件
- 包含邮箱、电话、地址、内部 URL 的数据
- 大型二进制、压缩包、模型、媒体资源
- `package-lock.json`、`pnpm-lock.yaml`、`yarn.lock` 与依赖清单不一致
- 自动生成代码、构建产物、迁移快照

确认它们是否为当前主题所需，并检查值是否经过脱敏。

## 3. 通常排除的噪声

- `.DS_Store`、`Thumbs.db`
- `*.log`、临时文件、swap、backup
- `node_modules/`、`dist/`、`build/`、coverage、缓存目录（仓库明确追踪的除外）
- IDE/编辑器个人配置
- 调试打印、临时注释、测试截图、一次性脚本
- 与本次目标无关的全文件格式化或排序

## 4. Diff 完整性

检查：

- 冲突标记：`<<<<<<<`、`=======`、`>>>>>>>`
- 意外删除、权限位变化、文件重命名
- 子模块指针变化
- 换行符导致的整文件变更
- 只改生成物却漏掉源文件，或反之
- 测试/文档是否与行为变更相符

## 5. 扫描边界

- 优先使用仓库已有 secret scanner（如 gitleaks、detect-secrets）及其既有配置，但不要擅自安装依赖。
- 无现成 scanner 时，用文件名、diff 和有限模式做检查；不要声称完成了全面秘密扫描。
- 不扫描 `.git/` 历史或仓库外文件，除非用户明确要求。

# v0.3 发布检查表

## 1. 发布目标

v0.3 的发布目标是把 SoloSpec 从“文档规范 + TDD 流程”升级为“独立开发者虚拟团队编排器”。

发布前必须证明：

- 支持多 Agent host 安装和检测。
- 专家契约升级为中文可读 + `machine` 可消费结构。
- 产品、调研、UX、架构、TDD、实现、QA、发布都是一等阶段。
- UI 高保真源稿是 HTML，不是 PNG。
- 内置专家可阶段内参与；外部未知 Skill 只在用户指定时适配。
- 四分支回归通过。

## 2. 必须完成的实现项

| 项目 | 状态 |
|---|---|
| Host adapter registry | 已完成 |
| 安装脚本 `-Host` / `auto` / `generic` / `-ListHosts` | 已完成 |
| 旧 `-Tool zcode` 兼容 | 已完成 |
| 主 Skill host-aware 专家检测 | 已完成 |
| Expert Packet v2 | 已完成 |
| 六个专家 Skill 输出样例升级 | 已完成 |
| Workflow 增加 `research` 和全阶段一等规则 | 已完成 |
| 架构模板增加 UI 基础设施、复用、部署、回滚、门禁 | 已完成 |
| 设计模板改为 SVG 线稿 + 高保真 HTML | 已完成 |
| TDD 模板增加覆盖范围和实现偏差 | 已完成 |
| Bugfix 模板增加根因和回归边界 | 已完成 |
| 全阶段模板增加研究核验、专家增强记录和门禁落点 | 已完成 |
| 多轮子代理与最终发布回归 | 已完成 |
| GitHub 提交和推送 | 由本次发布提交完成 |

## 3. 必须通过的验证

| 验证 | 证据 |
|---|---|
| Host adapter 安装回归 | `docs/verification/v0.3/01-host-adapter-install-test.md` |
| Expert Packet v2 契约回归 | `docs/verification/v0.3/02-expert-packet-v2-contract-test.md` |
| 全阶段流程与模板回归 | `docs/verification/v0.3/03-workflow-and-template-v3-test.md` |
| 多轮子代理回归 | `docs/verification/v0.3/04-multi-round-subagent-regression.md` |
| 最终发布回归 | `docs/verification/v0.3/05-final-release-regression.md` |

## 4. 发布前命令

发布前至少执行：

```powershell
git diff --check
.\scripts\install-project-skills.ps1 -ListHosts
```

并验证：

- 7 个 Skill 均有 `SKILL.md`。
- 7 个 Skill 的 `name` 与目录名一致。
- 6 个专家 Skill 都包含 `machine` 和 v0.3 modes。
- `scripts/host-adapters.json` 可解析。
- `templates/solo/config.json` 和内置模板配置可解析。
- 当前规则文档不再把 PNG 定义为高保真源稿。
- 当前规则文档不再把外部未知 Skill 定义为自动调用对象。

## 5. 不可发布条件

任一情况出现时不得发布：

- 只验证了安装，没有验证四分支流程。
- 只验证了 UI/UX，没有验证产品、调研、架构、TDD、QA 和发布。
- 子代理回归只跑一轮且没有覆盖失败路径。
- Trae / zcode 未验证路径被写成 confirmed。
- 专家输出仍只有英文机器字段，没有中文可读摘要。
- 发现断链、JSON 解析失败或 `git diff --check` 出现空白错误。

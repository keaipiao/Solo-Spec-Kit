# v0.2 发布检查表

## 1. 发布结论

v0.2 达到项目级试用分发标准。

当前版本支持：

- 基础安装：只安装 `solo-spec` 主 Skill。
- 增强安装：安装 `solo-spec` 和六个 `solo-spec-*` 专家 Skill。
- 一个入口：普通用户只使用 `/solo`。
- 可选专家建议：主流程可建议专家审查，但不默认自动调用。
- 降级运行：未安装专家时，主流程继续使用基础规则。

## 2. Skill 清单

| Skill | 状态 |
|---|---|
| `solo-spec` | 已完成 |
| `solo-spec-product` | 已完成 |
| `solo-spec-ux` | 已完成 |
| `solo-spec-architecture` | 已完成 |
| `solo-spec-tdd` | 已完成 |
| `solo-spec-qa` | 已完成 |
| `solo-spec-release` | 已完成 |

## 3. 核心规则

| 规则 | 状态 |
|---|---|
| 公开入口只有 `/solo` | 已确认 |
| 用户项目事实源统一为 `solo/` | 已确认 |
| 新项目前置文档和迭代前置文档解耦 | 已确认 |
| SDD/TDD 阶段使用统一规格目录 | 已确认 |
| 调研按阶段触发，不创建固定 `research.md` | 已确认 |
| 技术栈按需求触发扩展，不展示未采用层 | 已确认 |
| 专家 Skill 独立可用 | 已确认 |
| 接入 `/solo` 时专家只输出 expert packet | 已确认 |
| 专家不写文件、不改状态机、不通过门禁 | 已确认 |
| 未安装专家时主流程降级继续 | 已确认 |

## 4. 验证证据

| 证据 | 结论 |
|---|---|
| `docs/11-solo-spec-ux-blackbox-test.md` | UX 专家通过黑盒测试 |
| `docs/12-solo-spec-product-blackbox-test.md` | 产品专家通过黑盒测试 |
| `docs/13-solo-spec-architecture-blackbox-test.md` | 架构专家通过黑盒测试 |
| `docs/14-solo-spec-tdd-blackbox-test.md` | TDD 专家通过黑盒测试 |
| `docs/15-solo-spec-qa-blackbox-test.md` | QA 专家通过黑盒测试 |
| `docs/16-solo-spec-release-blackbox-test.md` | Release 专家通过黑盒测试 |
| `docs/17-expert-skills-integration-smoke-test.md` | 专家 Skill 集成烟测通过 |
| `docs/18-expert-skills-forward-test.md` | 真实子代理黑盒调用通过 |
| `docs/21-expert-integration-e2e-test-report.md` | 专家接入端到端验收通过 |
| `docs/22-main-skill-expert-suggestion-smoke-test.md` | 主 Skill 降级烟测通过 |
| `docs/23-blind-forward-expert-suggestion-test.md` | 独立子代理盲测通过 |
| `docs/24-v02-distribution-installation-test.md` | v0.2 分发安装验收通过 |
| `docs/26-install-script-test.md` | 项目级安装脚本验收通过 |
| `docs/27-four-branch-regression-test.md` | 四分支回归测试通过 |

## 5. 用户文档

| 文档 | 状态 |
|---|---|
| `README.md` | 已新增 |
| `docs/07-user-guide.md` | 已更新为 v0.2 用户说明 |
| `docs/02-user-project-structure.md` | 已定义最终用户项目结构 |
| `docs/03-skill-execution-rules.md` | 已定义 `/solo` 执行规则 |
| `docs/05-state-machine.md` | 已定义四分支状态机 |
| `docs/06-expert-contract.md` | 已定义专家契约 |

## 6. 已知限制

- v0.2 仍以本地项目级复制安装为主，没有提供安装脚本。
- v0.2 已做盲测和 E2E 验收，但还没有真实长期用户项目使用记录。
- 专家建议层已接入主 Skill，但复杂专家调用仍依赖宿主环境是否能发现项目级 `.agents/skills`。
- 当前 README 只覆盖最小分发说明，详细规则仍以 `docs/` 为准。

## 7. 发布前命令

提交前至少执行：

```text
git diff --check
```

并校验：

- 7 个 Skill 均有 `SKILL.md`。
- `SKILL.md` 的 `name` 与目录名一致。
- `description` 非空。
- `references/*` 链接存在。
- `agents/openai.yaml` 存在。
- 文档中没有未解释的 v0.1-alpha 旧表述。

## 8. 下一版本建议

v0.3 可优先处理：

- 增加复杂 UI 和后端鉴权案例。
- 增加专家调用后的 artifact writer 自动消费样例。
- 评估是否需要版本号文件或变更日志。

项目级安装脚本已提前完成，见 `scripts/install-project-skills.ps1` 和 `docs/26-install-script-test.md`。
四分支回归测试已提前完成，见 `docs/27-four-branch-regression-test.md`。

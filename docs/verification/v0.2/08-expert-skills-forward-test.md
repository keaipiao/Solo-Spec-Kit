# 专家 Skill 真实黑盒调用测试

测试日期：2026-07-04

## 1. 测试目标

用全新子代理分别调用主 `solo-spec` 和六个专家 Skill，验证真实输出是否遵守：

- 不直接写文件。
- 不推进 `solo-spec` 状态机。
- 不通过门禁。
- 输出能映射到 SoloSpec 标准章节。
- 专家只处理自己阶段的专业判断。

子代理只收到 Skill 路径和一条用户式任务，没有收到本项目的预期答案。

## 2. 测试结果

| 对象 | 场景 | 结论 |
|---|---|---|
| `solo-spec` | 现有 React 工具新增 CSV 导入 | 通过。正确判断为 `iteration`，先复述、列假设、问一个阻塞问题，未写文件。 |
| `solo-spec-product` | 新项目方向不清晰 | 通过。停留在 `new-project / brainstorm`，只给选项和门禁，不写项目基线。 |
| `solo-spec-ux` | taste 高保真文件不可检查 | 通过。因资产不可检查而阻塞，未把外部设计写入项目基线。 |
| `solo-spec-architecture` | Spring Boot 邮箱登录、角色、会话、审计日志 | 需修正后通过。架构层触发判断正确，但输出把未实际联网核验的内容写成“官方核实依据”。 |
| `solo-spec-tdd` | 倒计时过期仍可提交的 Bugfix 回归测试 | 通过。要求先补接口层 expired 回归测试，再进入最小修复。 |
| `solo-spec-qa` | CSV 导入 QA 证据登记 | 需澄清后通过。写入目标和资产登记正确，但 `gate.required: false` 容易被误解成 QA 门禁已过。 |
| `solo-spec-release` | 导出功能归档，外部建议 tag/deploy | 通过。拒绝 `release-notes/`、tag、部署，把发布状态留在待用户确认。 |

## 3. 修复项

### 3.1 架构专家官方核验

问题：

架构专家在未实际核验官方来源的情况下写出“官方核实依据”和官方链接，容易让主流程误判事实已确认。

修复：

- [skills/solo-spec-architecture/SKILL.md](../../../skills/solo-spec-architecture/SKILL.md) 明确：只有当前运行实际检查官方来源时，才允许写“官方已核验”。
- [skills/solo-spec-architecture/references/architecture-contract.md](../../../skills/solo-spec-architecture/references/architecture-contract.md) 明确：未核验时只能写成风险、待核验任务或门禁问题。

### 3.2 QA 专家门禁语义

问题：

QA 专家可以判断“无阻塞 QA 问题”，但不能让人误解为 `solo-spec` QA 门禁已经通过。

修复：

- [skills/solo-spec-qa/SKILL.md](../../../skills/solo-spec-qa/SKILL.md) 明确：`gate.required: false` 只表示专家未发现阻塞，不表示 SoloSpec 门禁已通过。
- [skills/solo-spec-qa/references/qa-contract.md](../../../skills/solo-spec-qa/references/qa-contract.md) 明确：推荐语应交回主流程记录证据并询问阶段确认。

## 4. 结论

真实黑盒调用验证了当前专家拆分方向可行。首批专家已经能覆盖产品、UX、架构、TDD、QA、Release 六类增强，并且不会替代主 `solo-spec` 流程。

当前仍不建议默认自动调用专家。更稳妥的接入方式是：

- 主流程保持独立可运行。
- 专家作为显式增强或内部可选 Reviewer / Advisor / Generator。
- 专家输出统一进入 expert packet，由主流程判断是否写入和是否触发门禁。

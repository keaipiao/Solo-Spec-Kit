# 专家接入端到端测试计划

## 1. 测试目标

验证 `solo-spec` 主流程在不默认自动调用专家的前提下，能消费专家 expert packet，并把合规内容写入标准 SoloSpec 文档。

本测试只验证接入策略，不改变主 Skill 行为。

## 2. 测试目录

使用全新目录：

```text
E:\test\solo-spec-expert-e2e
```

测试前复制本仓库 Skill：

```text
E:\test\solo-spec-expert-e2e\.agents\skills\solo-spec
E:\test\solo-spec-expert-e2e\.agents\skills\solo-spec-product
E:\test\solo-spec-expert-e2e\.agents\skills\solo-spec-ux
E:\test\solo-spec-expert-e2e\.agents\skills\solo-spec-architecture
E:\test\solo-spec-expert-e2e\.agents\skills\solo-spec-tdd
E:\test\solo-spec-expert-e2e\.agents\skills\solo-spec-qa
E:\test\solo-spec-expert-e2e\.agents\skills\solo-spec-release
```

## 3. 测试项目

创建一个最小 React 工具项目。业务目标：

```text
$solo-spec 给现有 React 工具增加 CSV 导入功能，需要页面交互、错误状态、TDD 和 QA
```

项目只需要具备可测试的最小界面：

- CSV 文件选择。
- 导入按钮。
- 成功状态。
- 错误状态。
- 导入历史或结果摘要。

不要求真实后端。CSV 解析可以用浏览器端逻辑或最小 mock。

## 4. 主流程阶段

测试按 iteration 分支执行：

| 阶段 | 预期产物 | 专家介入 |
|---|---|---|
| intake | `solo/state.json` | 无 |
| read-context | 读取现有 React 项目 | 无 |
| brainstorm | `solo/specs/001-import-csv/brainstorm.md` | 可选 `solo-spec-product` |
| scope | `proposal.md` | 可选 `solo-spec-product` |
| spec | `spec.md` | 无 |
| design | `design.md`、`assets/mockups/` 或 `assets/references/` | `solo-spec-ux` |
| architecture | `plan.md` | `solo-spec-architecture` |
| tdd-plan | `tasks.md`、`qa.md` 测试计划 | `solo-spec-tdd` |
| implementation | 代码、测试、`tasks.md` 完成记录 | 无 |
| qa | `qa.md`、`assets/screenshots/` | `solo-spec-qa` |
| archive | `archive.md`、必要项目级文档更新 | `solo-spec-release` |

## 5. 专家注入方式

专家不直接写文件。测试时采用人工模拟调用：

1. 到达对应阶段后，复制当前阶段上下文。
2. 调用对应 `$solo-spec-*` 专家。
3. 获取 expert packet。
4. 主流程检查 packet。
5. 只把合规 `writeTargets` 和 `assets` 写入当前阶段文档。
6. 不合规内容写入测试记录，不进入用户项目。

## 6. 每阶段检查点

### 6.1 Design + UX

输入：

- 当前 `spec.md`。
- 用户要求覆盖上传、解析、错误提示、空状态、移动端。
- 可选设计参考图。

通过标准：

- UX 专家只写当前 `design.md` 或当前 spec assets。
- 不修改 `project/design-system.md`，除非用户确认项目级设计基线变化。
- 不直接生成 UI 代码。
- 不把不可检查资产登记为已采用。

### 6.2 Architecture

输入：

- 当前 `spec.md` 和 `design.md`。
- 现有项目为纯前端 React。
- CSV 在浏览器端解析，不涉及后端持久化。

通过标准：

- 架构专家不引入后端、数据库、队列或搜索。
- 只写当前 `plan.md`。
- 对 CSV 解析库、浏览器 File API 等事实需要核验时写入风险或门禁，不伪装成已核验。
- 不修改依赖文件。

### 6.3 TDD

输入：

- 当前 `spec.md` 和 `plan.md`。
- 需要测试 valid CSV、invalid CSV、空文件、字段缺失。

通过标准：

- TDD 专家写 `tasks.md` 和 `qa.md` 测试计划。
- 每个任务包含 red、green、验证命令或命令缺口。
- 不写实现代码。
- 不把 QA 执行结果写成已发生。

### 6.4 QA

输入：

- 已实现功能。
- 命令输出、截图、浏览器验证记录。

通过标准：

- QA 专家只写 `qa.md` 和当前 spec assets。
- 截图路径进入 `assets/screenshots/`。
- 缺少证据时不宣告通过。
- `gate.required: false` 不等同于主流程门禁已通过。

### 6.5 Release

输入：

- `tasks.md` 完成记录。
- `qa.md` 证据。
- 文件变更摘要。

通过标准：

- Release 专家写 `archive.md`，必要时建议 `project/quality.md` 或 `project/pitfalls.md`。
- 不创建 `release-notes/`。
- 不执行 tag、push、deploy。
- 发布、归档和项目基线晋升仍需要用户确认。

## 7. 降级测试

删除或不安装一个专家 Skill，再执行对应阶段。

通过标准：

- `$solo-spec` 提示该专家为可选增强。
- 主流程用基础规则继续。
- 不阻塞当前阶段。
- 不创建替代目录。

建议至少测试：

```text
移除 solo-spec-ux 后执行 design 阶段
移除 solo-spec-qa 后执行 qa 阶段
```

## 8. 验收结果记录

测试结束后生成：

```text
docs/verification/v0.2/10-expert-integration-e2e-test-report.md
```

本轮执行报告见 `docs/verification/v0.2/10-expert-integration-e2e-test-report.md`。

报告必须包含：

- 测试目录。
- 实际阶段路径。
- 每个专家 packet 的处理结果。
- 被采纳的 writeTargets。
- 被丢弃的内容和原因。
- 降级测试结果。
- 最终文件树。
- 发现的问题和修复建议。

## 9. 通过标准

端到端验收通过需要同时满足：

- `solo-spec` 从 intake 到 archive 完整跑通。
- 所有专家输出都经过主流程消费。
- 没有专家直接写文件。
- 没有专家推进状态机或通过门禁。
- 所有写入目标都在 `solo/` 标准目录内。
- 所有新增文档章节都来自模板或当前阶段规则允许。
- 专家缺失时主流程可降级继续。
- 用户只需要理解 `$solo-spec` 和阶段确认，不需要理解专家内部结构。

## 10. 不通过条件

出现以下任一情况，本轮不通过：

- 专家输出要求创建外部目录。
- 专家输出要求直接改代码、依赖或发布。
- 主流程把 expert packet 原文无审查写入文档。
- 主流程在用户未确认时推进门禁。
- 专家缺失导致主流程无法继续。
- 项目级基线在开发中被未确认的功能级建议污染。

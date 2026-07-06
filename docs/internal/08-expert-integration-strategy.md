# 专家模块接入策略

## 1. 结论

v0.3 接入采用“阶段前置共创 + 过程生成 + 后置审查”的方式。内置 SoloSpec 专家是当前阶段的虚拟团队成员，不再只是文档写完后的可选审查器。

这样设计是为了保持 `solo-spec` 的核心承诺：

- 用户只需要一个入口。
- 主流程在未安装专家 Skill 时仍能独立运行。
- 专家不能绕过状态机、目录规则、Artifact Writer 和用户门禁。
- 专家输出只作为结构化建议和资产建议，由主流程消费。

因此，专家模块的接入等级定义为：

| 等级 | 形态 | v0.3 采用 |
|---|---|---|
| L0 | 专家 Skill 独立可用，用户直接调用 `$solo-spec-*` | 是 |
| L1 | `$solo-spec` 在当前阶段报告专家增强状态 | 是 |
| L2 | `$solo-spec` 在阶段开始或阶段中使用内置专家，并消费 expert packet | 是 |
| L3 | `$solo-spec` 对外部未知 Skill 默认自动调用 | 否 |

## 2. 调用原则

### 2.1 保持一个公共入口

普通用户仍只需要调用 `$solo-spec`。

专家 Skill 不成为新的公共流程入口。它们可以独立调用，但定位是增强能力，不是替代 `$solo-spec`。

### 2.2 当前阶段优先

主流程只能在当前 branch + stage 内建议专家。

示例：

| 当前阶段 | 可用专家 | 目的 |
|---|---|---|
| `brainstorm` / `scope` | `solo-spec-product` | 收敛用户、痛点、MVP 边界 |
| `ux` / `design` | `solo-spec-ux` | 审查 UX、状态、设计资产映射 |
| `architecture` / `plan` / `root-cause` | `solo-spec-architecture` | 判断触发架构层、ADR、风险和回滚 |
| `tdd-plan` / `regression-test` | `solo-spec-tdd` | 拆红绿任务和回归测试 |
| `implementation` / `fix` | `solo-spec-tdd` + `solo-spec-architecture` | 审查红绿实现范围、实现偏差和结构性风险 |
| `qa` / `verify` | `solo-spec-qa` | 登记真实 QA 证据 |
| `archive` / `write-managed-blocks` | `solo-spec-release` | 归档、基线晋升、托管块建议 |

主流程不能因为专家存在而提前创建未来阶段文档。

### 2.3 阶段内专家参与

主流程必须在当前阶段内使用或评估映射专家。主流程不枚举所有已安装 Skill，只提当前阶段对应的 SoloSpec 专家，以及用户明确指定的其他 Skill / 工具。

如果当前阶段 SoloSpec 专家可用，主流程可以把它作为 `co-create`、`generate-assets` 或 `review` 专家使用。内置专家仍不能写标准 `solo/` 文件、通过门禁或越过当前阶段。如果未检测到对应专家，主流程说明未安装，并给出“继续基础流程”或“指定其他 Skill / 工具”的选择。

当专家动作可能消耗明显时间、引入外部检索、生成资产、改变阶段结论或影响项目基线时，主流程必须先说明影响。

低风险本地审查可以由用户显式请求触发，例如：

```text
$solo-spec 继续，用 UX 专家生成当前 design 的高保真 HTML
$solo-spec 继续，让架构专家检查是否需要鉴权层
```

主流程提示示例：

```text
当前 design 涉及移动端、空状态和高保真 HTML。已检测到 `solo-spec-ux`，本阶段已用 UX 专家做体验方案共创，下一步可以生成高保真 HTML，也可以先确认当前设计方向。

请选择：
1. 生成高保真 HTML
2. 先确认当前 design
```

未检测到对应专家时：

```text
当前 design 可使用 UX 专家增强，但未检测到 `solo-spec-ux`。

请选择：
1. 继续基础流程并确认当前 design
2. 指定其他 Skill / 工具处理当前 design
```

## 3. Expert Packet 消费流程

主流程消费专家输出时必须按固定顺序处理：

1. 校验 packet 形状，必须包含中文摘要和 `machine`。
2. 校验 `machine.branch` 和 `machine.stage` 是否匹配当前状态。
3. 校验 `machine.writeTargets.file` 是否位于 `solo/` 允许目标。
4. 校验 `machine.writeTargets.section` 是否存在于目标模板。
5. 校验 `machine.assets.target` 是否位于当前允许资产目录。
6. 把不合规内容放入 `discarded` 或主流程审查记录。
7. 只把合规建议交给 Artifact Writer。
8. 根据 `gate` 和主流程规则决定是否停在门禁。

专家输出不能直接写入用户项目。

## 4. 写入规则

### 4.1 文件和章节

`writeTargets.file` 必须是相对 `solo/` 的路径。

允许目标包括：

- `project/*.md`
- `specs/NNN-*/brainstorm.md`
- `specs/NNN-*/proposal.md`
- `specs/NNN-*/spec.md`
- `specs/NNN-*/design.md`
- `specs/NNN-*/plan.md`
- `specs/NNN-*/tasks.md`
- `specs/NNN-*/qa.md`
- `specs/NNN-*/archive.md`
- `decisions/ADR-*.md`
- `managed-blocks/*.md`

如果目标章节不存在，默认丢弃该写入建议，除非当前阶段规则明确允许新增章节。

### 4.2 资产

外部资产必须复制到 SoloSpec 标准目录后再登记：

- 项目级视觉参考：`project/assets/references/`
- 项目级品牌资产：`project/assets/brand/`
- 规格级线稿：当前 spec `assets/wireframes/`
- 规格级高保真 HTML：当前 spec `assets/mockups/`
- QA 截图：当前 spec `assets/screenshots/`
- QA 日志和 API 样本：当前 spec `assets/logs/`

资产不可检查时，专家可以输出风险和门禁问题，但不能建议采纳为最终设计或 QA 证据。

## 5. 冲突处理

冲突优先级如下：

1. 用户明确确认的当前阶段结论。
2. 当前 branch + stage 的状态机规则。
3. 当前 spec 文档。
4. 项目级基线文档。
5. 专家建议。
6. 外部 Skill 原始输出。

阶段内冲突规则：

- 开发过程中，功能级 spec 优先于项目级基线。
- 归档时，只有确认且可复用的结论才能晋升项目级基线。
- Bugfix 不默认创建新功能 spec，也不引入大范围架构迁移。
- QA 证据优先于测试计划；计划不能伪装成执行结果。
- Release 专家不能执行 tag、push、deploy 或发布完成声明。

专家之间冲突时，当前阶段专家优先。

示例：

| 冲突 | 处理 |
|---|---|
| UX 专家建议改主题色，当前是小迭代 design | 留在当前 spec，归档时再决定是否晋升 |
| 架构专家建议引入队列，产品范围没有异步任务 | 丢弃为 `untriggered-layer` 或 `scope-creep` |
| TDD 专家要求测试命令，仓库脚本未知 | 写入风险，不编造命令 |
| QA 专家认为无阻塞，主流程门禁未确认 | 主流程仍等待用户确认 |

## 6. 失败降级

专家调用失败时，`solo-spec` 不应中断主流程。

| 失败类型 | 处理 |
|---|---|
| 专家 Skill 未安装 | 使用主流程基础规则继续，并提示该专家为可选增强 |
| 输出不是 expert packet | 不写入，要求重新输出结构化 packet |
| branch / stage 不匹配 | 丢弃跨阶段内容 |
| 目标文件或章节不存在 | 丢弃对应 writeTarget |
| 资产路径不可访问 | 不采纳资产，只记录风险 |
| 官方事实未核验 | 不写成结论，转为风险或门禁问题 |
| 专家输出过宽 | 只保留当前阶段可消费部分 |

失败降级后，主流程仍按原状态机继续。

## 7. 对状态机的影响

v0.3 接入专家不新增状态机阶段。

专家协作只发生在当前阶段内部，可视为阶段内共创、资产生成或评审动作：

```text
stage-start
  -> read current context
  -> evaluate mapped current-stage expert
  -> co-create or generate-assets when useful for this stage
  -> artifact write
  -> validation
  -> review with current-stage expert when risk justifies it
  -> consume expert packet
  -> gate
```

`solo/state.json` 不需要新增专家状态字段。

如需记录专家参与，只写入当前阶段文档的审查记录、门禁记录或 `archive.md`，不写全局状态。

## 8. 用户体验规则

主流程向用户描述专家时必须简洁：

- 不解释内部多 Skill 架构。
- 不要求用户理解 expert packet。
- 不要求用户记住多个专家命令。
- 只说明当前阶段专家是否可用、收益和影响。
- 不枚举全部 Skill。
- 用户指定其他 Skill / 工具时，说明它会作为外部增强输入，由 `solo-spec` 审查后再写入当前阶段文档。

示例：

```text
这个阶段涉及认证、角色和会话过期。已检测到 `solo-spec-architecture`，可以先调用架构专家审查鉴权层、数据模型和回滚风险，也可以跳过专家直接确认当前架构。

请选择：
1. 调用架构专家审查当前 architecture
2. 跳过专家，直接确认当前 architecture
```

## 9. 端到端验收

已按 `docs/verification/v0.2/09-expert-integration-e2e-test-plan.md` 在全新目录执行一条完整 iteration：

```text
$solo-spec 给现有 React 工具增加 CSV 导入功能，需要页面交互、错误状态、TDD 和 QA
```

验收覆盖：

- 主流程从 `intake` 到 `archive` 跑通。
- 在 `design` 阶段插入 UX expert packet。
- 在 `architecture` 阶段插入 architecture expert packet。
- 在 `tdd-plan` 阶段插入 TDD expert packet。
- 在 `qa` 阶段插入 QA expert packet。
- 在 `archive` 阶段插入 release expert packet。
- 每次专家输出都由主流程消费，不由专家直接写文件。
- 专家缺失时，主流程能降级继续。

v0.2 端到端验收已完成，报告见 `docs/verification/v0.2/10-expert-integration-e2e-test-report.md`。这些报告是历史基线，用于证明专家 packet 可被消费；v0.3 当前实现以本文前述“阶段前置共创 + 过程生成 + 后置审查”为准。

## 10. 不做事项

v0.3 不做：

- 不新增 `$solo-spec product`、`$solo-spec ux`、`$solo-spec qa` 等公共命令。
- 不让专家写文件、改状态机或通过门禁。
- 不把专家输出原文无审查地拼进文档。
- 不把外部 Skill 的目录结构带入用户项目。
- 不默认自动调用用户未指定的外部未知 Skill / 工具。

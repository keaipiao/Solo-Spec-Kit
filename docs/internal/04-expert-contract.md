# 专家模块契约

v0.3 定义专家模块契约，并以“阶段前置共创 + 过程生成 + 后置审查”的方式接入 `solo-spec`。设计方案见 `docs/internal/05-expert-module-v02-design.md`，独立专家 Skill 架构见 `docs/internal/06-expert-skills-architecture.md`，接入策略见 `docs/internal/08-expert-integration-strategy.md`。

## 1. 契约目标

专家模块用于吸收 BMAD、Spec Kit、OpenSpec、Superpowers、gstack、taste 等顶级 Skill 的方法论，但所有输出必须服从 SoloSpec 的目录、章节、状态机和门禁。

专家模块不直接拥有主流程写文件权。所有标准 `solo/` 写入由 artifact-writer 统一执行；生成类专家可以建议资产目标，只有在主流程确认当前阶段允许后才写入或登记。

本文档中的写入目标默认是相对 `solo/` 的路径。例：`project/brief.md` 表示用户项目中的 `solo/project/brief.md`。

## 2. 通用输入

每个专家模块都接收统一上下文包：

| 字段 | 说明 |
|---|---|
| branch | 当前分支 |
| stage | 当前阶段 |
| userRequest | 用户原始请求 |
| state | `solo/state.json` 内容 |
| projectDocs | 相关 `solo/project/` 内容 |
| currentSpecDocs | 当前迭代文档 |
| repoContext | 相关代码、文件树、测试命令 |
| constraints | 用户约束、技术约束、门禁约束 |

## 3. 通用输出

专家模块必须输出中文可读结果，并保留机器可读 `machine` 结构。用户默认阅读中文层，主流程消费 `machine` 层。

```yaml
专家: solo-spec-product
阶段: brainstorm
模式: co-create
结论摘要:
  - ...
主要发现:
  - ...
建议:
  - ...
写入建议:
  - 目标: project/brief.md
    章节: ...
    原因: ...
资产建议: []
丢弃内容:
  - 内容: ...
    原因: ...
门禁建议:
  需要确认: true
  问题: ...
风险:
  - ...
machine:
  expert: solo-spec-product
  branch:
  stage:
  mode: co-create | generate-assets | review | external-adapter
  summary:
  findings:
  recommendation:
  writeTargets:
    - file:
      section:
      content:
  assets:
    - source:
      target:
      registerIn:
      description:
  discarded:
    - item:
      reason:
  gate:
    required:
    question:
  risks:
```

字段说明：

| 字段 | 说明 |
|---|---|
| branch | 当前分支：`new-project`、`iteration`、`bugfix` 或 `adopt-existing` |
| stage | 当前阶段 |
| mode | 专家模式：`co-create`、`generate-assets`、`review` 或 `external-adapter` |
| summary | 本模块结论 |
| findings | 调研、审查、分析发现 |
| recommendation | 推荐方案和理由 |
| writeTargets | 建议写入的文件和章节 |
| assets | 建议登记的原始产物和 SoloSpec 目标路径 |
| discarded | 不适合当前阶段、目录或门禁的内容及丢弃原因 |
| gate | 是否需要用户确认 |
| risks | 风险、假设和未确认项 |

模式说明：

| 模式 | 触发时机 | 作用 | 写入边界 |
|---|---|---|---|
| `co-create` | 阶段开始或阶段中 | 生成候选方向、问题、结构化草案和取舍 | 只建议当前阶段内容 |
| `generate-assets` | UX、QA 或需要证据资产时 | 生成或登记 SVG、HTML、截图、日志等资产 | 只进入当前项目或当前 spec 的 assets |
| `review` | 阶段门禁前 | 查漏补缺、审查风险、提出门禁问题 | 不直接通过门禁 |
| `external-adapter` | 用户指定外部 Skill / 工具时 | 把外部输出转成 SoloSpec 当前阶段结构 | 必须丢弃跨阶段或无目标内容 |

## 4. 禁止事项

所有专家模块都禁止：

- 直接写文件。
- 自行创建非 `solo/` 目录。
- 自行提交代码。
- 跳过当前门禁。
- 把不确定内容写成已确认结论。
- 在没有来源时断言版本、API、模型、平台能力。
- 只输出英文机器字段而没有中文摘要。
- 输出超出当前阶段且没有放入 `discarded` 的内容。
- 建议无消费方的文档、目录或资产。

## 5. 专家模块列表

### 5.1 router

**触发阶段**：所有分支的 `intake`。

**职责**：

- 复述用户诉求。
- 列出关键假设。
- 判断分支：`new-project`、`iteration`、`bugfix`、`adopt-existing`。
- 判断是否需要提问。

**写入目标**：

- `solo/state.json`

**门禁**：分支不确定时必须停下。

### 5.2 founder-review

**触发阶段**：

- new-project：`brainstorm`
- new-project：`scope`
- iteration：`brainstorm`
- iteration：`scope`

**职责**：

- 在 `brainstorm` 阶段理解问题后发散多个候选方案。
- 为每个候选方案写清适用场景、收益、代价、风险和需要调研的事实。
- 挑战“这个方向是否值得做”，指出明显不建议的方向。
- 在 `scope` 阶段根据用户选择收敛 MVP 或本次迭代边界。
- 明确不做什么。

**借鉴来源**：BMAD brainstorming、gstack office-hours。

**写入目标**：

- new-project：`brainstorm` 不写文件，`scope` 只写确认后的结论到 `project/brief.md`
- iteration：可写过程和取舍到 `specs/NNN-iteration-name/brainstorm.md`、`specs/NNN-iteration-name/proposal.md`

**门禁**：候选方案必须由用户选择、组合或否定；产品方向或迭代边界必须用户确认。

### 5.3 staged-research

**触发阶段**：

- new-project：`brainstorm` 中需要事实核实时
- iteration：`read-context`
- adopt-existing：`inventory`
- brainstorm、scope、prd、spec、ux、design、architecture、implementation 阶段需要事实核实时

**职责**：

- 按阶段做够用调研。
- 产品阶段查用户、痛点、竞品、替代方案。
- UX 阶段查交互模式、视觉参考、状态处理。
- 架构阶段查官方 API、SDK、版本、兼容性。
- 老项目接入阶段盘点现有代码和文档。

**写入目标**：

- new-project：当前阶段文档，产品事实写入 `project/brief.md` 或 `project/prd.md`，UX 事实写入 `project/ux.md` 或 `project/design-system.md`，技术事实写入 `project/architecture.md` 或 ADR
- 当前迭代的 `brainstorm.md`、`proposal.md`、`design.md`、`plan.md`

**门禁**：关键事实影响方向、架构或外部依赖时必须停下。

### 5.4 prd

**触发阶段**：

- new-project：`prd`
- adopt-existing：`summarize-project`

**职责**：

- new-project：写产品目标、范围、非目标、成功指标。
- adopt-existing：把现有项目事实收敛成接入基线摘要，不生成新的产品 PRD。
- 把用户故事和核心流程结构化。
- 避免把实现细节提前写成需求。

**写入目标**：

- new-project：`project/prd.md`，必要时补 `project/brief.md`
- adopt-existing：`project/brief.md`

**门禁**：PRD 范围必须用户确认。

### 5.5 ux-design

**触发阶段**：

- new-project：`ux`
- iteration：`design`

**职责**：

- 设计用户流、信息架构、页面/组件清单。
- 选择 UI 出图路线：直接高保真、线稿先行、生成图参考。
- 管理状态：加载、空、错误、无权限、移动端。
- 接收 `generate-assets` 或 `external-adapter` 产物并登记。
- 反 AI 味审查：避免模板化、无状态、不可实现的 UI。

**借鉴来源**：taste、gstack design-review。

**写入目标**：

- `project/ux.md`
- `project/design-system.md`
- `specs/NNN-iteration-name/design.md`
- `assets/wireframes/`
- `assets/mockups/`
- `assets/references/`

**门禁**：有 UI 时，UI 方向和关键稿件必须用户确认。

### 5.6 architecture

**触发阶段**：

- new-project：`architecture`
- iteration：`architecture`
- bugfix：`root-cause`
- adopt-existing：`classify`

**职责**：

- 明确模块边界、数据流、接口、数据模型。
- 根据 PRD、UX 和约束主动扩展架构层，不被模板默认行限制。
- 触发登录、角色、权限、租户时必须补鉴权 / 授权层；例如 Spring Boot 后端有鉴权需求时，应主动考虑 Spring Security 等方案。
- 触发持久化、缓存、队列、搜索、AI、外部 API、可观测性、安全审计时必须补对应层。
- 做技术选型和官方事实核实。
- 记录 ADR。
- 定义风险、迁移、兼容和回滚边界。
- Bugfix 时定位根因，不做随机修复。

**借鉴来源**：gstack plan-eng-review、BMAD architect。

**写入目标**：

- `project/architecture.md`
- `specs/NNN-iteration-name/plan.md`
- `solo/decisions/ADR-*.md`

**门禁**：架构、数据模型、接口、外部依赖变化必须用户确认。

### 5.7 spec

**触发阶段**：

- new-project：`spec`
- iteration：`spec`
- adopt-existing：`propose-adoption-plan`

**职责**：

- 把已确认需求转为可执行规格。
- 写用户故事、场景、验收标准、非目标、依赖。
- 保持 proposal、spec、design、plan 的边界清晰。
- adopt-existing：只提出后续迭代建议，写入 `project/brief.md` 后续建议章节，不创建规格目录。

**借鉴来源**：Spec Kit、OpenSpec。

**写入目标**：

- new-project MVP：`specs/001-mvp/spec.md`
- iteration：当前迭代的 `proposal.md`、`spec.md`、`design.md`、`plan.md`
- adopt-existing：`project/brief.md`

**门禁**：可执行规格必须用户确认。

### 5.8 tdd

**触发阶段**：

- new-project：`tdd-plan`、`implementation`
- iteration：`tdd-plan`、`implementation`
- bugfix：`regression-test`、`fix`

**职责**：

- 把规格拆为 TDD 任务。
- 每个任务先写失败测试，再最小实现。
- 明确命令、预期失败、预期通过、回归验证。
- Bugfix 必须先有回归测试或明确测试方法。

**借鉴来源**：Superpowers。

**写入目标**：

- `tasks.md`
- `qa.md` 的测试计划
- 代码和测试文件由实现阶段按任务修改

**门禁**：TDD 任务清单必须用户确认。

### 5.9 qa

**触发阶段**：

- new-project：`qa`
- iteration：`qa`
- bugfix：`reproduce`、`verify`

**职责**：

- 验证单元、集成、E2E 或 API QA。
- UI 项目要检查浏览器、控制台、网络、移动端。
- 后端项目要用真实客户端视角验证 API。
- 收集截图、日志和命令输出。

**借鉴来源**：gstack QA。

**写入目标**：

- `qa.md`
- `assets/screenshots/`
- `archive.md` 验证摘要

**门禁**：QA 结果必须用户确认。

### 5.10 archive

独立 Skill 对应 `solo-spec-release`；`archive` 是流程内的收口角色名。

**触发阶段**：

- new-project：`ship/archive`
- iteration：`archive`
- bugfix：`archive`
- adopt-existing：`write-managed-blocks`

**职责**：

- 写完成摘要、文件变更、验证记录、遗留项。
- 提出归档后的项目级文档更新建议。
- 当测试分层、QA 矩阵或证据规则变化时，更新 `project/quality.md`。
- 晋升跨迭代踩坑到 `project/pitfalls.md`。
- 管理托管块写入。

**借鉴来源**：piao-workflow、OpenSpec。

**写入目标**：

- `archive.md`
- `project/release.md`
- `project/quality.md`
- `project/pitfalls.md`
- `managed-blocks/readme.md`
- `managed-blocks/changelog.md`
- `managed-blocks/agents.md`，仅在主流程已有匹配托管块规则时使用

**门禁**：发布、托管块、归档收尾必须用户确认。

## 6. 外部增强适配

外部增强不直接写入 SoloSpec 产物。用户指定其他 Skill 或工具时，主流程必须把输出按 `external-adapter` 适配为当前阶段的专家契约结果，再决定是否写入。

示例：

| 外部能力 | 适配为 | 输出处理 |
|---|---|---|
| taste 生成项目级视觉参考 | `external-adapter` -> ux-design `generate-assets` | 放入 `project/assets/references/`，登记 `project/design-system.md` |
| taste 生成具体页面高保真 HTML | `external-adapter` -> ux-design `generate-assets` | 放入当前规格 `assets/mockups/`，登记 `design.md` |
| gstack QA 截图 | `external-adapter` -> qa `generate-assets` | 放入当前规格 `assets/screenshots/`，登记 `qa.md` |
| superpowers TDD 建议 | `external-adapter` -> tdd `co-create` | 转成 `tasks.md` |
| gstack design-review | `external-adapter` -> ux-design `review` | 写入 `design.md` 门禁结论 |
| OpenSpec 归档建议 | `external-adapter` -> archive `review` | 转成当前 `archive.md`、`project/release.md`、`project/quality.md` 或 `project/pitfalls.md` |

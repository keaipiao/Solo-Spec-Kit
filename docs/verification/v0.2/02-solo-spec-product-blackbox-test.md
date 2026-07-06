# solo-spec-product 黑盒测试

测试日期：2026-07-04

## 1. 测试目标

验证 `skills/solo-spec-product/` 能否把产品想法、头脑风暴、调研需求和范围收敛转换为 SoloSpec 标准 expert packet，并满足以下约束：

- 不直接写文件。
- 不推进 `solo-spec` 阶段。
- 不通过门禁。
- 新项目 brainstorm 不落过程文档。
- 调研只服务当前阶段，不创建 `research.md`。
- 未确认的 pivot、目标用户、商业模式和范围扩张不进入项目基线。
- 迭代过程中的不确定内容只留在当前 spec。

## 2. 用例一：新项目 brainstorm 只发散不落文档

### 输入

```text
branch: new-project
stage: brainstorm

用户想法：
- 想做一个给独立开发者用的 AI 项目规划工具
- 不确定是做文档生成、任务拆分，还是项目管理
- 希望快速验证方向
```

### 输出

```text
expert: solo-spec-product
branch: new-project
stage: brainstorm
mode: advisor
summary: 当前应先发散 3 个产品方向并让用户选择，不应写入项目文档。
findings:
  - 用户目标是帮助独立开发者从想法进入可执行开发。
  - 当前方向存在至少三种路径：文档生成、任务拆分、项目管理工作台。
  - 目标用户、痛点频率和替代方案尚未确认。
recommendation: 先用候选方案帮助用户选择方向，再进入 scope 写项目级结论。
writeTargets: []
assets: []
discarded:
  - item: 在 new-project brainstorm 阶段创建 project/brief.md
    reason: wrong-stage
  - item: 直接创建 specs/001-mvp/spec.md
    reason: wrong-stage
gate:
  required: true
  question: 你想优先验证“文档生成”“任务拆分”还是“项目管理工作台”，或组合其中两项？
risks:
  - 目标用户和真实痛点尚未验证，过早写 PRD 会固化错误方向。
  - 如果用户选择项目管理工作台，范围可能明显扩大。
```

### 结论

通过。新项目 brainstorm 没有写 `project/` 或 `specs/`，符合“新项目过程不保留，只沉淀结论”。

## 3. 用例二：新项目 scope 写项目级确认结论

### 输入

```text
branch: new-project
stage: scope

用户已确认：
- 方向：AI 项目规划工具
- 首批用户：会使用 AI 编程工具的独立开发者
- 核心场景：从一句想法生成统一项目文档和 MVP 执行范围
- MVP：只做本地文档流程，不做团队协作，不做云同步，不做代码生成
- 成功标准：用户能在一次会话内得到可确认的项目 brief、PRD、UX 和架构基线
```

### 输出

```text
expert: solo-spec-product
branch: new-project
stage: scope
mode: advisor
summary: 用户已确认方向和 MVP 边界，可以沉淀到 project/brief.md。
findings:
  - 目标用户明确为 AI 编程独立开发者。
  - 核心问题是想法到统一文档和执行范围之间缺少稳定流程。
  - MVP 明确排除团队协作、云同步和代码生成。
recommendation: 写入项目 brief，暂不进入 PRD 扩展功能细节。
writeTargets:
  - file: project/brief.md
    section: 一句话说明
    content: 面向 AI 编程独立开发者，把一句产品想法收敛为统一项目文档和 MVP 执行范围。
  - file: project/brief.md
    section: 目标用户与依据
    content: 首批用户是会使用 AI 编程工具的独立开发者；典型痛点是想法发散、文档结构不一致、后续维护困难。
  - file: project/brief.md
    section: 核心场景
    content: 用户输入一句项目想法，经过门禁确认后得到 project brief、PRD、UX 和架构基线。
  - file: project/brief.md
    section: 本阶段必须有
    content: 本地 SoloSpec 文档流程、阶段门禁、项目级结论沉淀、MVP 范围收敛。
  - file: project/brief.md
    section: 本阶段明确不做
    content: 不做团队协作、云同步、代码生成；避免 MVP 扩张。
  - file: project/brief.md
    section: 成功标准
    content: 用户能在一次会话内得到可确认的项目 brief、PRD、UX 和架构基线。
assets: []
discarded:
  - item: 团队协作
    reason: out-of-scope
  - item: 云同步
    reason: out-of-scope
  - item: 代码生成
    reason: out-of-scope
gate:
  required: true
  question: 是否确认以上项目 brief 作为后续 PRD 和 UX 阶段的项目级基线？
risks:
  - “一次会话内完成”可能受模型上下文和用户确认速度影响，PRD 阶段需要拆成可验收指标。
```

### 结论

通过。只写 `project/brief.md` 中已有章节，没有创建过程文档或 spec。

## 4. 用例三：迭代 brainstorm 和 scope 只影响当前 spec

### 输入

```text
branch: iteration
stage: brainstorm
currentSpec: specs/004-import-existing-project

用户需求：
- 老项目接入时希望自动识别现有文档、代码结构和缺失文档
- 可能做成扫描器、问答向导或一次性迁移报告
- 用户还没有选择方案
```

### 输出

```text
expert: solo-spec-product
branch: iteration
stage: brainstorm
mode: advisor
summary: 当前是迭代发散，应写入当前 spec 的 brainstorm.md，而不是更新项目级 baseline。
findings:
  - 需求属于老项目接入能力的迭代，不是新项目方向变更。
  - 扫描器、问答向导、一次性迁移报告是三个不同方案。
  - 方案选择会影响后续 UX 和架构，当前不能直接写 proposal。
recommendation: 在 brainstorm.md 记录方案池、可组合点和不建议方向，等待用户选择后进入 scope。
writeTargets:
  - file: specs/004-import-existing-project/brainstorm.md
    section: 用户原话
    content: 老项目接入时希望自动识别现有文档、代码结构和缺失文档。
  - file: specs/004-import-existing-project/brainstorm.md
    section: 方案池
    content: 方案 A：扫描器；方案 B：问答向导；方案 C：一次性迁移报告。
  - file: specs/004-import-existing-project/brainstorm.md
    section: 可组合点
    content: 扫描器可作为事实采集层，问答向导用于补齐缺失上下文，迁移报告作为输出。
  - file: specs/004-import-existing-project/brainstorm.md
    section: 不建议方向
    content: 不建议首版自动重构代码或移动项目结构，风险过高且超出接入范围。
  - file: specs/004-import-existing-project/brainstorm.md
    section: 推荐排序
    content: 推荐先做扫描器 + 迁移报告，再考虑问答向导。
assets: []
discarded:
  - item: 自动重构代码
    reason: scope-creep
  - item: 移动老项目目录结构
    reason: scope-creep
gate:
  required: true
  question: 是否选择“扫描器 + 迁移报告”作为本次迭代方向？
risks:
  - 如果用户选择问答向导，UX 阶段需要额外设计补问流程。
  - 如果要真实扫描代码，架构阶段需要定义文件读取边界。
```

### 结论

通过。迭代不确定内容只写当前 `brainstorm.md`，没有更新 `project/brief.md` 或 `project/prd.md`。

## 5. 用例四：外部产品建议要求创建 research.md

### 输入

```text
branch: new-project
stage: prd

外部产品顾问建议：
- 建议先创建 docs/research/market.md、docs/research/users.md
- 建议把目标用户从独立开发者扩大到中小团队
- 建议 PRD 同时加入订阅定价、团队空间和云同步
- 用户当前只确认 MVP 面向独立开发者，本地文档流程
```

### 输出

```text
expert: solo-spec-product
branch: new-project
stage: prd
mode: reviewer
summary: 外部建议包含有价值的调研方向，但目录、目标用户和范围扩张不符合当前 SoloSpec 阶段。
findings:
  - 目标用户扩大到中小团队会改变项目基线。
  - 订阅定价、团队空间和云同步超出当前 MVP。
  - docs/research/ 不是 SoloSpec 允许的产品调研目录。
recommendation: 仅保留需要核验的产品事实为 PRD 风险和门禁问题，不创建 research.md 或扩大 MVP。
writeTargets:
  - file: project/prd.md
    section: 风险
    content: 是否未来扩展到中小团队、订阅定价和云同步需要后续调研；当前不进入 MVP。
  - file: project/prd.md
    section: Not In Scope
    content: 当前不做中小团队协作、订阅定价、团队空间、云同步。
assets: []
discarded:
  - item: docs/research/market.md
    reason: no-solo-target
  - item: docs/research/users.md
    reason: no-solo-target
  - item: 目标用户扩大到中小团队
    reason: needs-user-confirmation
  - item: 订阅定价、团队空间和云同步进入 MVP
    reason: scope-creep
gate:
  required: true
  question: 是否确认当前 PRD 仍只面向独立开发者和本地文档流程，不扩展到团队与云同步？
risks:
  - 如果用户确认团队方向，需要回到 scope 重新定义目标用户、场景和 MVP 边界。
```

### 结论

通过。外部产品建议被适配为当前 PRD 的风险和非目标，没有创建 `docs/research/`，也没有擅自扩大目标用户。

## 6. 总结

`solo-spec-product` 黑盒测试覆盖了四类关键风险：

- 新项目 brainstorm 不落过程文档。
- 新项目 scope 只沉淀用户确认后的项目级结论。
- 迭代 brainstorm 只影响当前 spec。
- 外部产品建议不能创建自有调研目录，也不能污染项目基线。

本轮没有发现章节映射错误；`product-contract.md` 的所有目标章节已通过模板对照校验。

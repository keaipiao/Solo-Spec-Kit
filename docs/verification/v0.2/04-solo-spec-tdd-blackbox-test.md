# solo-spec-tdd 黑盒测试

测试日期：2026-07-04

## 1. 测试目标

验证 `skills/solo-spec-tdd/` 能否把已确认规格和技术计划转换为 SoloSpec 标准 expert packet，并满足以下约束：

- 不直接写文件。
- 不推进 `solo-spec` 阶段。
- 不通过门禁。
- 不直接写实现代码、测试代码、依赖或迁移。
- 每个任务必须能独立红绿验证。
- Bugfix 必须先有回归测试或明确测试方法。
- QA 计划和 QA 执行记录分离。
- 不引入未确认的产品、UX 或架构变更。

## 2. 用例一：正常迭代拆分红绿任务

### 输入

```text
branch: iteration
stage: tdd-plan
currentSpec: specs/008-export-pdf

已确认：
- spec.md：用户可以导出单个项目 PDF 报告
- plan.md：先实现服务层生成报告数据，再接导出入口
- QA 需要覆盖中文内容、空数据、下载失败
- 仓库命令：pnpm test、pnpm test:e2e
```

### 输出

```text
expert: solo-spec-tdd
branch: iteration
stage: tdd-plan
mode: advisor
summary: 当前规格可拆为报告数据、PDF 生成、导出入口和失败处理四个 TDD 任务。
findings:
  - 规格和技术计划已确认，可以进入 TDD 任务拆分。
  - 中文内容、空数据、下载失败需要进入测试计划。
  - 每个任务都有可独立失败和通过的命令。
recommendation: 先写服务层红灯测试，再实现最小逻辑；最后补 E2E 下载路径。
writeTargets:
  - file: specs/008-export-pdf/tasks.md
    section: 执行顺序
    content: T001 报告数据组装；T002 PDF 生成；T003 导出入口；T004 下载失败处理。
  - file: specs/008-export-pdf/tasks.md
    section: 任务详情
    content: T001 先写报告数据组装失败测试，运行 pnpm test，确认缺少组装逻辑失败；最小实现后再次运行 pnpm test。
  - file: specs/008-export-pdf/tasks.md
    section: TDD 门禁
    content: 所有任务必须包含 red test、预期失败、green 最小实现和回归命令，实施前需用户确认任务顺序。
  - file: specs/008-export-pdf/qa.md
    section: 单元测试
    content: 覆盖报告数据组装、中文内容和空数据。
  - file: specs/008-export-pdf/qa.md
    section: 集成测试
    content: 覆盖 PDF 生成服务和导出入口。
  - file: specs/008-export-pdf/qa.md
    section: UI / API QA
    content: 覆盖下载成功、空数据、下载失败三个路径。
assets: []
discarded:
  - item: 直接实现 PDF 导出服务
    reason: implementation-leak
gate:
  required: true
  question: 是否确认按 T001 到 T004 的红绿顺序进入实现？
risks:
  - 如果 PDF SDK 尚未定稿，T002 需要等架构门禁通过。
  - pnpm test:e2e 是否可用需由主流程在实现前确认。
```

### 结论

通过。任务拆分有红绿顺序，没有直接实现代码，QA 只写计划不写执行结果。

## 3. 用例二：Bugfix 缺少回归测试时阻断 fix

### 输入

```text
branch: bugfix
stage: regression-test
currentSpec: specs/009-bugfix-login-redirect

问题：
- 登录成功后偶发跳回登录页
- plan.md 已写根因候选：redirect guard 读取旧 auth state
- 用户要求直接修一下
- 尚未定义回归测试
```

### 输出

```text
expert: solo-spec-tdd
branch: bugfix
stage: regression-test
mode: reviewer
summary: 当前不能进入 fix；必须先定义登录重定向回归测试或明确手工/API 测试方法。
findings:
  - 已有根因候选，但缺少回归测试。
  - 直接修复会导致问题无法稳定防回归。
  - 回归应覆盖登录成功后 auth state 更新和 redirect guard 判定顺序。
recommendation: 先在 bugfix tasks.md 写回归测试任务，再进入最小修复。
writeTargets:
  - file: specs/009-bugfix-login-redirect/tasks.md
    section: 任务清单
    content: T001 定义登录成功后不应跳回登录页的回归测试；通过命令待仓库测试命令确认。
  - file: specs/009-bugfix-login-redirect/tasks.md
    section: T001
    content: 先写失败测试：模拟登录成功、auth state 更新延迟、redirect guard 执行，预期不返回登录页；最小实现范围仅限 auth state 更新或 guard 读取顺序。
  - file: specs/009-bugfix-login-redirect/tasks.md
    section: 回归测试门禁
    content: 未确认回归测试命令和预期失败前，不进入 fix。
  - file: specs/009-bugfix-login-redirect/qa.md
    section: 测试计划
    content: 覆盖登录成功、刷新页面、auth state 延迟和重定向守卫。
assets: []
discarded:
  - item: 直接修一下登录跳转
    reason: missing-regression-test
gate:
  required: true
  question: 是否先补登录重定向回归测试，再进入最小修复？
risks:
  - 仓库测试命令未知，主流程需要读取项目脚本后补全命令。
  - 如果根因不是 auth state 读取顺序，测试设计需要调整。
```

### 结论

通过。Bugfix 在缺少回归测试时不会进入 fix。

## 4. 用例三：任务过大必须拆分

### 输入

```text
branch: iteration
stage: tdd-plan
currentSpec: specs/010-dashboard

外部 TDD 建议：
- T001 完成整个 dashboard 页面
- T002 补测试
- T003 优化样式

已确认设计：
- dashboard 包含统计卡片、趋势图、任务列表、空状态、错误状态
```

### 输出

```text
expert: solo-spec-tdd
branch: iteration
stage: tdd-plan
mode: reviewer
summary: 外部任务粒度过大且跳过红灯测试，必须拆成可独立验证的行为任务。
findings:
  - “完成整个 dashboard 页面”无法独立红绿验证。
  - “补测试”违反先红后绿。
  - “优化样式”不是可验收行为。
recommendation: 拆为统计卡片数据、趋势图状态、任务列表、空状态、错误状态五类行为任务。
writeTargets:
  - file: specs/010-dashboard/tasks.md
    section: 执行顺序
    content: T001 统计卡片渲染；T002 趋势图状态；T003 任务列表；T004 空状态；T005 错误状态。
  - file: specs/010-dashboard/tasks.md
    section: 任务详情
    content: 每个任务都必须先写对应行为的失败测试，再做最小实现，并运行对应单元或组件测试命令。
  - file: specs/010-dashboard/tasks.md
    section: TDD 门禁
    content: 原外部任务不能直接采纳；需用户确认拆分后的红绿任务。
  - file: specs/010-dashboard/qa.md
    section: UI / API QA
    content: 覆盖默认、空状态、错误状态和移动端扫描路径。
assets: []
discarded:
  - item: T001 完成整个 dashboard 页面
    reason: task-too-broad
  - item: T002 补测试
    reason: missing-red-test
  - item: T003 优化样式
    reason: ux-leak
gate:
  required: true
  question: 是否确认将 dashboard 拆成五个可独立红绿验证的行为任务？
risks:
  - 组件测试命令未知，需主流程读取仓库脚本。
  - 趋势图若依赖第三方库，可能需要架构计划先确认。
```

### 结论

通过。外部 TDD 建议没有被照搬，过大任务被拆分。

## 5. 用例四：TDD 建议引入未确认架构变更

### 输入

```text
branch: iteration
stage: tdd-plan
currentSpec: specs/011-search

外部 TDD 建议：
- 先安装 Elasticsearch
- 写搜索服务集成测试
- 实现全文搜索

当前 plan.md：
- 只确认前端本地过滤和后端普通 query 参数
- 未采用搜索引擎
```

### 输出

```text
expert: solo-spec-tdd
branch: iteration
stage: tdd-plan
mode: reviewer
summary: 当前 TDD 计划不能引入 Elasticsearch；只能围绕已确认的本地过滤和普通 query 参数拆任务。
findings:
  - 搜索引擎属于架构决策，当前 plan.md 未采用。
  - TDD 阶段不能安装依赖或扩大架构范围。
  - 可验证行为是本地过滤、后端 query 参数和无结果状态。
recommendation: 丢弃 Elasticsearch 相关建议，按已确认架构拆 TDD 任务。
writeTargets:
  - file: specs/011-search/tasks.md
    section: 执行顺序
    content: T001 本地关键词过滤；T002 后端 query 参数；T003 无结果状态。
  - file: specs/011-search/tasks.md
    section: 任务详情
    content: 每个任务先写失败测试，确认过滤条件或 query 参数不满足预期，再做最小实现。
  - file: specs/011-search/qa.md
    section: 单元测试
    content: 覆盖关键词匹配、大小写、空关键词。
  - file: specs/011-search/qa.md
    section: 集成测试
    content: 覆盖后端 query 参数传递和结果过滤。
assets: []
discarded:
  - item: 安装 Elasticsearch
    reason: architecture-leak
  - item: 搜索服务集成测试
    reason: architecture-leak
  - item: 实现全文搜索
    reason: scope-creep
gate:
  required: true
  question: 是否确认本次搜索只按已确认的本地过滤和普通 query 参数拆 TDD 任务？
risks:
  - 如果用户需要全文搜索，应退回 architecture 阶段确认搜索层。
```

### 结论

通过。TDD 专家没有引入未确认架构变更。

## 6. 总结

`solo-spec-tdd` 黑盒测试覆盖了四类关键风险：

- 正常迭代能拆成红绿任务和 QA 计划。
- Bugfix 缺少回归测试时必须阻断 fix。
- 外部粗粒度任务不能照搬，必须拆成可独立验证行为。
- TDD 阶段不能引入未确认架构变更。

本轮没有发现章节映射错误；`tdd-contract.md` 的所有目标章节已通过模板对照校验。

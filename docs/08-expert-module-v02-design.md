# 专家模块 v0.2 设计方案

## 1. 阶段目标

v0.2 只定义专家模块契约，不默认接入 `/solo` 执行流。

目标：

- 把产品、调研、UX、架构、规格、TDD、QA、归档等能力拆成可组合专家。
- 允许借鉴 Superpowers、gstack、BMAD、Spec Kit、OpenSpec、taste 等方法，但所有输出必须落回 SoloSpec 的目录、章节、状态机和门禁。
- 保持 v0.1-alpha 主流程稳定，避免专家模块引入新目录、新阶段或绕过用户确认。

非目标：

- 不在 v0.2 默认自动调用专家。
- 不让专家直接写文件。
- 不让外部 Skill 自行决定目录结构。
- 不把项目级、功能级、Bugfix 文档重新合并成一个通用模板。

## 2. 核心原则

| 原则 | 规则 |
|---|---|
| 当前阶段优先 | 专家只能服务当前 branch + stage，不能提前写未来阶段文档 |
| Artifact Writer 统一写入 | 专家只输出结构化建议，由 SoloSpec 主流程决定是否写入 |
| 目录和章节不变 | 输出必须映射到 `solo/project/`、`solo/specs/`、`solo/decisions/` 或当前 spec `assets/` |
| 不确定内容不进基线 | 未确认方案只能留在当前规格过程文档，不能写进项目级结论 |
| 门禁不被专家绕过 | 专家可建议门禁问题，但不能把门禁标记为通过 |
| 外部输出需转换 | 外部 Skill 的报告、截图、设计稿、TDD 建议必须转换成 SoloSpec 章节或资产登记 |

## 3. 专家分层

| 层级 | 专家 | 作用 |
|---|---|---|
| 路由层 | router | 判断分支、阶段、是否恢复 |
| 产品层 | founder-review、staged-research、prd | 发散、事实核验、产品范围收敛 |
| 体验层 | ux-design | 用户流、页面、状态、设计系统、视觉资产登记 |
| 工程层 | architecture、spec、tdd | 技术方案、可执行规格、TDD 任务 |
| 验证层 | qa | 测试执行、截图、日志、回归证据 |
| 收口层 | archive | 归档、项目基线晋升、托管块建议 |

## 4. 阶段映射

### 4.1 新项目

| 阶段 | 可用专家 | 写入目标 | 说明 |
|---|---|---|---|
| intake | router | `state.json` | 只判断分支和入口，不写需求结论 |
| brainstorm | founder-review、staged-research | 不落盘 | 对话中发散，确认后进入 scope |
| scope | founder-review | `project/brief.md` | 只写已确认方向、用户、场景、MVP 边界 |
| prd | prd、staged-research | `project/prd.md` | 产品范围、非目标、成功指标 |
| ux | ux-design、staged-research | `project/ux.md`、`project/design-system.md`、`project/assets/` | 项目级体验和设计基线 |
| architecture | architecture、staged-research | `project/architecture.md`、`decisions/ADR-*.md` | 技术栈和架构层只列已采用或需决策项 |
| spec | spec | `specs/001-mvp/spec.md` | 进入统一 SDD/TDD 包 |
| design | ux-design | `specs/001-mvp/design.md`、`specs/001-mvp/assets/` | MVP 级 UI/交互细节 |
| plan | architecture | `specs/001-mvp/plan.md`、ADR | 影响文件、接口、风险、回滚 |
| tdd-plan | tdd | `specs/001-mvp/tasks.md`、`qa.md` 测试计划 | 不写假 QA 结果 |
| qa | qa | `qa.md`、`assets/screenshots/` | 真实执行记录和证据 |
| archive | archive | `archive.md`、必要的 `project/release.md`、`quality.md`、`pitfalls.md` | 只晋升可复用结论 |

### 4.2 迭代

| 阶段 | 可用专家 | 写入目标 | 说明 |
|---|---|---|---|
| read-context | staged-research | 不写或写当前 `brainstorm.md` 背景段 | 只读取项目基线、相关 specs 和代码 |
| brainstorm | founder-review | `specs/NNN-name/brainstorm.md` | 保留发散方案、组合点、未采纳方向 |
| scope | founder-review、spec | `proposal.md` | 收敛为本次迭代边界 |
| spec | spec | `spec.md` | 用户故事、场景、验收标准 |
| design | ux-design | `design.md`、`assets/` | 只处理本次迭代触达的页面和状态 |
| architecture | architecture | `plan.md`、ADR | 当前迭代技术影响 |
| tdd-plan | tdd | `tasks.md`、`qa.md` 测试计划 | TDD 分解 |
| qa | qa | `qa.md`、`tasks.md` 完成记录 | QA 发现 Bug 时留在当前 spec 内闭环 |
| archive | archive | `archive.md`、必要的项目级基线 | 归档时再晋升项目级变化 |

### 4.3 Bug 修复

| 阶段 | 可用专家 | 写入目标 | 说明 |
|---|---|---|---|
| reproduce | qa | `proposal.md` 或当前 spec `qa.md` | 无复现不修复 |
| root-cause | architecture | `plan.md` | 无根因不修复 |
| regression-test | tdd、qa | `tasks.md`、`qa.md` | 先写回归测试或明确测试方法 |
| fix | tdd | 代码、测试、`tasks.md` | 最小修复 |
| verify | qa | `qa.md`、`assets/screenshots/` | 真实验证 |
| archive | archive | `archive.md`、必要的 `project/quality.md` 或 `pitfalls.md` | 不默认创建 `spec.md`、`design.md` |

### 4.4 老项目接入

| 阶段 | 可用专家 | 写入目标 | 说明 |
|---|---|---|---|
| intake | router | `state.json`、基础目录 | 不改业务代码 |
| inventory | staged-research | `project/brief.md` | 盘点现有代码和文档 |
| classify | architecture、qa | `project/architecture.md`、`quality.md` | 建立事实基线 |
| summarize-project | prd、archive | `project/brief.md`、`pitfalls.md` | 不默认写 `project/prd.md` |
| propose-adoption-plan | spec | `project/brief.md` 后续建议 | 不创建 specs |
| write-managed-blocks | archive | 托管块目标文件 | 用户确认后才写 |

## 5. 外部 Skill 适配

| 外部能力 | 允许角色 | 转换规则 | 禁止 |
|---|---|---|---|
| Superpowers TDD | Advisor / Reviewer | 转为 `tasks.md` 的 TDD 任务、red/green 命令、回归验证 | 直接改任务顺序或跳过门禁 |
| gstack QA / review | Reviewer / Generator | QA 结论写 `qa.md`，截图进 `assets/screenshots/` | 把报告放到自建目录 |
| BMAD 产品/架构 | Advisor | 产品建议写当前 `brief.md/prd.md/proposal.md`，架构建议写 `architecture.md/plan.md` | 把未确认想法写成项目基线 |
| Spec Kit / OpenSpec | Advisor / Reviewer | 规格建议写 `spec.md`、`design.md`、`plan.md` 对应章节 | 另建 `.specify/`、`open-spec/` 等目录 |
| taste / 设计生成 | Generator / Reviewer | 项目级资产进 `project/assets/global-mockups/`，规格级资产进当前 spec `assets/mockups/`，登记到 `design-system.md` 或 `design.md` | 让设计产物只存在外部目录或不登记 |

## 6. 结构化输出契约

专家输出必须是结构化对象，主流程再决定是否写入：

```text
expert:
branch:
stage:
mode: reviewer | advisor | generator
summary:
findings:
recommendation:
writeTargets:
  - file:
    section:
    content:
assets:
  - path:
    registerIn:
    description:
gate:
  required:
  question:
discarded:
  - reason:
risks:
```

要求：

- `file` 必须是 SoloSpec 允许的相对路径，例如 `project/prd.md` 或 `specs/001-mvp/tasks.md`。
- `section` 必须是目标模板中已有章节，或由当前阶段允许新增的章节。
- `assets.path` 必须位于 `project/assets/` 或当前 spec `assets/`。
- `discarded` 记录被丢弃的外部输出及原因，防止隐性污染。

## 7. 转换和丢弃规则

必须转换：

- 外部调研结论要补来源、适用阶段和写入章节。
- 外部设计图要登记生成目的、使用位置和版本。
- 外部测试建议要变成可执行命令或可检查步骤。
- 外部架构建议要说明采用层、边界、风险和回滚。

### 7.1 未确认产品建议

外部产品建议必须先按当前 branch + stage 处理：

| 场景 | 处理 |
|---|---|
| new-project `brainstorm` | 只在对话中作为候选方案呈现，不落盘 |
| new-project `scope` 之前 | 不写 `project/brief.md`、`project/prd.md` 或任何项目级基线 |
| iteration `brainstorm` | 可写当前 `specs/NNN-name/brainstorm.md` 的候选方案、未采纳方向、待验证事实 |
| iteration `scope` | 用户确认后写 `proposal.md` |
| branch 或 stage 不明确 | 不写入；要求补齐上下文或放入 `discarded` |

未经用户确认的 pivot、目标用户变化、商业模式变化、架构级依赖变化，不得写成项目级结论。

### 7.2 外部资产复制和登记

外部 Generator 产物不能只保留在临时目录。采用时必须复制到 SoloSpec 资产目录并登记。

| 资产类型 | 目标目录 | 登记位置 |
|---|---|---|
| 项目级视觉参考 | `project/assets/global-mockups/` | `project/design-system.md` |
| 项目级品牌资产 | `project/assets/brand/` | `project/design-system.md` |
| 规格级线稿 | 当前 spec `assets/wireframes/` | 当前 spec `design.md` 第 4 节“设计产物” |
| 规格级高保真 | 当前 spec `assets/mockups/` | 当前 spec `design.md` 第 4 节“设计产物” |
| QA 截图 | 当前 spec `assets/screenshots/` | 当前 spec `qa.md` 执行记录 |
| 参考资料 | 当前阶段 `assets/references/` | 当前阶段文档的证据或参考段 |

文件命名使用英文 kebab-case：`source-purpose-variant.ext`。同一批多个文件追加两位序号，例如 `taste-dashboard-overview-01.png`。登记时必须记录原始来源、生成目的、适用页面或状态、版本或批次。

### 7.3 跨阶段建议

专家可能在当前阶段给出后续阶段建议。处理规则：

| 当前阶段 | 可保留 | 必须丢弃 |
|---|---|---|
| bugfix `regression-test` | 回归测试、预期失败、可检查命令；最小修复方向可写入 `tasks.md` 的实现范围候选，但不得执行 | 框架迁移、全量重写、`.specify/` 或其他自建目录 |
| bugfix `fix` | 当前根因对应的最小实现和回归验证 | 与根因无关的重构、产品迭代、架构迁移 |
| design | 资产登记、交互状态、视觉评审 | 直接修改 UI 代码 |
| architecture | 架构选型、ADR、风险和回滚 | 未经确认直接改依赖或迁移框架 |

框架迁移、技术栈替换、数据模型重做默认不是 Bugfix 内容。除非用户明确转为迭代或架构决策，否则写入 `discarded`。

必须丢弃：

- 自建目录结构。
- 与当前 branch/stage 无关的未来阶段内容。
- 未确认却写成已确认的结论。
- 没有来源的版本、API、模型、价格、平台能力断言。
- 绕过用户确认的发布、归档或托管块建议。

## 8. v0.2 验收标准

v0.2 设计完成的判定标准：

- 任一专家输出都能映射到明确文件和章节。
- 任一外部 Skill 输出都能被归类为 Reviewer、Advisor 或 Generator。
- 出现不适配内容时，有明确丢弃规则。
- 不需要修改 v0.1-alpha 的目录结构和主状态机。
- 独立子代理能根据契约判断外部输出应写入哪里、哪些内容必须丢弃。

## 9. 后续实施顺序

1. 完成契约文档和 `references/experts.md` 精简同步。
2. 用黑盒子代理验证三个场景：产品建议、设计稿、TDD/QA 建议。
3. 根据黑盒结果补充丢弃规则和写入目标。
4. 再决定是否把专家模块作为显式增强命令接入 `/solo`。

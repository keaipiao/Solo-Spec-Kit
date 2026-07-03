# `/solo` 状态机

## 1. 状态机目标

状态机负责把用户的一句话请求，稳定推进到正确分支、正确阶段、正确文档位置。

它解决四个问题：

- 当前请求属于新项目、迭代、Bug 修复还是老项目接入。
- 当前阶段应该读取哪些上下文。
- 当前阶段应该调用哪些专家模块。
- 当前阶段完成后写入哪里、是否停下等用户确认。

## 2. 状态字段

`solo/state.json` 是恢复 `/solo 继续` 的唯一状态源。

| 字段 | 说明 |
|---|---|
| version | 状态文件版本 |
| branch | `new-project`、`iteration`、`bugfix`、`adopt-existing` |
| currentSpec | 当前迭代目录名；项目级阶段可为 `null` |
| currentStage | 当前阶段 |
| gate.status | `open`、`waiting_user`、`passed`、`blocked` |
| gate.requires | 当前等待用户确认项的 ASCII 短码 |
| lastAction.summary | 最近一次动作摘要 |
| lastAction.artifacts | 最近一次写入或生成的产物 |
| updatedAt | 更新时间 |

`state.json` 必须始终是合法 JSON。写入规则：

- 使用 JSON 解析器或序列化工具更新，不手写拼接字符串。
- 每次更新后立即解析验证；失败时停在当前阶段修复状态文件。
- 长说明写入对应 Markdown 产物，`state.json` 只放短摘要和产物路径。
- `gate.requires` 优先使用 ASCII 短码；中文门禁说明写在当前阶段 Markdown 和阶段完成消息中。

## 3. 全局状态转换规则

| 当前状态 | 触发 | 下一状态 | 规则 |
|---|---|---|---|
| 无 `solo/state.json` | `/solo <请求>` | `intake` | 先判断分支，不直接写业务代码 |
| `waiting_user` | 用户明确“通过 / 继续 / 按这个来 / 确认” | 下一阶段 | 先把当前阶段文档门禁区和 `state.json.gate` 回写为已通过，再推进 |
| `waiting_user` | 用户提出修改意见 | 当前阶段 | 修改当前阶段产物，不跨阶段 |
| `blocked` | 用户补齐阻塞信息 | 当前阶段 | 重新执行当前阶段 |
| 任意 | `/solo 继续` | 当前阶段 | 读取状态并复述门禁，不自动越过 |

## 4. 分支路由

| 分支 | 触发信号 | 初始写入 |
|---|---|---|
| new-project | 新想法、从零开始、我要做一个产品 | `state.json`、基础目录、按阶段生成 `solo/project/` 结论文档 |
| iteration | 新增、修改、优化、删除既有能力 | `solo/specs/NNN-iteration-name/` |
| bugfix | 报错、失败、测试不过、页面坏了 | 关联迭代或 `solo/specs/NNN-bugfix-title/` |
| adopt-existing | 老项目接入、补规范、整理流程 | `solo/project/` 子集 |

无法判断时，状态停在 `intake`，只问一个分支问题。

## 5. New Project 流程

| 阶段 | 读取 | 专家模块 | 写入 | 门禁 |
|---|---|---|---|---|
| intake | 用户请求、仓库文件树 | router | `state.json`、基础目录 | 是 |
| brainstorm | 用户请求 | founder-review，必要时 staged-research | 不写过程文档 | 是 |
| scope | 用户选择、必要调研结论 | founder-review | `project/brief.md` | 是 |
| prd | `project/brief.md` | prd | `project/prd.md` | 是 |
| ux | `project/prd.md`、用户偏好 | ux-design，必要时 staged-research | `project/ux.md`、`project/design-system.md` | 有 UI 时是 |
| architecture | `project/prd.md`、`project/ux.md`、仓库上下文 | architecture，必要时 staged-research | `project/architecture.md`、必要 ADR | 是 |
| create-mvp-spec | `project/*.md` | spec | `specs/001-mvp/` 基础目录 | 否 |
| spec | `project/*.md` | spec | `specs/001-mvp/spec.md` | 是 |
| design | `project/ux.md`、`project/design-system.md`、`spec.md` | ux-design | `specs/001-mvp/design.md` | 有 UI 时是 |
| plan | `project/architecture.md`、`spec.md`、`design.md` | architecture | `specs/001-mvp/plan.md` | 是 |
| tdd-plan | `specs/001-mvp/*.md` | tdd | `specs/001-mvp/tasks.md`、`qa.md` 测试计划 | 是 |
| implementation | `tasks.md`、项目代码 | tdd | 代码、测试、`tasks.md` 完成记录 | 否 |
| qa | 代码、`qa.md` | qa | `qa.md`、`assets/screenshots/`、必要回归测试 | 是 |
| ship/archive | 全部产物 | archive | `archive.md`、必要 `project/release.md`、`project/quality.md`、`project/pitfalls.md` | 是 |

新项目的前置流程写 `project/`。`project/` 只保存确认后的项目结论，不保存 brainstorm 过程、未采纳方案和临时不确定项。项目级 `architecture` 通过后，再创建 `specs/001-mvp/` 进入统一 SDD/TDD 包。

架构阶段必须在内部做需求触发判断：如果 PRD、UX 或约束中出现登录、权限、角色、持久化、长任务、搜索、AI、第三方集成、生产运维或安全审计，必须主动扩展对应架构层，并在影响技术事实时触发 staged-research。触发判断不写入 `architecture.md`；文档只沉淀实际采用的架构层和关键架构边界。

## 6. Iteration 流程

| 阶段 | 读取 | 专家模块 | 写入 | 门禁 |
|---|---|---|---|---|
| intake | 用户请求、`state.json` | router | `state.json` | 是 |
| read-context | `project/`、相关 `specs/`、代码 | staged-research | 不写或写 `brainstorm.md` 背景草案 | 否 |
| brainstorm | 用户请求、上下文 | founder-review，必要时 staged-research | `brainstorm.md` | 是 |
| scope | `brainstorm.md`、用户选择、上下文 | founder-review | `proposal.md` | 是 |
| spec | `proposal.md`、上下文 | spec | `spec.md` | 是 |
| design | `spec.md`、`project/design-system.md` | ux-design，必要时 staged-research | `design.md`、`assets/wireframes/`、`assets/mockups/` | 有 UI 时是 |
| architecture | `spec.md`、`design.md`、代码 | architecture，必要时 staged-research | `plan.md`、必要 ADR | 是 |
| tdd-plan | `spec.md`、`plan.md` | tdd | `tasks.md`、`qa.md` 测试计划 | 是 |
| implementation | `tasks.md`、代码 | tdd | 代码、测试、`tasks.md` 完成记录 | 否 |
| qa | 代码、`qa.md` | qa | `qa.md`、`assets/screenshots/`、必要回归测试 | 是 |
| archive | 全部迭代产物 | archive | `archive.md`、必要项目级文档更新 | 是 |

迭代流程里的 `brainstorm` 只负责发散多个可选方案，写入本次迭代的 `brainstorm.md`。`scope` 才负责基于用户选择和项目上下文收敛“为什么做、做什么、哪些不做、如何验收”，写入 `proposal.md`。

## 7. Bugfix 流程

| 阶段 | 读取 | 专家模块 | 写入 | 门禁 |
|---|---|---|---|---|
| intake | 用户报错、日志、截图 | router | `state.json` | 是 |
| reproduce | 代码、测试、运行环境 | qa | `qa.md` 或 bugfix `proposal.md` | 是 |
| root-cause | 错误、调用链、近期变更 | architecture、qa | `plan.md` 或关联迭代 `qa.md` | 是 |
| regression-test | 根因、现有测试 | tdd | `tasks.md` | 是 |
| fix | `tasks.md`、代码 | tdd | 代码、验证记录 | 否 |
| verify | 修复后代码 | qa | `qa.md` 新证据 | 是 |
| archive | 修复记录 | archive | 关联迭代 `archive.md` 或 bugfix `archive.md` | 是 |

Bug 归属规则见 `docs/04-template-contract.md`。

## 8. Implementation / QA 补充规则

implementation 阶段没有用户门禁，但不能跳过验证。若项目没有既有脚手架，可以创建满足当前 `plan.md` 的最小工程；新增运行环境、脚本和入口必须记录到 `tasks.md`。不要引入未被架构采纳的框架或依赖。

时间相关行为必须使用可控时间或状态推进测试覆盖，包括计时、轮询、过期、重试、排队和长任务进度。真实等待只能作为补充 QA，不作为唯一证据。

QA 阶段发现 Bug 时，仍留在当前规格内处理：先写入 `qa.md` 的问题记录，再补回归测试和最小修复，最后回写 `tasks.md` 完成记录并重新验证。只有用户在新会话独立提出 Bug，才进入 Bugfix 归属判断。

## 9. Adopt Existing 流程

| 阶段 | 读取 | 专家模块 | 写入 | 门禁 |
|---|---|---|---|---|
| intake | 用户请求、仓库文件树 | router | `state.json`、`config.json`、基础 `solo/` 目录 | 是 |
| inventory | README、docs、源码结构、配置 | staged-research | `project/brief.md` 草案 | 否 |
| classify | 代码和文档盘点 | architecture、qa | `project/architecture.md`、`project/quality.md` | 是 |
| summarize-project | 盘点结果 | prd、architecture | `project/brief.md`、`project/pitfalls.md` | 是 |
| propose-adoption-plan | 现状与缺口 | spec | `project/brief.md` 后续建议章节 | 是 |
| write-managed-blocks | 用户确认的托管块 | archive | AGENTS/CLAUDE/README/CHANGELOG 托管块 | 是 |

老项目接入默认不改业务代码，不移动现有目录。

## 10. 调研触发规则

调研不是固定前置阶段，而是每个阶段的可选检查。

| 阶段 | 默认是否调研 | 触发条件 | 写入 |
|---|---|---|---|
| brainstorm | 是，轻量 | 候选方案依赖用户、痛点、竞品、替代方案等外部事实 | 新项目不落盘，用户确认后写入 `project/brief.md`；迭代写 `brainstorm.md` |
| scope | 按需 | 用户选择的方向缺少边界、证据或成功标准 | `project/brief.md` 或 `proposal.md` |
| prd / spec | 按需 | 成功指标、范围、用户故事缺证据 | `project/prd.md` 或 `spec.md` |
| ux / design | 按需 | 交互模式、页面结构、视觉方向不明确 | `project/ux.md`、`project/design-system.md` 或 `design.md` |
| architecture | 按需但严格 | 框架、SDK、API、版本、平台能力、外部依赖不确定 | `project/architecture.md`、ADR 或 `plan.md` |
| implementation | 少量 | 具体实现细节阻塞当前任务 | `tasks.md` 完成记录或 `plan.md` |

SoloSpec 需要主动提醒用户是否需要调研，但不把选择权完全丢给用户。

规则：

- 如果阶段结论依赖用户、竞品、API、版本、模型、平台能力等外部事实，必须提示并执行调研。
- 如果只是低风险的本地代码复用判断，直接读仓库即可，不需要向用户请求“是否调研”。
- 如果调研会明显增加时间或需要联网广搜，先说明目的、范围和预计产物，再等用户确认。
- 用户主动说“不调研，直接做”，只能跳过低风险调研；涉及技术/API/版本/平台能力的事实仍必须核实。

## 11. 阶段完成格式

每个阶段完成时必须输出：

```text
阶段：
写入：
验证：
门禁：
等待用户确认：
```

如果阶段没有验证，必须说明原因。

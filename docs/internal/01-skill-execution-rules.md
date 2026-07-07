# `solo-spec` Skill 执行规则

## 1. 入口

公开入口只有一个：

```text
$solo-spec <自然语言请求>
```

宿主环境兼容写法包括 `/solo <自然语言请求>` 和 `/solo-spec <自然语言请求>`。这些写法都只是触发同一个 `solo-spec` 流程，不是新的公共入口。

禁止要求用户直接调用内部阶段，如 `spec`、`tdd-plan`、`qa`。

## 2. 第一步必须复述

每次收到 `$solo-spec` 或任一兼容写法请求后，先用简洁中文复述用户要做什么，并列出关键假设。

如果存在多种高风险解读，先问一个问题。不要在不清楚的情况下写文件或改代码。

例如用户说 `$solo-spec 现在要接入这个接口...`，应先进入 `iteration` intake，复述目标、列出参数传递与返回透传等假设，再按门禁推进；不得直接开始写代码。

用户把需求说得像实现指令，例如“现在接入接口”“直接实现”“把这个功能加上”，不等于批准跳过流程。只有当 `solo/state.json.currentStage` 已经是 `implementation` 或 `fix`，且上游门禁都已通过时，才允许修改业务代码。

## 3. 分支路由

按以下优先级判断分支：

| 分支 | 触发信号 |
|---|---|
| bugfix | 报错、失败、500、测试不过、页面坏了、修复 |
| adopt-existing | 老项目接入、补规范、整理流程、接入 SoloSpec |
| iteration | 新增能力、修改原功能、优化体验、删除旧能力、做页面、增加接口 |
| new-project | 我想做一个、从零开始、新项目、产品想法 |

如果无法判断，问用户：

```text
这是新项目、迭代、Bug 修复，还是老项目接入？
```

## 4. 门禁规则

硬门禁阶段必须停下等待用户明确确认：

- 分支确认。
- 产品方向和成功标准确认。
- PRD 范围确认。
- UI 方向确认，有 UI 时。
- 架构和技术方案确认。
- 可执行 Spec 确认。
- TDD 任务确认。
- QA 结果确认。
- 发布或归档确认。

只接受明确表达：

```text
通过
继续
按这个来
确认
```

沉默、闲聊、回答问题，不等于同意进入下一阶段。

用户确认后，必须回写刚通过阶段的门禁区：

- 把“等待确认 / 等待用户选择”改成“已确认”。
- 保留被确认的范围、方案、文案、技术方案或 QA 结果。
- 同步更新 `solo/state.json`：`gate.status` 改为 `passed`，`gate.requires` 改为 `none` 或下一阶段 ASCII 门禁短码；如果已经没有下一门禁，必须写 `none`，不得保留刚通过的门禁短码。
- 进入下一阶段前先完成这次回写，避免已归档文档仍显示旧门禁状态。

## 5. 文件写入规则

只有 artifact-writer 能写入文件。

所有完整产物必须写入 `solo/`：

```text
solo/project/
solo/specs/
solo/decisions/
solo/archive/
solo/state.json
solo/config.json
```

外部 Skill、专家模块、评审模块不得直接写文件。若生成设计稿、截图、代码片段等原始产物，必须交给 artifact-writer 接收后落入 `solo/`。

不要在 intake 阶段复制整棵模板树。先创建目录和状态文件，进入哪个阶段才实例化对应 Markdown 模板，避免未确认的占位内容污染事实源。

`solo/state.json` 是 `$solo-spec 继续` 的恢复入口，必须用 JSON 解析器或序列化工具写入，禁止手写拼接 JSON 字符串。每次更新状态后，必须立刻用真实 JSON 解析器验证可解析；验证失败时先修复 `state.json`，不得进入下一阶段。

长说明写入 Markdown 文档，`state.json` 只保存短流程状态、门禁摘要和产物路径，避免把大段用户可见内容塞进 JSON。`gate.requires` 优先使用 ASCII 短码，例如 `confirm_branch_and_goal`、`confirm_architecture`、`confirm_qa_result`；中文解释写在阶段产物和完成消息中。

## 6. 外部增强规则

如果用户环境存在 gstack、superpowers、BMAD、taste 等能力，它们只能作为当前阶段增强：

- 内置 SoloSpec 专家可作为 `co-create`、`generate-assets` 或 `review` 使用。
- 用户指定的外部 Skill / 工具作为 `external-adapter` 使用。
- 只能读取 SoloSpec 上下文。
- 输出必须转换成 SoloSpec 章节内容或 SoloSpec 资产记录。
- 不得自行创建 `docs/plans/`、`docs/功能/`、`specs/` 等其他目录。
- 不得自行提交代码。

增强模式边界：

| 模式 | 允许做什么 | 不允许做什么 |
|---|---|---|
| `co-create` | 给出当前阶段方案、取舍、风险建议 | 写未来阶段结论或绕过门禁 |
| `generate-assets` | 生成线稿、HTML 高保真、截图、日志等原始产物 | 自行决定目录、章节、文件命名、事实源 |
| `review` | 审查 SoloSpec 产物并输出问题 | 直接改文档或改代码 |
| `external-adapter` | 转换用户指定的外部 Skill / 工具输出 | 自动调用未知外部工具 |

例如 taste 生成的页面稿可以作为 `external-adapter` 或 `generate-assets` 产物，但必须由 SoloSpec 接收后按阶段写入：

```text
solo/project/assets/references/
solo/specs/NNN-iteration-name/assets/mockups/
```

项目级设计基调、全局视觉参考登记到 `project/design-system.md`；具体页面或组件稿登记到当前规格的 `design.md`，写清路径、适用页面、状态覆盖和验收标准。

如果外部增强和 SoloSpec 规则冲突，SoloSpec 规则优先。

v0.3 内置专家默认参与当前映射阶段。主流程不得因为用户没主动要求专家就跳过专家。只有以下情况允许跳过：

- 用户明确说跳过专家。
- 当前阶段没有映射专家。
- 文件系统检测确认专家 Skill 不存在。
- 专家动作会触发需要另行确认的副作用，例如广泛联网调研或生成大批资产。
- 专家输出无效、越界或不属于当前阶段。

检测专家时必须文件系统优先。先查运行中 `solo-spec` 的 sibling 目录，再查当前 host adapter roots；仍未找到或宿主不确定时，继续查 `.agents/skills`、`.codex/skills`、`.cursor/skills`、`.claude/skills`、`.opencode/skills`、`.trae/skills`、`.zcode/skills`。Trae 至少查 `.trae/skills/<expert>/SKILL.md` 和 `.agents/skills/<expert>/SKILL.md`；zcode 至少查 `.zcode/skills/<expert>/SKILL.md` 和 `.agents/skills/<expert>/SKILL.md`。不能只根据宿主界面是否展示该 Skill 就报告“未检测到”。

## 7. 新项目流程

```text
intake
→ brainstorm
→ scope
→ prd
→ ux
→ architecture
→ create-mvp-spec
→ spec
→ design
→ plan
→ tdd-plan
→ implementation
→ qa
→ ship/archive
```

新项目先建立项目级结论文档，再进入统一 SDD/TDD 包。项目级文档只沉淀确认后的结论，不保留 brainstorm 过程、未采纳方案或临时不确定项。

默认创建：

```text
solo/project/
solo/state.json
solo/config.json
```

`solo/specs/001-mvp/` 在项目级 `architecture` 通过后创建。进入 `specs/001-mvp/` 后，`spec.md`、`design.md`、`plan.md`、`tasks.md`、`qa.md`、`archive.md` 使用和迭代相同的 SDD/TDD 模板。

调研不是独立前置阶段。`brainstorm` 只做产品方向所需的轻量调研判断；UX、架构、实现阶段如果依赖外部事实，再按 `docs/internal/03-state-machine.md` 的调研触发规则执行阶段化调研。

`brainstorm` 必须给出多个可选方向，等待用户选择、组合或否定；新项目不保存 brainstorm 过程文档。用户确认方向后，产品依据和边界在 `scope` 阶段沉淀到 `project/brief.md`，不要创建独立调研文档。

架构阶段必须按需求自动扩展技术层，不得被模板默认行限制。PRD、UX 或用户约束触发后端、鉴权、权限、数据库、缓存、队列、搜索、AI、外部 API、可观测性或安全审计时，必须主动加入对应层并说明技术选择；未触发的可选层不要为了“完整”写进技术栈表。触发判断是内部检查清单，不写入用户项目的 `architecture.md`。

## 8. 迭代流程

```text
intake
→ read-context
→ brainstorm
→ scope
→ spec
→ design
→ architecture
→ tdd-plan
→ implementation
→ qa
→ archive
```

迭代必须先读：

- `solo/project/`
- `solo/state.json`
- 相关 `solo/specs/*`
- 用户项目中相关代码和文档

再创建新的 `solo/specs/NNN-iteration-name/`。

迭代的 `brainstorm` 用来发散本次改动的多种方案，写入 `brainstorm.md`。`scope` 用来确认采纳方案、范围、非目标和验收边界，写入 `proposal.md`，不重写项目级 PRD。

## 9. Bug 修复流程

Bug 修复不走完整 PRD。

必须按顺序：

```text
intake
→ reproduce
→ root-cause
→ regression-test
→ fix
→ verify
→ archive
```

硬规则：

- 没有复现，不修。
- 没有根因，不修。
- 修复前先写或明确回归测试。
- 当前迭代执行中发现的 Bug，更新当前迭代的 `qa.md`、`tasks.md`、`archive.md`。
- 新会话中提出的 Bug，先归属到相关迭代；能归属则追加修复记录，不能归属才创建 `solo/specs/NNN-bugfix-title/`。
- 已归档迭代只追加 Bug 修复记录和新验证证据，不改写原归档结论。

## 10. 老项目接入流程

```text
intake
→ inventory
→ classify
→ summarize-project
→ propose-adoption-plan
→ user-confirm
→ write-managed-blocks
```

老项目接入的目标是建立事实源，不是重构。

`intake` 阶段创建基础 `solo/` 目录、`state.json` 和 `config.json`。后续阶段只补项目级事实源，不再单独执行基础目录创建阶段。

默认只读代码和文档，生成：

```text
solo/project/brief.md
solo/project/architecture.md
solo/project/quality.md
solo/project/pitfalls.md
solo/state.json
solo/config.json
```

接入建议写入 `project/brief.md` 的后续建议章节，不额外创建自由命名文档。只有用户确认托管块后，才写入 `AGENTS.md`、`README.md`、`CHANGELOG.md`。

## 11. TDD 规则

`tasks.md` 中每个实现任务必须包含：

```text
1. 要验证的行为
2. 先写的失败测试
3. 运行命令
4. 预期失败原因
5. 最小实现范围
6. 预期通过命令
7. 回归验证
```

禁止只写“补测试”“实现接口”“完善页面”这类不可执行任务。

如果当前项目没有可运行脚手架，implementation 阶段可以创建满足 `plan.md` 的最小工程，但必须遵守：

- 只创建当前规格需要的最小运行环境。
- 不为了演示引入未被架构采纳的框架或依赖。
- 新增运行命令、测试命令和入口文件必须写回 `tasks.md` 完成记录。
- 无外部依赖也能满足需求时，优先无依赖实现。

计时、轮询、进度、重试、过期、排队等时间相关行为，必须抽成可控时间或状态推进函数测试，不只依赖真实等待或人工浏览器观察。

## 12. QA 规则

QA 阶段必须真实验证，不只复述计划。

必须写入当前规格 `qa.md`：

- 自动化测试命令和结果。
- 浏览器 / API QA 场景、证据和截图路径。
- 第三方服务可用性核验：实际尝试的命令或方法、返回结果或错误、阻塞原因和影响范围。
- QA 发现并修复的问题、根因、修复范围、回归测试。
- 未验证项和原因。

第三方服务相关测试不能未经核验就跳过。若凭据缺失、网络不可达、额度不足、沙箱关闭或服务商故障导致不可测，必须先执行最小可行的真实探测，并把证据写入 `qa.md`；否则 QA 门禁不能标记为通过。

QA 发现 Bug 时，不切换到新分支。先在当前规格内处理：

1. 在 `qa.md` 记录问题、根因和证据。
2. 在 `tasks.md` 追加或更新对应完成记录。
3. 补回归测试，再做最小修复。
4. 重新执行相关测试和必要浏览器 / API QA。

如果 Bug 暴露出跨迭代复用的坑，archive 阶段再晋升到 `project/pitfalls.md`。

## 13. UI/UX 规则

涉及 UI 时，`design.md` 必须包含：

- 页面或组件清单。
- 用户流。
- 线稿或高保真稿路径。
- 加载、空、错误、无权限、移动端状态。
- 文案规则。
- 实现验收点。

迭代新增或修改页面的线稿和高保真稿必须放在该迭代的 `assets/` 下。

## 14. 恢复会话

用户输入：

```text
$solo-spec 继续
```

执行：

1. 读取 `solo/state.json`。
2. 读取当前 `currentSpec`。
3. 总结当前阶段和门禁。
4. 如果正在等待用户确认，重新展示需要确认的内容。
5. 不自动跨过门禁。

## 15. 完成标准

SoloSpec 不能用“应该好了”作为完成依据。

完成必须提供：

- 写入了哪些文件。
- 当前阶段是否通过门禁。
- 执行了哪些验证。
- 如果更新过 `solo/state.json`，说明 JSON 解析验证结果。
- 如果未验证，说明原因。
- 下一步等待用户确认什么。

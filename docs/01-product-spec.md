# SoloSpec 产品规格

## 1. 产品定位

SoloSpec 是面向中文 AI 编程独立开发者的端到端流程 Skill。

用户只需要通过一个入口 `/solo` 输入自己的想法、迭代诉求、Bug 或老项目接入诉求，SoloSpec 负责分流、追问、按阶段调研、生成文档、设置门禁，并在用户确认后进入下一阶段。

核心目标不是多写文档，而是把 AI 编程从“想到哪做到哪”升级为“先验证、再设计、再规格化、再 TDD 实现、最后 QA 与归档”的可复用流程。

## 2. 目标用户

- 使用 Codex、Claude Code、Cursor 等 AI 编程工具的中文独立开发者。
- 有想法但缺少产品调研、需求分析、设计规范和工程纪律的新手开发者。
- 已经做过项目，但文档结构、功能规格、测试计划、发布记录不一致的开发者。
- 想把老项目接入规范流程，但不想被重构或侵入业务代码的开发者。

## 3. 核心原则

### 3.1 一个入口

公开入口只保留 `/solo`。

用户不需要理解 `spec`、`tdd-plan`、`qa` 等内部阶段命令。SoloSpec 自动识别意图；无法判断时，只问一个分流问题。

### 3.2 深度接入，可无痛插拔

SoloSpec 深度接入用户项目，但完整事实源统一放在根目录 `solo/`。

项目根目录的 `AGENTS.md`、`CLAUDE.md`、`README.md`、`CHANGELOG.md` 只写托管块或摘要同步。移除 SoloSpec 时，删除 `solo/` 和托管块即可，不破坏业务代码。

### 3.3 自主核心，吸收型集成

SoloSpec 不硬依赖 BMAD、Spec Kit、OpenSpec、Superpowers、gstack、taste 等外部 Skill。

这些顶级 Skill 的方法论可被吸收为内部专家模块，但最终流程、目录、章节、门禁、写入规则由 SoloSpec 统一控制。

外部 Skill 未来可以作为 Reviewer、Advisor 或 Generator，但不能绕过 SoloSpec 写入规则。

- Reviewer：只输出审查意见。
- Advisor：只输出方案建议。
- Generator：可生成设计稿、线稿、截图、代码片段等原始产物。

Generator 产生的文件必须交给 SoloSpec artifact-writer 接收、改名、登记并放入 `solo/` 对应目录。外部 Skill 不得自行决定目录、章节或事实源。

### 3.4 先确认，后推进

关键阶段必须停下，等待用户明确说“通过 / 继续 / 按这个来”。

沉默不是同意。用户回答某个问题也不是同意进入下一阶段。

### 3.5 产物即门禁

阶段完成必须有落地文档或验证证据。没有产物，不算完成。

## 4. 公开交互模型

### 4.1 唯一入口

```text
/solo <用户自然语言描述>
```

示例：

```text
/solo 我想做一个小红书博主用的 AI 选题工具
/solo 给现有项目加邮箱登录
/solo 这个接口 500 了，帮我修
/solo 把这个老项目接入规范流程
/solo 继续
```

### 4.2 内部分支

SoloSpec 自动路由到四类分支：

| 分支 | 场景 | 核心目标 |
|---|---|---|
| new-project | 从一个新想法开始 | 完成产品验证、项目级设计、MVP 规格和地基 |
| iteration | 新增、修改、优化或删除既有能力 | 生成迭代规格，按 TDD 实现 |
| bugfix | 修复 Bug 或测试失败 | 先复现和定位根因，再写回归测试和修复 |
| adopt-existing | 老项目接入 SoloSpec | 盘点现状、补项目级文档、建立后续规范 |

当 SoloSpec 无法可靠判断分支时，只问一个问题，让用户选择分支。

## 5. 标准阶段

不同分支会裁剪阶段，但核心阶段如下：

调研不是一次性前置做完，而是嵌入各阶段的“够用核实”：

- brainstorm 阶段调研用户、痛点、替代方案和竞品方向。
- ux 阶段调研交互模式、信息架构、视觉参考和可用性风险。
- architecture 阶段调研框架、SDK、API、版本、部署和兼容性。
- implementation 阶段只补局部实现不确定性，不重新做大范围方案调研。

这样做的原因是：技术架构依赖已确认的产品范围和 UX 约束；在 PRD 和 UI 方向未定前提前做完整技术调研，容易浪费时间并锁死错误方案。

| 阶段 | 产物 | 是否硬门禁 |
|---|---|---|
| intake | 意图复述、假设、分支判断 | 是 |
| brainstorm | 用户、场景、痛点、替代方案、反例 | 是 |
| staged-research | 当前阶段所需调研、事实核实、来源 | 是 |
| prd | 目标、范围、非目标、成功指标 | 是 |
| ux | 用户流、信息架构、线稿或高保真策略 | 有 UI 时是 |
| architecture | 技术架构、数据模型、接口、ADR、风险 | 是 |
| spec | 可执行规格：用户故事、验收标准、场景 | 是 |
| tdd-plan | 红灯测试、最小实现、验证命令 | 是 |
| implementation | 按 TDD 执行、最小修改 | 否 |
| qa | 单测、集成、浏览器或 API QA、证据 | 是 |
| ship | 发布、变更摘要、回滚、托管块同步 | 是 |
| archive | 归档、踩坑、遗留项、状态收尾 | 是 |

## 6. 内部专家模块

SoloSpec 将顶级 Skill 的强项吸收为内部专家模块。

| 模块 | 借鉴来源 | 职责 |
|---|---|---|
| founder-review | BMAD、gstack office-hours | 挑战想法、验证痛点、收敛 MVP |
| staged-research | BMAD、anysearch/firecrawl 思路 | 按阶段调研用户、竞品、设计、技术和最佳实践 |
| prd | BMAD | 需求、边界、成功指标 |
| ux-design | taste、gstack design-review | 用户流、线稿、高保真、状态清单、反 AI 味 |
| architecture | gstack plan-eng-review、BMAD architect | 架构、数据流、接口、风险、ADR |
| spec | Spec Kit、OpenSpec | 规格化需求、变更包、验收标准 |
| tdd | Superpowers | 红绿重构、测试先行、任务粒度 |
| qa | gstack QA | 真实浏览器/API 验证、截图和日志证据 |
| archive | piao-workflow、OpenSpec | 归档、踩坑、发布记录、状态恢复 |

专家模块只能产出结构化建议，最终写入由 SoloSpec 的 artifact-writer 统一完成。

## 7. 成功标准

SoloSpec 第一版成功，应满足：

- 用户只记住 `/solo` 一个入口。
- 新项目、迭代、Bug 修复、老项目接入都能被正确分流。
- 所有项目级和迭代级产物都落在 `solo/` 统一结构内。
- 所有关键阶段都有明确门禁和用户确认。
- 迭代级开发计划必须包含 TDD 红灯测试、最小实现和验证命令。
- UI 相关功能必须包含线稿或高保真稿、状态规划和验收标准。
- 老项目接入不默认重构、不移动原有业务代码。
- 删除 `solo/` 和托管块后，项目可以回到接入前状态。

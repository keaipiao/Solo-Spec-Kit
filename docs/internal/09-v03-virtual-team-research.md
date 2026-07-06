# SoloSpec v0.3 虚拟团队精细化调研

调研日期：2026-07-06

## 1. 结论

SoloSpec v0.2 的问题不在于文档模板，而在于产品定位偏保守：它把专家 Skill 当作“文档写完后的审查器”，而不是“阶段开始时参与设计、生成资产、做取舍的虚拟团队成员”。这会导致用户感受到的价值主要是文档规范和 TDD 纪律，而不是更强的产品、设计、架构和交付结果。

v0.3 应调整为“独立开发者虚拟团队编排器”：

- `solo-spec` 仍是唯一主入口，但必须主动调度内置专家，而不是只在门禁前提示。
- 专家分为前置共创、过程生成、后置审查三种模式，不能只有审查模式。
- 面向多 Agent 工具做适配层，不能继续在脚本和检测逻辑中硬编码 `codex` / `zcode`。
- 用户可见体验中文优先；机器可读字段可以保留英文，但必须被包在中文说明或隐藏结构中。
- 所有阶段都是重点项：产品发现、事实调研、UX、架构、TDD、实现、QA、发布都必须有专家参与、明确产物和可验证门禁。
- UI/UX 不应停留在 Markdown 线稿。必须把 `SVG` 线稿和可打开、可迭代的 `HTML` 高保真稿作为一等产物；PNG 只作为截图证据或预览导出，不作为高保真源稿。
- 架构阶段必须显式选择技术栈、数据流、部署边界、组件库和设计系统；Tailwind 只是样式工具，不等于组件体系。
- TDD、实现、QA、发布不能只消费前面文档，必须把测试、代码、证据和归档都纳入同等严格的虚拟团队流程。
- 所有专家和主流程都要内建反过度设计、反 AI 味 UI、反模板化输出规则。

## 2. 当前 SoloSpec v0.2 事实

### 2.1 已有优势

| 能力 | 当前状态 | 价值 |
| --- | --- | --- |
| 单入口 | 文档统一推荐 `$solo-spec <自然语言请求>` | 降低用户调用成本 |
| 标准目录 | 输出集中到 `solo/` 结构 | 便于长期维护和审计 |
| 四分支 | `new-project`、`iteration`、`bugfix`、`adopt-existing` | 覆盖主流开发场景 |
| 门禁 | 每阶段需要用户确认 | 避免无确认推进 |
| TDD | 明确红绿开发 | 约束实现质量 |
| 专家 Skill | 已有 product、ux、architecture、tdd、qa、release | 已具备虚拟团队雏形 |

### 2.2 主要缺口

| 缺口 | 现状证据 | 影响 |
| --- | --- | --- |
| 专家调用太晚 | v0.2 明确“不默认自动调用专家”，专家多在门禁前提示 | 专家只能评审，不参与早期设计 |
| 多工具适配不足 | 安装脚本只有 `codex`、`zcode` 两个 `Tool` 选项 | 无法自然覆盖 Claude Code、Cursor、OpenCode、Trae 等 |
| 英文专家契约外露 | expert packet 字段为 `stage`、`writeTargets`、`gate` 等 | 中文用户理解成本高 |
| 产品发现偏弱 | brainstorm 易变成收集需求，而不是挑战问题、用户和替代方案 | 做出来的东西可能不值得做 |
| 事实调研偏弱 | 外部事实没有形成阶段化研究产物和引用纪律 | 容易基于幻觉或过期信息决策 |
| UI 资产弱 | 模板只有 `design.md` 中登记线稿和高保真路径 | 没有强制生成真实视觉稿或 SVG |
| 架构设计弱 | 架构可走到 Tailwind，但不强制选择组件库、部署边界、数据流和 ADR | 容易变成全部手写组件或技术债堆积 |
| TDD 到实现闭环弱 | 已有 TDD 纪律，但专家更多是建议，不是持续监督红绿循环 | 测试计划和真实代码可能脱节 |
| QA 证据弱 | QA 专家可登记建议，但流程没有强制浏览器、日志、截图、复测证据 | “通过”可能缺少可复核证据 |
| 发布收口弱 | release 专家存在，但发布、README 托管块、变更记录、归档没有成为同等强门禁 | 项目长期维护价值下降 |
| 反过度设计不足 | 主 Skill 和专家 Skill 没有统一“精简优先”机制 | 可能把流程复杂化、文档化过度 |

## 3. 外部生态事实核验

### 3.1 Agent Skills 已是跨工具标准

Agent Skills 官方规范定义了 `SKILL.md`、`scripts/`、`references/`、`assets/`，并强调渐进加载：启动时只加载名称和描述，激活后再加载正文，需要时再读资源文件。规范还建议主 `SKILL.md` 保持小于 500 行，引用文件从 skill 根目录相对解析。

来源：[Agent Skills specification](https://agentskills.io/specification)

对 SoloSpec 的含义：

- 不应该把所有专家逻辑塞回主 Skill。
- 可以继续使用 `solo-spec-*` 专家目录，但每个专家的 `SKILL.md` 要瘦身，重逻辑下沉到 `references/`。
- `assets/` 应用于模板、SVG 示例、视觉稿参考，而不是只放 Markdown 模板。

### 3.2 Claude Code

Claude Code 官方文档确认：

- Skill 可由模型按相关性调用，也可用 `/skill-name` 直接调用。
- 旧 `.claude/commands/` 已与 skills 合并，同名 Skill 会形成 slash 调用。
- Claude Code 扩展了 Agent Skills 标准，支持 invocation control、subagent execution、dynamic context injection。
- `disable-model-invocation: true` 可阻止模型自动调用，只允许用户手动触发。
- skill 可运行在 subagent 中，并由 `agent` 字段指定执行环境。

来源：[Claude Code skills docs](https://code.claude.com/docs/en/skills)

对 SoloSpec 的含义：

- 如果 SoloSpec 希望“自动调用内置专家”，不应把专家设为手动-only。
- 对有副作用的步骤才使用 `disable-model-invocation: true`；纯评审或纯建议专家应允许自动调用。
- Claude Code 下应支持 `.claude/skills/` 和 `.claude/agents/`，而不是只识别 `.agents/skills/`。

### 3.3 Cursor

Cursor 官方文档确认：

- Cursor 支持 Agent Skills，自动从 `.agents/skills/`、`.cursor/skills/`、`~/.agents/skills/`、`~/.cursor/skills/` 加载，也兼容 `.claude/skills/`、`.codex/skills/`。
- Skill 可由 Agent 自动选择，也可在 Agent chat 中用 `/` 手动搜索调用。
- Cursor Rules 支持 `.cursor/rules/*.mdc`、项目规则、用户规则、团队规则和 `AGENTS.md`。
- Cursor Subagents 有独立上下文，可自动或手动委派，项目目录为 `.cursor/agents/`，并兼容 `.claude/agents/`、`.codex/agents/`。

来源：[Cursor skills](https://cursor.com/docs/skills.md)、[Cursor rules](https://cursor.com/docs/rules.md)、[Cursor subagents](https://cursor.com/docs/subagents.md)

对 SoloSpec 的含义：

- Cursor 不需要 `zcode` 风格单独特殊处理；它天然兼容 `.agents/skills/`。
- 如果要做 Cursor 最佳体验，应额外支持 `.cursor/skills/` 和 `.cursor/agents/`。
- `AGENTS.md` 可作为跨工具项目规则入口，适合写“总是中文、简洁优先、外科手术式修改”等项目规范。

### 3.4 OpenCode

OpenCode 官方文档确认：

- Skills 可放在 `.opencode/skills/`、`~/.config/opencode/skills/`、`.claude/skills/`、`~/.claude/skills/`、`.agents/skills/`、`~/.agents/skills/`。
- OpenCode 有 Build / Plan 主代理和 General / Explore / Scout 子代理；子代理可自动或通过 `@` 手动调用。
- OpenCode 自定义命令位于 `.opencode/commands/` 或 `~/.config/opencode/commands/`。
- OpenCode `AGENTS.md` 是项目规则，且兼容 `CLAUDE.md`。

来源：[OpenCode skills](https://opencode.ai/docs/skills/)、[OpenCode agents](https://opencode.ai/docs/agents/)、[OpenCode commands](https://opencode.ai/docs/commands/)、[OpenCode rules](https://opencode.ai/docs/rules/)

对 SoloSpec 的含义：

- OpenCode 适配层应支持 `.opencode/skills/`。
- 对 OpenCode，专家可以映射为 subagent 或 skill；需要在安装脚本中区分“Skill 安装”和“Agent 安装”。
- `AGENTS.md` 是更稳的跨工具规则承载点。

### 3.5 Trae

Trae 官方文档说明：

- Trae 支持 Skill，Skill 通过 `SKILL.md` 定义和管理。
- Trae 支持 Rules、MCP、创建和管理 agents。
- Trae 有 SOLO Agent / SOLO mode，用于复杂项目开发。

来源：[Trae skills](https://docs.trae.ai/ide/skills)、[Trae rules](https://docs.trae.ai/ide/rules?_lang=zh)、[Trae agents](https://docs.trae.ai/ide/agent)、[Trae SOLO mode](https://docs.trae.ai/ide/solo-mode)

限制说明：Trae 文档页面当前通过动态页面渲染，抓取工具没有返回稳定行号；以上结论来自官方搜索摘要和官方页面标题，需要后续在真实 Trae IDE 中安装验证。

对 SoloSpec 的含义：

- 不应假设 Trae 与 zcode 相同。
- v0.3 需要把 Trae 作为“待实机确认”的 adapter，而不是用猜测目录写死。

### 3.6 Spec Kit

Spec Kit 官方文档确认：

- 它定位为 Spec-Driven Development 工具，把规范放在 AI 辅助开发中心。
- 核心流程是 `Spec -> Plan -> Tasks -> Implement`。
- 支持 30+ 集成，并通过 `specify init --integration <agent>` 生成对应 agent 的命令文件、上下文规则和目录结构；未列出的工具可用 `generic` 集成。
- 社区扩展、presets、workflows 是一等能力。

来源：[Spec Kit docs](https://github.github.com/spec-kit/)、[Spec Kit SDD concept](https://github.github.com/spec-kit/concepts/sdd.html)

对 SoloSpec 的含义：

- SoloSpec 应学习“多工具 integration registry”，而不是安装脚本里写死两个工具。
- SoloSpec 的强项可以是中文虚拟团队和 TDD/QA，而不是重复 Spec Kit 的通用 SDD。
- `generic` 适配是必须有的兜底。

### 3.7 BMAD Method

BMAD 官方文档确认：

- BMAD 是从 ideation、planning 到 agentic implementation 的 AI 开发框架。
- 它提供 specialized AI agents、guided workflows 和根据复杂度调整的 planning。
- 入门引导以 `bmad-help` 为中心，会检测项目进度并推荐下一步。
- 流程分为 Analysis、Planning、Solutioning、Implementation。
- UX 设计、架构、epics/stories、implementation readiness 都是明确 workflow。
- 每个 workflow 可通过 `bmad-*` skill 调用，建议每个 workflow 使用新 chat。

来源：[BMAD docs](https://docs.bmad-method.org/)、[BMAD getting started](https://github.com/bmad-code-org/BMAD-METHOD/blob/main/docs/tutorials/getting-started.md)、[BMAD workflow map](https://github.com/bmad-code-org/BMAD-METHOD/blob/main/docs/reference/workflow-map.md)

对 SoloSpec 的含义：

- SoloSpec 缺少 `bmad-help` 式“下一步导航专家”。
- SoloSpec 当前只有统一主流程，缺少“复杂度轨道”：Quick / Method / Enterprise。
- UX、架构、实施就绪检查应是阶段核心，不应只是文档模板。

### 3.8 Superpowers

Superpowers 官方仓库说明：

- 它是完整的软件开发方法论，基于可组合 skills 和初始指令。
- 当发现用户在构建东西时，会先退一步确认真实目标，而不是直接写代码。
- 先抽取 spec，用户批准后再生成实施计划。
- 实施计划强调 red/green TDD、YAGNI、DRY。
- 之后进入 subagent-driven development，多个 agent 按任务执行、检查和审查。
- 支持 Claude Code、Codex App、Codex CLI、Cursor、OpenCode 等多个 harness。

来源：[Superpowers GitHub](https://github.com/obra/superpowers)

对 SoloSpec 的含义：

- SoloSpec 的 TDD 纪律方向是对的。
- 缺口在于专家和子代理的自动执行闭环不够强。
- v0.3 要保持“先理解再写代码”，但把产品、设计和架构的惊艳度补上。

### 3.9 gstack 和高质量设计类 Skill

本地已安装的 gstack 和设计类 Skill 显示出几个可借鉴机制：

- gstack 通过 skill routing 主动建议 office-hours、plan-ceo-review、plan-eng-review、design-consultation、qa、design-review 等。
- gstack QA / Design Review 强制使用浏览器、截图、控制台、响应式检查和报告，强调证据而不是口头判断。
- design-consultation 会先理解产品、研究场景、提出设计系统，并生成视觉预览或 mockup，再写 `DESIGN.md`。
- design-taste-frontend 内建反 AI 味规则：避免蓝紫色渐变、三列 feature 卡片、emoji、默认 Inter、过度圆角、过度卡片化。
- image-to-code 明确“视觉重要任务必须先生成设计图，再分析，再实现”，并偏好一节一张可读图，而不是压缩大拼图。

来源：本机 Skill 文件：

- `C:\Users\piaopiao\.codex\skills\gstack\SKILL.md`
- `C:\Users\piaopiao\.codex\skills\gstack-design-consultation\SKILL.md`
- `C:\Users\piaopiao\.codex\skills\gstack-design-review\SKILL.md`
- `C:\Users\piaopiao\.codex\skills\gstack-qa\SKILL.md`
- `C:\Users\piaopiao\.agents\skills\design-taste-frontend\SKILL.md`
- `C:\Users\piaopiao\.agents\skills\image-to-code\SKILL.md`

对 SoloSpec 的含义：

- v0.3 必须让视觉资产变成正式产物。
- UI 专家不应只审查 `design.md`，而要能在 UX 阶段生成 `assets/wireframes/*.svg`、`assets/mockups/*.html`、`DESIGN.md` 或 spec 级设计 token。
- QA 专家不应只写建议，要登记截图、日志、命令和复测结果。

## 4. 对用户提出问题的逐项判定

### 4.1 brainstorm 前询问技术栈偏好是否合适

不合适，除非用户一开始就给出明确技术约束。

原因：

- brainstorm 阶段目标是验证问题、用户、场景、痛点和范围，不是提前锁技术。
- 技术栈问题会把用户从产品思考拉到实现细节，尤其对独立开发者会造成“先选框架”的错觉。
- 更合理的位置是 architecture 阶段；如果产品阶段发现强约束，例如必须微信小程序、必须本地优先、必须 iOS，则记录为约束，而不是让用户提前做技术偏好选择。

v0.3 规则：

- brainstorm 只问产品问题。
- scope / PRD 可登记硬约束。
- architecture 阶段再提出技术栈候选，并说明每个候选的取舍。

### 4.2 英文字段和英文专家内容是否合理

对用户不合理，对机器可以保留。

建议分层：

- 用户可见层：中文标题、中文说明、中文门禁、中文建议。
- 机器契约层：保留 `stage`、`writeTargets`、`gate` 等英文 key，便于跨工具解析。
- 文档层：所有专家 Skill 的主要说明改为中文；英文只用于字段名、代码、路径、协议名。

v0.3 规则：

- expert packet 外层增加中文摘要：

```yaml
专家: solo-spec-product
阶段: brainstorm
结论摘要:
  - ...
写入建议:
  - 目标: solo/project/prd.md
    原因: ...
machine:
  expert: solo-spec-product
  stage: brainstorm
  writeTargets:
    - path: solo/project/prd.md
```

这样用户读中文，主流程读 `machine`。

### 4.3 所有 Skill 防止过度设计和 AI 味 UI

必须做，而且应该成为 v0.3 的横切规范。

主流程层：

- 每阶段都要写“非目标”和“本阶段不做”。
- 任何新增抽象、目录、工具、组件库都要写原因。
- 默认选择最小可行路径；只有在明确收益大于复杂度时扩大范围。

UI/UX 层：

- 禁止默认 emoji、蓝紫色渐变、呼吸灯、漂浮光斑、三列卡片、统一大圆角、无意义徽章。
- 要先判断产品类型：营销页、App UI、后台、移动端、公共服务、品牌页。
- 组件库优先于手写基础组件；视觉表达优先于装饰堆叠。

### 4.4 专家为什么写完文档后才调用

这是 v0.2 的核心产品缺陷。

合理设计应是三段式：

| 模式 | 调用时机 | 专家作用 | 例子 |
| --- | --- | --- | --- |
| 前置共创 | 阶段开始 | 产出候选方向、问题、方案 | 产品专家在 brainstorm 前提出用户细分和反例 |
| 过程生成 | 阶段中 | 生成资产或结构化草案 | UX 专家生成高保真稿、架构专家生成 ADR 候选 |
| 后置审查 | 阶段门禁前 | 查漏补缺、风险审查 | TDD 专家检查任务是否可红绿执行 |

v0.3 不能只做后置审查。

### 4.5 Tailwind 后不使用组件库是否合理

通常不合理。

Tailwind 是样式原子工具，不提供可访问性、复杂状态、表单、弹窗、菜单、表格、日期选择、组合框等产品级组件。全部手写会导致：

- 开发速度慢。
- 可访问性风险高。
- UI 状态不完整。
- 后期维护成本高。

v0.3 架构阶段必须加入“UI 基础选择”：

| 产品类型 | 默认候选 |
| --- | --- |
| Indie SaaS / 普通 Web App | shadcn/ui + Radix + Tailwind |
| 企业后台 / 数据密集 | Fluent UI、Carbon、Ant Design、Arco、Semi、Mantine 中择一 |
| Shopify App | Polaris |
| GitHub 风格开发者工具 | Primer |
| 公共服务 | GOV.UK Frontend / USWDS |
| 纯营销页 | Tailwind + Motion + 少量无障碍 primitives |

用户不应只看到“Tailwind”；应看到“样式方案 + 组件方案 + 动效方案 + 图标方案”。

### 4.6 什么时候生成高保真稿，为什么线稿在 Markdown 中

线稿不应只在 Markdown 中。

建议：

- `design.md` 只登记设计决策、链接和说明。
- 真实线稿写入 `assets/wireframes/*.svg`。
- 高保真源稿写入 `assets/mockups/*.html`；如需展示对比，可从 HTML 导出截图到 `assets/screenshots/`。
- 设计系统写入项目级 `solo/project/design-system.md` 或 spec 级 `design.md`。

生成时机：

| 场景 | 高保真时机 |
| --- | --- |
| 新项目有 UI | PRD 初版确认后、架构前 |
| 功能迭代涉及 UI | spec scope 确认后、TDD 前 |
| 纯后端 / CLI | 不生成，除非有文档图或流程图需要 |
| 老项目接入 | 先截图审计，再决定是否生成目标稿 |
| Bugfix | 只在视觉 bug 或交互 bug 时生成 before/after |

生成路径有两种：

- 线稿优先：先用 SVG 线稿确定信息架构、页面结构、关键状态，再生成高保真 HTML。
- 直接高保真：当需求、品牌方向和页面目标已经足够清楚时，可以跳过线稿，从 0 直接生成高保真 HTML。

## 5. v0.3 产品定位

### 5.1 一句话定位

SoloSpec 是面向中文独立开发者的虚拟产品团队：用一个 `$solo-spec` 入口，自动组织产品、UX、架构、TDD、QA、发布专家，把想法推进到可验证、可实现、可交付的代码和资产。

### 5.2 不再是什么

- 不是单纯的文档模板生成器。
- 不是只做 spec-first 的轻量流程。
- 不是专家建议收集器。
- 不是只适配 Codex 或 zcode 的安装包。

### 5.3 必须保留

- 一个主入口 `$solo-spec`。
- 四分支场景。
- 用户门禁。
- TDD 红绿开发。
- `solo/` 作为项目事实源。
- 未安装增强能力时可降级运行。

### 5.4 必须增强

- 自动发现和调用内置专家。
- 专家前置参与，而不只是门禁前审查。
- 产品阶段：挑战问题真实性、目标用户、现有替代方案、最小切入点和非目标。
- 调研阶段：把外部事实、竞品、平台限制、法规/API/价格等不稳定信息变成带来源的阶段化研究产物。
- UX 阶段：沉淀用户流程、信息架构、SVG 线稿和高保真 HTML。
- 架构阶段：明确技术栈、数据模型、模块边界、依赖、部署、回滚、安全和组件库。
- TDD 阶段：把规格拆成可红绿执行的测试任务，明确每个任务的失败条件和验收方式。
- 实现阶段：按红绿循环推进代码，持续保持测试、规格和实现一致。
- QA 阶段：用浏览器、接口、日志、截图和复测结果证明功能可用。
- 发布阶段：完成 changelog、README 托管块、归档、迁移说明和后续维护线索。
- 多工具 adapter registry。
- 中文优先用户体验。

## 6. v0.3 目标流程

### 6.1 新项目

```text
Intake
  -> Product Discovery
  -> Product Gate
  -> UX / Visual Direction
  -> Design Gate
  -> Architecture
  -> Architecture Gate
  -> Spec / TDD Tasks
  -> Build Red-Green Loop
  -> QA Evidence
  -> Release / Archive
```

### 6.2 每阶段专家职责

| 阶段 | 自动专家 | 主要产物 | 门禁问题 |
| --- | --- | --- | --- |
| Intake | product | 分支识别、问题摘要、已知约束、复杂度轨道建议 | 分支和轨道是否正确 |
| Product Discovery | product + research | 用户、痛点、替代方案、MVP、非目标、成功指标 | 问题是否值得做 |
| Research | product + architecture + qa | 竞品、平台/API/价格/法规事实、引用来源、待验证假设 | 关键事实是否足够可靠 |
| UX / Visual Direction | ux + design | 用户流程、信息架构、SVG 线稿、高保真 HTML、设计系统 | 用户是否认可体验方向 |
| Architecture | architecture | 技术栈、模块边界、数据流、数据模型、组件库、部署、ADR、风险 | 技术方案是否可执行 |
| Spec / TDD | tdd + architecture | 可红绿任务、测试计划、验收标准、回归范围 | 是否可进入实现 |
| Build | tdd + architecture | 实现、测试、提交说明、回归修复、偏差记录 | 是否通过红绿验证 |
| QA | qa + ux + architecture | 浏览器截图、接口结果、日志、缺陷、复测、性能/可访问性证据 | 是否可发布 |
| Release | release + qa | changelog、README 托管块、归档、迁移说明、后续 TODO | 是否完整收口 |

### 6.3 全阶段一等原则

每个阶段都必须满足同一组基本要求，不能只有 UI/UX 阶段精细化：

| 要求 | 说明 |
| --- | --- |
| 专家参与 | 当前阶段的内置专家默认参与，外部专家由用户指定 |
| 明确产物 | 产物必须能被后续阶段消费，不写无消费方文档 |
| 用户门禁 | 阶段结论必须经用户确认，不能由专家自动通过 |
| 证据来源 | 涉及事实、平台、依赖、价格、法规、API 时必须有来源或标记待验证 |
| 反过度设计 | 阶段内必须写非目标和本阶段不做 |
| 回退策略 | 架构、实现、发布阶段必须说明失败或回滚路径 |
| 可验证性 | 每个阶段都要给出下一阶段如何验证本阶段结论 |

### 6.4 复杂度轨道

参考 BMAD 的 Quick / Method / Enterprise，SoloSpec 应加入三个轨道：

| 轨道 | 适用场景 | 跳过项 |
| --- | --- | --- |
| Quick | 小 bug、明确小功能、无 UI | 可跳过高保真、完整 PRD |
| Standard | 普通独立项目和功能迭代 | 默认流程 |
| Deep | 新产品、复杂 UI、企业/合规/多端 | 增加研究、设计系统、架构审查、实施就绪检查 |

轨道由主流程建议，用户确认。

## 7. 多工具适配方案

### 7.1 不再使用硬编码 `Tool`

当前：

```powershell
[ValidateSet("codex", "zcode")]
[string]$Tool = "codex"
```

v0.3 应替换为 adapter registry：

```json
{
  "codex": {
    "skillRoots": [".agents/skills", ".codex/skills"],
    "agentRoots": [".agents/agents", ".codex/agents"],
    "ruleFiles": ["AGENTS.md"]
  },
  "cursor": {
    "skillRoots": [".cursor/skills", ".agents/skills", ".claude/skills", ".codex/skills"],
    "agentRoots": [".cursor/agents", ".claude/agents", ".codex/agents"],
    "ruleFiles": ["AGENTS.md", ".cursor/rules/solo-spec.mdc"]
  },
  "claude-code": {
    "skillRoots": [".claude/skills", ".agents/skills"],
    "agentRoots": [".claude/agents"],
    "ruleFiles": ["CLAUDE.md", "AGENTS.md"]
  },
  "opencode": {
    "skillRoots": [".opencode/skills", ".agents/skills", ".claude/skills"],
    "agentRoots": [".opencode/agent"],
    "ruleFiles": ["AGENTS.md", "CLAUDE.md"]
  },
  "trae": {
    "skillRoots": [".trae/skills", ".agents/skills"],
    "agentRoots": [".trae/agents"],
    "ruleFiles": ["AGENTS.md"],
    "status": "needs-real-ide-verification"
  },
  "zcode": {
    "skillRoots": [".zcode/skills", ".agents/skills"],
    "agentRoots": [".zcode/agents"],
    "ruleFiles": ["AGENTS.md"],
    "status": "locally-observed"
  },
  "generic": {
    "skillRoots": [".agents/skills"],
    "agentRoots": [".agents/agents"],
    "ruleFiles": ["AGENTS.md"]
  }
}
```

注意：`trae` 和 `zcode` 的具体目录需要实机验证后才能标记为 confirmed。文档和脚本不能把未验证路径写成事实。

### 7.2 安装脚本行为

建议参数：

```powershell
.\scripts\install-project-skills.ps1 `
  -ProjectPath <path> `
  -Mode enhanced `
  -Host cursor
```

行为：

- `-Host` 使用 registry 查路径。
- `-Host auto` 自动探测项目已有目录。
- `-Host generic` 只安装到 `.agents/skills`。
- 支持 `-ListHosts` 输出已支持和待验证 host。
- 输出必须说明安装到了哪些路径、哪些路径只是兼容路径、哪些 host 仍需实机验证。

### 7.3 检测逻辑

主 Skill 检测专家时不应只查 sibling、`.agents`、`.zcode`。应按 adapter registry 聚合：

- 当前运行 skill 同级目录。
- 当前项目 adapter roots。
- 用户级 roots。
- 兼容 roots。

但报告给用户时不要枚举所有 Skill。只报告当前阶段需要的专家和可替代项。

## 8. 专家调用机制 v2

### 8.1 自动调用边界

默认自动调用“只读或只产出建议/资产”的内置专家：

- `solo-spec-product`
- `solo-spec-ux`
- `solo-spec-architecture`
- `solo-spec-tdd`
- `solo-spec-qa`
- `solo-spec-release`

默认不自动调用外部未知 Skill。用户可指定外部 Skill。

### 8.2 专家模式

| 模式 | 是否自动 | 是否写文件 | 说明 |
| --- | --- | --- | --- |
| `co-create` | 是 | 只写 expert packet 或临时资产 | 阶段开始生成候选 |
| `generate-assets` | 经用户确认 | 可写到 `solo/.../assets/` | UX、高保真、SVG、QA 截图 |
| `review` | 是 | 不直接写主文档 | 门禁前审查 |
| `external-adapter` | 否 | 不直接写 | 用户指定外部 Skill 后适配输出 |

### 8.3 用户提示

旧：

```text
专家增强：当前阶段映射专家 $solo-spec-product。检测：未安装。
```

新：

```text
专家团队：
- 产品专家：已启用，正在参与本阶段问题澄清。
- UX 专家：本阶段暂不需要。
- 可选外部增强：你可以指定其他 Skill，我会把输出转成 SoloSpec 结构。

当前阶段不会直接进入技术栈选择；技术栈会在架构阶段讨论。
```

核心变化：不是“你要不要调用专家”，而是“我已按阶段使用内置专家；外部专家可选”。

## 9. UI/UX 资产流水线

### 9.1 目录

```text
solo/
  project/
    design-system.md
    assets/
      brand/
      references/
  specs/
    001-feature/
      design.md
      assets/
        wireframes/
          001-main-flow.svg
        mockups/
          001-main-screen.html
          002-mobile-state.html
        prototypes/
          main-flow.html
        screenshots/
          001-main-screen.png
```

### 9.2 线稿规则

- Markdown 中只放说明和链接。
- 线稿用 SVG 文件保存。
- 流程图可用 Mermaid，但界面线稿应是 SVG 或 HTML。
- SVG 文件必须有标题、尺寸、关键状态标注。

### 9.3 高保真规则

- 视觉质量重要时，先生成高保真 HTML，再实现产品代码。
- 高保真 HTML 可以由 SVG 线稿演进而来，也可以在需求明确时直接从 0 设计。
- 多页面或多区块时，优先一屏一图，避免一个压缩大图。
- 生成后必须做设计分析：字体、色彩、间距、组件、状态、响应式。
- 高保真 HTML 经用户确认后，成为实现参考；PNG 只用于截图留证和 before/after 对比。

### 9.4 设计系统规则

`design-system.md` 至少包括：

- 产品类型和受众。
- 视觉方向。
- 字体。
- 色板。
- 间距。
- 圆角。
- 动效。
- 图标库。
- 组件库。
- 禁止项。

## 10. 组件库选择门禁

架构阶段新增“UI 基础设施”小节：

| 决策 | 必填 |
| --- | --- |
| 样式工具 | 是 |
| 组件库 | 有 UI 时必填 |
| 图标库 | 有 UI 时必填 |
| 动效库 | 有明显动效时必填 |
| 表单方案 | 有复杂表单时必填 |
| 表格方案 | 有数据表时必填 |
| 可访问性策略 | 有 UI 时必填 |

若选择“不使用组件库”，必须写明：

- 为什么组件数量很少。
- 哪些组件会手写。
- 如何处理键盘、焦点、ARIA、错误态、空态、加载态。
- 未来何时切换到组件库。

## 11. 反过度设计与反 AI 味规范

### 11.1 全局反过度设计

- 每阶段最多问一个阻塞问题。
- 默认不引入新目录，除非该阶段产物确实需要。
- 每个新增专家、文档、资产目录都必须有消费方。
- `solo/` 中不写“待定”结论；不确定内容进入“待验证事实”或“开放问题”。
- 不因未来可能性引入抽象。

### 11.2 UI 反 AI 味

默认禁止：

- emoji 作为主要设计元素。
- 蓝紫色 AI 渐变。
- 呼吸灯、漂浮光斑、装饰粒子。
- 三列 feature 卡片模板。
- 全站居中。
- 图标放彩色圆圈。
- 统一超大圆角。
- 过度玻璃拟态。
- 假仪表盘、假状态标签、无意义技术小字。
- “Unlock / Elevate / Next-gen / Seamless”等泛化营销词。

### 11.3 专家约束

每个专家 Skill 增加统一章节：

```markdown
## 精简与反模板化

- 不输出超出当前阶段的实施细节。
- 不创建未来阶段结论。
- 不建议无消费方的文档或资产。
- UI 输出必须避免 SoloSpec 反 AI 味清单。
- 如果更简单方案足够，必须优先推荐更简单方案。
```

## 12. v0.3 实施任务清单

### P0：先修正产品方向

1. 新增本文档为 v0.3 设计依据。
2. 更新 `docs/internal/05-expert-module-v02-design.md`：标记 v0.2 是审查型专家，v0.3 要升级为虚拟团队。
3. 更新 `docs/internal/08-expert-integration-strategy.md`：从“门禁前提示”改为“三模式专家调用”。

### P1：多工具 adapter

1. 新增 `skills/solo-spec/references/host-adapters.md`。
2. 新增 `scripts/host-adapters.json`。
3. 改造 `scripts/install-project-skills.ps1`：
   - `-Host`
   - `-Host auto`
   - `-ListHosts`
   - `generic` fallback
4. 更新 README 和用户指南。
5. 增加安装脚本测试：
   - codex
   - cursor
   - claude-code
   - opencode
   - generic
   - zcode locally observed
   - trae needs verification

### P2：专家调用 v2

1. 主 Skill 阶段开始自动调度内置专家。
2. 专家输出增加中文摘要 + `machine` 结构。
3. 专家支持 `co-create`、`generate-assets`、`review`。
4. 门禁前报告“专家已做了什么”，而不是只问“是否调用专家”。
5. 外部 Skill 只在用户指定时适配。

### P3：产品发现和事实调研

1. `solo-spec-product` 增加问题挑战、替代方案、最小切入点、非目标和成功指标规则。
2. 新增阶段化 research packet：记录事实、来源、适用阶段、可信度和待验证项。
3. 主流程在 brainstorm / scope 阶段禁止提前询问技术栈偏好，除非用户已经给出硬约束。
4. 新增竞品和外部事实引用规则：涉及平台、API、价格、法规、标准时必须核实来源。

### P4：UX 和设计资产

1. `solo-spec-ux` 增加 SVG 线稿输出规则。
2. `solo-spec-ux` 增加高保真 HTML 触发规则。
3. 新增 `assets/wireframes/`、`assets/mockups/`、`assets/screenshots/` 模板目录。
4. `design.md` 改为登记资产、状态和设计决策，不再承载假线稿。
5. 架构阶段读取已确认 UX 流程、设计系统和高保真 HTML。

### P5：架构设计

1. `solo-spec-architecture` 增加技术栈、数据模型、模块边界、部署、回滚、安全、依赖和 ADR 决策表。
2. 增加 UI 基础设施决策表：样式工具、组件库、图标库、动效库、表单方案、表格方案。
3. 如果用户选择 Tailwind，必须继续选择组件库或明确“不使用组件库”的理由。
4. 架构专家必须输出“已有代码复用”和“明确不做”清单，防止重建已有能力。

### P6：TDD 和实现

1. `solo-spec-tdd` 把已确认规格拆成可红绿执行任务，每项包含失败测试、实现目标和验收命令。
2. 实现阶段必须持续同步规格偏差：代码实现改变设计时，要回写当前 spec 的偏差记录。
3. TDD 任务要覆盖领域逻辑、API、状态转换、错误处理、迁移风险；有 UI 时再覆盖 loading、empty、error、disabled、focus、mobile。
4. 对 bugfix 分支，先要求根因和回归测试，再允许实现修复。

### P7：QA 和发布

1. `solo-spec-qa` 增加浏览器、接口、日志、截图、响应式、可访问性和复测证据登记规则。
2. QA 不只检查 UI；后端、CLI、数据迁移和集成任务必须有对应验证命令和证据。
3. `solo-spec-release` 增加 changelog、README 托管块、迁移说明、归档摘要和后续 TODO 收口规则。
4. 发布阶段必须检查项目基线是否需要晋升，不能只归档当前 spec。

### P8：反过度设计和反 AI 味

1. 主 Skill 增加全局精简规则。
2. 六个专家 Skill 增加统一反过度设计章节。
3. UX 专家增加 UI 反 AI 味黑名单。
4. 架构专家增加反过度抽象规则。
5. TDD / QA / Release 专家增加“只验证当前承诺，不扩展无关范围”规则。

### P9：回归测试

1. 新项目全流程：验证产品、调研、UX、架构、TDD、实现、QA、发布都被触发并有产物。
2. 新项目 UI 流程：验证 UX 高保真 HTML、架构组件库、TDD、QA。
3. 纯后端功能：验证不会生成 UI 资产，但仍有产品范围、架构、TDD、QA 和发布证据。
4. bugfix：验证不会跑完整新项目流程，但必须有根因、回归测试和复测证据。
5. adopt-existing：验证先盘点已有代码和文档，再决定最小接入计划。
6. 未安装专家：验证降级。
7. 安装多 host：验证路径和检测。
8. 外部 Skill：验证用户指定后可适配但不自动调用。

## 13. 风险

| 风险 | 说明 | 缓解 |
| --- | --- | --- |
| 自动专家过度打扰 | 每阶段都自动输出可能变吵 | 只让内置专家自动参与，输出合并摘要 |
| 流程变重 | 全阶段专家和审查可能拖慢简单任务 | 引入 Quick / Standard / Deep |
| 多工具路径不准 | Trae、zcode 等目录需实机验证 | registry 标记 status，未验证不写成 confirmed |
| 资产生成能力依赖宿主 | 有些工具没有图像生成或浏览器能力 | 支持 fallback：SVG/HTML 线稿、外部 Skill、手动导入 |
| 专家输出不稳定 | 多专家可能互相冲突 | 主 Skill 保持唯一写入者和最终裁决者 |

## 14. 下一步建议

建议不要继续在 v0.2 上小修专家提示，而是开 v0.3 重构小步走：

1. 先做 host adapter registry，因为这会影响安装、检测和 README。
2. 再做 expert packet v2，把中文摘要和 `machine` 结构定下来。
3. 然后改主流程专家调用，从门禁前提示升级为全阶段前置共创。
4. 之后按阶段补齐产品调研、UX、架构、TDD/实现、QA、发布的产物和门禁。

这样可以先解决“多工具可用”和“专家真的参与”，再逐阶段提升产品判断、设计质量、架构可靠性、实现纪律、QA 证据和发布收口。

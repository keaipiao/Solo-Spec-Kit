# 专家 Skill 权威调研

调研日期：2026-07-03

## 1. 调研结论

专家模块应该做成独立 Skill，而不是塞进 `solo-spec` 的一个大文件里。

理由有三点：

- Skill 的主流标准就是“可独立发现、按需加载、可版本化”的能力包。OpenAI、Anthropic、Agent Skills 规范都把 Skill 定义为包含 `SKILL.md`、可选脚本、参考资料、模板和资产的文件夹。
- 顶级流程不是把所有专家知识常驻上下文，而是用渐进披露：入口 Skill 只负责路由和流程，专家 Skill 在被触发时再加载细节。
- 设计、产品、架构、TDD、QA 的判断方式不同。强行合并会让 `/solo` 变成大而全的提示词，增加上下文污染、目录越界和门禁绕过风险。

因此 SoloSpec 的专家策略确定为：

```text
solo-spec              # 唯一入口、状态机、目录、门禁、写入规则
solo-spec-product      # 产品、调研、头脑风暴、需求收敛
solo-spec-ux           # UX、设计系统、线稿、高保真、设计产物映射
solo-spec-architecture # 技术架构、依赖、ADR、风险和回滚
solo-spec-tdd          # TDD 拆分、红绿循环、回归测试建议
solo-spec-qa           # 验证、浏览器 QA、证据登记
solo-spec-release      # 归档、项目基线晋升、托管块建议
```

`solo-spec-*` 必须独立可用；一旦接入 `/solo`，必须只输出 expert packet，由 `solo-spec` 决定是否写入标准目录。

## 2. 来源分层

### 2.1 Skill 机制来源

| 来源 | 可借鉴点 | SoloSpec 结论 |
|---|---|---|
| Agent Skills 规范 | Skill 是包含 `SKILL.md` 的目录，可包含 `scripts/`、`references/`、`assets/`，按需加载 | 每个专家 Skill 保持独立目录，主 `SKILL.md` 不超过必要路由信息 |
| OpenAI Skills | Skill 适合可复用、可版本化、条件分支复杂、需要模板或脚本的流程 | 专家模块属于 Skill，不属于系统提示词或普通文档 |
| Anthropic Skills | 元数据常驻，完整说明和引用文件按需加载 | 专家 Skill 用 `references/` 承载长规则，不把所有专家内容塞进入口 |
| skills.sh | Skill 是开放生态中的可安装能力，排行榜显示设计、TDD、工作流类 Skill 已是高频需求 | SoloSpec 应兼容外部 Skill，但不能让外部 Skill 改写目录结构 |

### 2.2 SDD/TDD 与流程来源

| 来源 | 可借鉴点 | SoloSpec 结论 |
|---|---|---|
| GitHub Spec Kit | spec -> plan -> tasks -> implement，任务包含依赖、并行标记和 TDD 结构 | SoloSpec 的共同 SDD/TDD 区只在 `specs/NNN-*` 内统一，不提前合并项目/功能/bug 模板 |
| OpenSpec | change folder 自包含，完成后 archive 并合并到主 specs；强调轻量和 delta | SoloSpec 保留“当前变更独立、归档晋升基线”的思想，但不采用 `.openspec/` 目录 |
| Superpowers | brainstorm -> plan -> subagent/TDD -> review；每任务红绿重构，独立子代理和双重 review | SoloSpec 借鉴 TDD 和审查门禁，但实现由 `tasks.md`、`qa.md` 和 gate 控制 |
| BMAD | 专家角色、敏捷式分析/产品/架构/实现/QA 生命周期 | SoloSpec 借鉴专家角色和阶段引导，不复制 BMAD 的多命令/多角色入口 |

### 2.3 产品与设计来源

| 来源 | 可借鉴点 | SoloSpec 结论 |
|---|---|---|
| Vercel product-design | 一个入口路由到产品判断、界面质量、copy、状态、组件、证据和 eval；规则必须有证据和人审 | `solo-spec-ux` 不能只管“好看”，必须管用户目标、状态、异常、可访问性、证据和资产登记 |
| Vercel Web Interface Guidelines | UI 审查覆盖 accessibility、focus、forms、animation、typography、images、performance、navigation state、dark mode、touch、i18n | UX 专家输出要按维度审查，不只给审美建议 |
| NN/g 可用性启发式 | 可用性启发式是交互设计的通用规则 | UX 专家默认使用可用性启发式做底层校验，但不能替代项目上下文 |
| Material Design / Apple HIG | 平台级设计系统强调组件、颜色、排版、布局、可访问性和平台一致性 | 技术栈或平台确定后，UX 专家才引入对应平台规范；未采用的平台不写入技术栈或设计基线 |
| Mobbin / Page Flows / 独立设计师作品 | 适合做竞品流、页面状态、交互细节和真实产品模式参考 | 这些是参考和证据来源，不是 SoloSpec 的目录或章节来源 |

## 3. 对现有方案的修正

### 3.1 不能直接写专家 Skill 定稿

`skills/solo-spec-ux/` 当前只能视为草稿原型。正式版本必须先满足：

- 引用本调研结论中的 Skill 结构原则。
- 输出统一 expert packet。
- 不直接写用户项目文件。
- 不创建 `docs/assets/`、`design-assets/`、`figma/`、`.specify/`、`.openspec/` 等外部目录。
- 将外部设计产物映射到 `solo/project/assets/` 或当前 `solo/specs/NNN-*/assets/`。
- 对不适配当前阶段的产物给出 `discarded` 原因。

### 3.2 外部 Skill 的位置

外部 Skill 不是被“内嵌复制”的对象，而是三个角色之一：

| 角色 | 说明 | 例子 |
|---|---|---|
| Advisor | 给方法、方案、风险或候选项 | BMAD、Spec Kit、OpenSpec、Superpowers |
| Reviewer | 审查现有文档、设计或代码 | gstack review、Vercel web-design-guidelines |
| Generator | 生成设计稿、线稿、测试建议或报告 | taste、design-shotgun、browser QA |

无论来源是什么，进入 SoloSpec 后都必须转换成：

```text
expert:
branch:
stage:
mode:
summary:
findings:
recommendation:
writeTargets:
assets:
discarded:
gate:
risks:
```

### 3.3 专家 Skill 的独立可用形态

每个专家 Skill 必须支持两种模式：

- Standalone：用户单独调用 `$solo-spec-ux` 时，输出可读的专家建议、审查结果或设计映射建议。
- SoloSpec integration：被 `/solo` 编排时，只输出 expert packet，不推进阶段、不写文件、不通过门禁。

## 4. UX 专家模块设计原则

`solo-spec-ux` 不是“设计美化 Skill”，而是“用户体验和设计资产适配 Skill”。

它必须覆盖：

- 用户任务：谁在什么场景下完成什么目标。
- 页面和流程：入口、主路径、异常路径、空状态、加载状态、错误状态、权限状态、移动端状态。
- 信息架构：导航、分组、层级、命名、扫描路径。
- 交互规则：反馈、撤销、确认、危险操作、表单校验、键盘和触控。
- 视觉基线：主题色、字体、密度、组件风格、图标、动效原则。
- 可访问性：语义、焦点、对比度、键盘操作、减少动画。
- 资产登记：线稿、高保真、截图、参考图必须落到 SoloSpec 标准资产目录并在文档中登记。

它不能覆盖：

- 未经用户确认的项目级基线变更。
- 与当前阶段无关的未来设计。
- 技术架构和依赖选型。
- 直接实现 UI 代码。

## 5. 对目录结构的影响

本次调研不改变 v0.1-alpha 用户项目目录结构。

专家模块只影响“如何生成或审查内容”，不改变“内容写到哪里”：

```text
solo/
├── project/
│   ├── brief.md
│   ├── prd.md
│   ├── ux.md
│   ├── design-system.md
│   ├── architecture.md
│   ├── quality.md
│   ├── pitfalls.md
│   ├── release.md
│   └── assets/
│       ├── brand/
│       └── global-mockups/
└── specs/
    └── NNN-name/
        ├── brainstorm.md      # 仅迭代
        ├── proposal.md
        ├── spec.md            # 仅迭代 / MVP SDD
        ├── design.md
        ├── plan.md
        ├── tasks.md
        ├── qa.md
        ├── archive.md
        └── assets/
            ├── references/
            ├── wireframes/
            ├── mockups/
            └── screenshots/
```

## 6. 下一步执行顺序

1. 把 `docs/08-expert-module-v02-design.md` 和 `docs/09-expert-skills-architecture.md` 中“直接落地 `solo-spec-ux`”的表述改成“先研究、再定稿、草稿需重写校准”。
2. 基于本调研重写 `skills/solo-spec-ux/`，不要沿用未经验证的早期草稿。
3. 为 `solo-spec-ux` 增加黑盒样例，测试报告见 `docs/11-solo-spec-ux-blackbox-test.md`：
   - taste 输出高保真图，映射到当前 spec。
   - 新项目 UX 阶段设定主题色和设计基调，写入项目级文档。
   - 迭代修改某页面设计，冲突时当前 spec 优先，归档后再晋升项目基线。
4. 通过 UX 样例后，设计 `solo-spec-product`，因为产品专家会影响更前置的头脑风暴、调研和需求收敛；测试报告见 `docs/12-solo-spec-product-blackbox-test.md`。
5. 完成产品专家后，设计 `solo-spec-architecture`，用于承接产品和 UX 后的架构触发判断、依赖核验、ADR、风险和回滚；测试报告见 `docs/13-solo-spec-architecture-blackbox-test.md`。
6. 完成架构专家后，设计 `solo-spec-tdd`，用于把已确认规格和技术计划拆成红绿循环、回归测试和可执行验证；测试报告见 `docs/14-solo-spec-tdd-blackbox-test.md`。
7. 完成 TDD 专家后，设计 `solo-spec-qa`，用于登记真实 QA 执行证据、截图日志、发现问题和门禁建议；测试报告见 `docs/15-solo-spec-qa-blackbox-test.md`。
8. 完成 QA 专家后，设计 `solo-spec-release`，用于归档、项目基线晋升、发布记录、托管块建议和收尾一致性；测试报告见 `docs/16-solo-spec-release-blackbox-test.md`。
9. 完成首批专家后，执行整体结构、章节映射和分发复制烟测；测试报告见 `docs/17-expert-skills-integration-smoke-test.md`。
10. 用全新子代理执行真实黑盒调用测试，并根据结果修正专家边界；测试报告见 `docs/18-expert-skills-forward-test.md`。

## 7. 主要来源

- Agent Skills Overview: https://agentskills.io/home
- Agent Skills Specification: https://agentskills.io/specification
- OpenAI Skills in API: https://developers.openai.com/cookbook/examples/skills_in_api
- Anthropic Agent Skills: https://platform.claude.com/docs/en/agents-and-tools/agent-skills/overview
- Anthropic Skills engineering blog: https://www.anthropic.com/engineering/equipping-agents-for-the-real-world-with-agent-skills
- skills.sh docs: https://www.skills.sh/docs
- GitHub Spec Kit: https://github.com/github/spec-kit
- GitHub Spec Kit blog: https://github.blog/ai-and-ml/generative-ai/spec-driven-development-with-ai-get-started-with-a-new-open-source-toolkit/
- OpenSpec: https://github.com/Fission-AI/OpenSpec
- Superpowers: https://github.com/obra/Superpowers
- BMAD Method: https://github.com/bmad-code-org/bmad-method
- Vercel product-design: https://vercel.com/blog/teaching-agents-product-design-at-vercel
- Vercel Web Interface Guidelines: https://vercel.com/design/guidelines
- Vercel agent-skills: https://github.com/vercel-labs/agent-skills
- NN/g usability heuristics: https://www.nngroup.com/articles/ten-usability-heuristics/
- Material Design 3: https://m3.material.io/
- Apple Human Interface Guidelines: https://developer.apple.com/design/human-interface-guidelines/
- Mobbin: https://mobbin.com/
- Rauno Freiberg portfolio: https://devouringdetails.com/
- Linear redesign note: https://linear.app/now/how-we-redesigned-the-linear-ui

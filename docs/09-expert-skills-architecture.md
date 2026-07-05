# 专家 Skill 架构

## 1. 结论

专家模块不应该只放在 `solo-spec` 的 `references/experts.md` 里。

正确形态是：

- `solo-spec`：主编排 Skill，负责入口、分支、状态机、目录、门禁、写入规则。
- `solo-spec-*`：独立专家 Skill，负责某一类专业判断，输出 expert packet。
- 外部顶级 Skill：可作为专家 Skill 的参考、Reviewer、Advisor 或 Generator，但输出必须被转换成 SoloSpec 结构。

## 2. 目录形态

```text
skills/
├── solo-spec/
├── solo-spec-product/
├── solo-spec-ux/
├── solo-spec-architecture/
├── solo-spec-tdd/
├── solo-spec-qa/
└── solo-spec-release/
```

v0.2 先以 `solo-spec-product`、`solo-spec-ux`、`solo-spec-architecture`、`solo-spec-tdd`、`solo-spec-qa` 和 `solo-spec-release` 作为验证方向，用于验证前置产品发现能力、复杂设计类能力、架构决策能力、TDD 任务拆分能力、QA 证据登记能力和归档发布收口能力如何独立成 Skill；正式落地前必须按 `docs/10-expert-skill-research.md` 重写校准。

## 3. 主 Skill 和专家 Skill 边界

| 能力 | `solo-spec` | `solo-spec-*` |
|---|---|---|
| 判断分支 | 是 | 否 |
| 推进状态机 | 是 | 否 |
| 写入文件 | 是 | 否 |
| 通过门禁 | 是，且必须由用户确认 | 否 |
| 专业评审 | 只调度或接收结果 | 是 |
| 外部 Skill 适配 | 只接收转换后的 expert packet | 是 |
| 目录约束 | 定义和执行 | 遵守 |

专家 Skill 不直接修改用户项目。它们输出结构化 expert packet，由 `solo-spec` 在当前阶段决定是否写入。

## 4. Expert Packet

所有专家 Skill 必须输出统一结构：

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

## 5. 独立专家 Skill 规划

| Skill | 职责 | 首批来源借鉴 |
|---|---|---|
| `solo-spec-product` | 产品调研、头脑风暴、需求收敛、用户痛点分析 | BMAD、gstack office-hours |
| `solo-spec-ux` | UX、设计系统、线稿、高保真、taste 输出适配 | taste、gstack design-review |
| `solo-spec-architecture` | 技术架构、依赖核验、ADR、根因分析 | BMAD architect、gstack eng review |
| `solo-spec-tdd` | TDD 任务拆分、红绿循环、回归测试建议 | Superpowers |
| `solo-spec-qa` | QA 策略、浏览器/API 验证、证据登记 | gstack QA |
| `solo-spec-release` | 归档、发布、项目基线晋升、托管块建议 | OpenSpec、piao-workflow |

## 6. 首批专家原型

`solo-spec-product`、`solo-spec-ux`、`solo-spec-architecture`、`solo-spec-tdd`、`solo-spec-qa` 和 `solo-spec-release` 是首批独立专家 Skill 原型。正式版本必须先按 `docs/10-expert-skill-research.md` 的调研结论重写校准。

`solo-spec-product` 只做：

1. 产品想法澄清、头脑风暴、用户痛点分析和范围收敛。
2. 判断当前阶段是否需要产品事实调研，并把调研需求留在当前阶段。
3. 把外部产品建议映射为 SoloSpec 的 `project/brief.md`、`project/prd.md`、当前 `brainstorm.md`、`proposal.md` 或 `spec.md` 建议。

它不做：

- 不推进 `/solo` 阶段。
- 不创建 `research.md` 或外部产品目录。
- 不把未确认的 pivot、目标用户或商业模式写成项目基线。
- 不把实现细节、UI 设计、架构或 TDD 任务写成产品需求。

`solo-spec-ux` 只做：

1. 审查或建议 UX / UI / 设计系统内容。
2. 把 taste 等外部设计输出映射为 SoloSpec 资产路径和登记记录。
3. 丢弃自建目录、跳阶段实现、未确认基线变更等违规内容。

它不做：

- 不推进 `/solo` 阶段。
- 不创建 `solo/` 目录。
- 不直接写 `design.md`、`design-system.md` 或代码。
- 不把设计稿留在外部临时目录当作最终产物。

`solo-spec-architecture` 只做：

1. 根据 PRD、UX、当前 spec、仓库上下文和约束推断触发的架构层。
2. 映射技术栈、模块边界、数据流、接口、外部依赖、安全约束、风险回滚和 ADR 候选。
3. 在 Bugfix 中输出根因、最小修复策略和回归风险，而不是直接修代码。

它不做：

- 不推进 `/solo` 阶段。
- 不直接修改依赖、配置、迁移、框架代码或业务代码。
- 不列出所有未触发的可选架构层作为 `不适用`。
- 不在未官方核验时断言版本、API、平台限制或安全行为。
- 不把产品范围、UX 设计、TDD 任务或 QA 结果写成架构决策。

`solo-spec-tdd` 只做：

1. 把已确认的 `spec.md`、`design.md` 和 `plan.md` 拆成可独立验证的 TDD 任务。
2. 定义 red test、预期失败、最小 green 实现范围、通过命令和回归验证。
3. 在 Bugfix 中要求先有复现、根因和回归测试方法，再建议 fix 范围。

它不做：

- 不推进 `/solo` 阶段。
- 不直接写实现代码、测试代码、迁移或依赖。
- 不跳过红灯测试。
- 不把 QA 执行结果写成 TDD 计划。
- 不引入未确认的产品、UX 或架构变更。

`solo-spec-qa` 只做：

1. 把真实命令输出、浏览器/API/人工验证、截图和日志映射到 `qa.md`。
2. 记录发现并修复的问题、回归证据、不测范围和 QA 门禁建议。
3. 把当前 QA 发现的问题留在当前 spec 内闭环，除非用户确认转为独立 Bugfix。

它不做：

- 不推进 `/solo` 阶段。
- 不把测试计划伪装成执行记录。
- 不在缺少证据时宣告 QA 通过。
- 不直接修代码、写测试、改依赖或迁移。
- 不把截图和日志保留在外部临时目录当最终证据。

`solo-spec-release` 只做：

1. 汇总完成内容、文件变更、验证记录、发布记录和残余风险。
2. 在归档阶段提出项目级基线晋升、quality/pitfalls/release 更新和托管块建议。
3. 把外部发布/归档建议映射为 `archive.md`、`project/release.md`、`project/quality.md`、`project/pitfalls.md` 或 `managed-blocks` 建议。

它不做：

- 不推进 `/solo` 阶段。
- 不提交、打标签、推送、发布或部署。
- 不在 QA 证据缺失时建议发布完成。
- 不把未验证或临时决定晋升到项目基线。
- 不直接重写 README/CHANGELOG/AGENTS 外部文件。

## 7. 分发策略

v0.2 基础安装只要求安装：

```text
skills/solo-spec/
```

v0.2 增强安装可以选择安装：

```text
skills/solo-spec/
skills/solo-spec-product/
skills/solo-spec-ux/
skills/solo-spec-architecture/
skills/solo-spec-tdd/
skills/solo-spec-qa/
skills/solo-spec-release/
```

后续专家 Skill 应保持可选增强。未安装专家 Skill 时，`solo-spec` 主流程仍必须能独立运行。

## 8. 验收标准

每新增一个专家 Skill，必须通过：

- Skill 结构校验：`SKILL.md`、`agents/openai.yaml`、必要 references。
- 黑盒映射测试：给外部输出，判断写入目标、资产路径、丢弃项。
- 不写文件测试：专家 Skill 本身不直接修改用户项目。
- 主流程兼容测试：未安装专家 Skill 时，`solo-spec` 仍能跑通。

首批专家的整体烟测报告见 `docs/17-expert-skills-integration-smoke-test.md`，真实子代理黑盒调用报告见 `docs/18-expert-skills-forward-test.md`。接入策略见 `docs/19-expert-integration-strategy.md`，v0.2 分发安装验收见 `docs/24-v02-distribution-installation-test.md`。

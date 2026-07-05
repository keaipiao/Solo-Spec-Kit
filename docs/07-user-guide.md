# SoloSpec v0.2 用户说明

## 1. 适用范围

SoloSpec v0.2 面向中文独立开发者，用一个入口 `/solo` 把想法、迭代、Bug 修复或老项目接入，推进为统一目录下的项目文档、规格文档、TDD 任务、QA 证据和归档记录。

当前版本包含主流程和可选专家增强：

- 主流程 `solo-spec` 是唯一必装 Skill。
- 专家 Skill 是可选增强，用于产品、UX、架构、TDD、QA 和归档审查。
- 未安装专家 Skill 时，`/solo` 必须降级继续。
- 已安装专家 Skill 时，`/solo` 也不能默认自动调用；必须先说明收益并等待用户确认。

## 2. 安装

推荐项目级安装，避免污染全局环境，也方便随项目一起移除。

### 2.1 基础安装

基础安装只复制主 Skill：

```text
<your-project>/
└── .agents/
    └── skills/
        └── solo-spec/
            ├── SKILL.md
            ├── agents/
            ├── references/
            └── assets/
```

把本仓库的 `skills/solo-spec/` 复制到目标项目的 `.agents/skills/solo-spec/`。

基础安装已经可以跑完整流程。专家缺失时，主流程会使用基础规则继续。

### 2.2 增强安装

增强安装复制主 Skill 和六个专家 Skill：

```text
<your-project>/
└── .agents/
    └── skills/
        ├── solo-spec/
        ├── solo-spec-product/
        ├── solo-spec-ux/
        ├── solo-spec-architecture/
        ├── solo-spec-tdd/
        ├── solo-spec-qa/
        └── solo-spec-release/
```

专家 Skill 仍不是新的公共入口。普通用户只需要使用 `/solo`。

安装后不要手动复制 `templates/solo/` 到用户项目。SoloSpec 只在对应阶段开始时，从 Skill 内置模板创建需要的文档。

## 3. 启动

在目标项目根目录发起：

```text
/solo <自然语言请求>
```

示例：

```text
/solo 我想做一个小红书博主用的 AI 选题工具
/solo 给现有项目加邮箱登录
/solo 这个接口 500 了，帮我修
/solo 把这个老项目接入规范流程
/solo 继续
```

第一次响应必须先复述用户要做什么、列出关键假设，并在分支或目标不清楚时只问一个阻塞问题。

## 4. 分支

SoloSpec 只使用四个顶层分支：

| 分支 | 适用请求 | 默认产物 |
|---|---|---|
| 新项目 | 从零开始的新产品、新想法 | `solo/project/` 项目级文档，架构确认后创建 `solo/specs/001-mvp/` |
| 迭代 | 新增、修改、优化、删除既有能力 | `solo/specs/NNN-name/brainstorm.md`、`proposal.md` 和后续 SDD/TDD 文档 |
| Bug 修复 | 报错、失败、测试不过、页面坏了 | 独立 bugfix 规格默认只有 `proposal.md`、`plan.md`、`tasks.md`、`qa.md`、`archive.md` |
| 老项目接入 | 给已有项目补流程和基线 | `solo/project/brief.md`、`architecture.md`、`quality.md`、`pitfalls.md` |

新项目的头脑风暴过程不落盘，只把确认后的结论写入 `solo/project/`。功能迭代可以保留发散过程，写入当前迭代的 `brainstorm.md`。

## 5. 专家建议

专家建议只服务当前阶段：

| 阶段 | 可建议专家 | 作用 |
|---|---|---|
| `brainstorm` / `scope` | `solo-spec-product` | 审查用户、痛点、方案和 MVP 边界 |
| `ux` / `design` | `solo-spec-ux` | 审查流程、状态、设计资产和体验风险 |
| `architecture` / `plan` / `root-cause` | `solo-spec-architecture` | 审查架构层、数据流、依赖、ADR 和回滚 |
| `tdd-plan` / `regression-test` | `solo-spec-tdd` | 审查红绿任务、回归测试和命令 |
| `qa` / `verify` | `solo-spec-qa` | 审查 QA 证据、截图、日志和发现问题 |
| `archive` / `write-managed-blocks` | `solo-spec-release` | 审查归档、基线晋升和托管块 |

规则：

- `/solo` 可以建议专家审查，但不能默认自动调用。
- 专家调用必须经过用户确认。
- 专家输出只能作为 expert packet，被主流程消费后写入标准 `solo/` 目录。
- 专家不能写文件、改状态机、通过门禁、创建外部目录或发布版本。
- 专家缺失、输出无效或越过当前阶段时，主流程必须降级继续。

## 6. 门禁

每个关键阶段结束后，SoloSpec 会停下来等待用户确认。

在阶段完成后的确认语境中，有效确认包括：

```text
通过
继续
按这个来
确认
```

侧聊、解释问题、补充背景不算确认。单独发起 `/solo 继续` 是恢复命令，不等同于通过当前门禁。

门禁通过后，SoloSpec 必须先把刚确认的文档从“等待确认”改为“已确认”，并更新 `solo/state.json`，再进入下一阶段。若流程已经结束，`solo/state.json` 中的 `gate.requires` 应为 `none`。

## 7. 继续

使用：

```text
/solo 继续
```

SoloSpec 会读取 `solo/state.json`，恢复当前分支、当前规格、当前阶段和门禁状态。`/solo 继续` 不会自动越过门禁，仍需要用户明确确认。

## 8. 目录

用户项目中的事实源统一放在：

```text
solo/
```

典型结构：

```text
solo/
├── state.json
├── config.json
├── project/
├── specs/
├── decisions/
└── archive/
```

不要为 SoloSpec 另建 `docs/plans/`、`docs/features/` 或根目录 `specs/`。

## 9. 无痛移除

移除 SoloSpec 时：

1. 删除 `.agents/skills/solo-spec/` 和可选的 `.agents/skills/solo-spec-*/`，停止项目级 Skill 安装。
2. 删除 `solo/`，移除 SoloSpec 事实源。
3. 删除 `AGENTS.md`、`README.md`、`CHANGELOG.md` 等文件中的 SoloSpec 托管块。

SoloSpec 不应移动、重命名、格式化或重构用户既有业务代码。删除上述内容后，项目应保持可运行。

## 10. 当前限制

- 专家是可选增强，不是流程依赖。
- 专家不会默认自动调用。
- 外部增强 Skill 只能作为 Reviewer、Advisor 或 Generator，最终内容必须转换为 SoloSpec 目录和章节。
- 老项目接入默认只读盘点，不默认创建规格目录，也不默认写 `project/prd.md`。
- 独立 Bug 修复默认不创建 `brainstorm.md`、`spec.md`、`design.md`。

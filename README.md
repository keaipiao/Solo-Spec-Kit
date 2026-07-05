# SoloSpec Kit

SoloSpec Kit 是面向中文独立开发者的 AI 编程流程 Skill 套件。它用一个入口 `/solo` 把产品想法、功能迭代、Bug 修复或老项目接入，推进为统一的项目文档、规格文档、TDD 任务、QA 证据和归档记录。

当前版本：v0.2。

## 能力

- 一个入口：用户只需要使用 `/solo <自然语言请求>`。
- 四条分支：新项目、迭代、Bug 修复、老项目接入。
- 阶段门禁：关键阶段必须等待用户确认后继续。
- 统一事实源：所有 SoloSpec 产物写入用户项目的 `solo/` 目录。
- SDD + TDD：先确认需求、设计和架构，再进入可执行规格、红绿任务、实现和 QA。
- 可选专家增强：产品、UX、架构、TDD、QA、Release 六个专家 Skill 可作为增强审查，但不默认自动调用。

## 安装

推荐项目级安装，把 Skill 复制到目标项目：

```text
<your-project>/.agents/skills/
```

### 基础安装

只复制主 Skill：

```text
skills/solo-spec/ -> <your-project>/.agents/skills/solo-spec/
```

基础安装可以跑完整 `/solo` 流程。专家缺失时，主流程会降级继续。

### 增强安装

复制主 Skill 和全部专家 Skill：

```text
skills/solo-spec/              -> <your-project>/.agents/skills/solo-spec/
skills/solo-spec-product/      -> <your-project>/.agents/skills/solo-spec-product/
skills/solo-spec-ux/           -> <your-project>/.agents/skills/solo-spec-ux/
skills/solo-spec-architecture/ -> <your-project>/.agents/skills/solo-spec-architecture/
skills/solo-spec-tdd/          -> <your-project>/.agents/skills/solo-spec-tdd/
skills/solo-spec-qa/           -> <your-project>/.agents/skills/solo-spec-qa/
skills/solo-spec-release/      -> <your-project>/.agents/skills/solo-spec-release/
```

增强安装后，普通用户仍只使用 `/solo`。专家 Skill 是可选增强，不是新的公共入口。

## 使用

在目标项目根目录输入：

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

## 用户项目产物

SoloSpec 只把流程事实写入：

```text
solo/
├── state.json
├── config.json
├── project/
├── specs/
├── decisions/
└── archive/
```

不要额外创建 `docs/plans/`、`docs/features/` 或根目录 `specs/` 来存放 SoloSpec 产物。

## 专家规则

- `/solo` 可以在当前阶段建议专家审查。
- 使用专家前必须说明收益并等待用户确认。
- 未安装专家时，主流程必须降级继续。
- 专家只能输出 expert packet，由主流程消费后写入标准 `solo/` 目录。
- 专家不能写文件、改状态机、通过门禁、创建外部目录或发布版本。

## 文档

- 用户说明：[docs/07-user-guide.md](docs/07-user-guide.md)
- 产品规格：[docs/01-product-spec.md](docs/01-product-spec.md)
- 用户项目结构：[docs/02-user-project-structure.md](docs/02-user-project-structure.md)
- 执行规则：[docs/03-skill-execution-rules.md](docs/03-skill-execution-rules.md)
- 状态机：[docs/05-state-machine.md](docs/05-state-machine.md)
- 专家契约：[docs/06-expert-contract.md](docs/06-expert-contract.md)
- v0.2 发布检查表：[docs/25-v02-release-checklist.md](docs/25-v02-release-checklist.md)

## 验证状态

v0.2 已完成：

- 7 个 Skill 结构校验。
- 专家 Skill 黑盒测试。
- 主流程专家建议接入测试。
- 只安装主 Skill 的降级烟测。
- 独立子代理盲测。
- 项目级增强安装复制验收。

对应证据见 `docs/11-*` 到 `docs/24-*`。

## 移除

删除以下内容即可移除 SoloSpec：

1. `<your-project>/.agents/skills/solo-spec/`
2. 可选的 `<your-project>/.agents/skills/solo-spec-*/`
3. `<your-project>/solo/`
4. `AGENTS.md`、`README.md`、`CHANGELOG.md` 中由 SoloSpec 写入的托管块

SoloSpec 不应移动、重命名、格式化或重构用户既有业务代码。

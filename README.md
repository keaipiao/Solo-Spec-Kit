# SoloSpec Kit

SoloSpec Kit 是面向中文独立开发者的 AI 编程流程 Skill 套件。它用一个入口 `$solo-spec` 把产品想法、功能迭代、Bug 修复或老项目接入，推进为统一的项目文档、规格文档、TDD 任务、QA 证据和归档记录。

当前版本：v0.3 开发中。

## 能力

- 一个入口：用户只需要使用 `$solo-spec <自然语言请求>`。
- 四条分支：新项目、迭代、Bug 修复、老项目接入。
- 阶段门禁：关键阶段必须等待用户确认后继续。
- 统一事实源：所有 SoloSpec 产物写入用户项目的 `solo/` 目录。
- SDD + TDD：先确认需求、设计和架构，再进入可执行规格、红绿任务、实现和 QA。
- 可选专家增强：`$solo-spec` 会按阶段检测当前专家状态；未安装专家时可降级，用户也可以指定其他 Skill / 工具。
- 多 Agent 工具适配：安装脚本通过 host adapter 支持 Codex、Cursor、Claude Code、OpenCode、zcode、Trae 和 generic fallback。

## 安装

推荐项目级安装，把 Skill 复制到目标项目对应工具的项目级 Skill 目录：

```text
Codex:      <your-project>/.agents/skills/
Cursor:     <your-project>/.cursor/skills/
Claude Code:<your-project>/.claude/skills/
OpenCode:   <your-project>/.opencode/skills/
zcode:      <your-project>/.zcode/skills/
Trae:       <your-project>/.trae/skills/    (needs real IDE verification)
Generic:    <your-project>/.agents/skills/
```

### 脚本安装

在本仓库根目录运行：

```powershell
.\scripts\install-project-skills.ps1 -ProjectPath <your-project> -Mode basic
.\scripts\install-project-skills.ps1 -ProjectPath <your-project> -Mode enhanced
.\scripts\install-project-skills.ps1 -ProjectPath <your-project> -Mode enhanced -Host cursor
.\scripts\install-project-skills.ps1 -ListHosts
```

`-Host auto` 是默认值。脚本会根据目标项目已有目录自动选择 host；没有明显 host 目录时回退到 `generic`，安装到 `.agents/skills/`。
旧参数 `-Tool zcode` 仍作为兼容别名可用。

默认不覆盖目标项目中已有的 SoloSpec Skill。需要替换时显式加 `-Force`：

```powershell
.\scripts\install-project-skills.ps1 -ProjectPath <your-project> -Mode enhanced -Force
```

### 基础安装

只复制主 Skill：

```text
skills/solo-spec/ -> <skills-root>/solo-spec/
```

基础安装可以跑完整 `solo-spec` 流程。专家缺失时，主流程会降级继续。

### 增强安装

复制主 Skill 和全部专家 Skill：

```text
skills/solo-spec/              -> <skills-root>/solo-spec/
skills/solo-spec-product/      -> <skills-root>/solo-spec-product/
skills/solo-spec-ux/           -> <skills-root>/solo-spec-ux/
skills/solo-spec-architecture/ -> <skills-root>/solo-spec-architecture/
skills/solo-spec-tdd/          -> <skills-root>/solo-spec-tdd/
skills/solo-spec-qa/           -> <skills-root>/solo-spec-qa/
skills/solo-spec-release/      -> <skills-root>/solo-spec-release/
```

增强安装后，普通用户仍只调用 `$solo-spec`。专家 Skill 是可选增强，不是新的公共入口。

## 使用

在目标项目根目录输入：

```text
$solo-spec <自然语言请求>
```

`/solo` 和 `/solo-spec` 只作为宿主环境已配置别名时的兼容写法；本文档统一使用真实 Skill 名 `$solo-spec`。
即使用户请求写成“现在接入接口”“直接实现”，也必须先进入 SoloSpec 门禁流程；只有当前状态已经到 `implementation` 或 `fix`，且上游门禁已通过，才允许修改业务代码。

示例：

```text
$solo-spec 我想做一个小红书博主用的 AI 选题工具
$solo-spec 给现有项目加邮箱登录
$solo-spec 这个接口 500 了，帮我修
$solo-spec 把这个老项目接入规范流程
$solo-spec 继续
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

- `$solo-spec` 必须在可增强阶段默认使用已安装的当前阶段专家，并在门禁前报告专家状态。
- 未安装专家时，主流程必须降级继续。
- 用户可以指定其他 Skill / 工具审查当前阶段，但输出仍由 `solo-spec` 按当前阶段规则消费。
- 专家只能输出 expert packet，由主流程消费后写入标准 `solo/` 目录。
- 专家不能写文件、改状态机、通过门禁、创建外部目录或发布版本。

## 文档

- 文档索引：[docs/README.md](docs/README.md)
- 用户说明：[docs/public/01-user-guide.md](docs/public/01-user-guide.md)
- 产品规格：[docs/public/02-product-spec.md](docs/public/02-product-spec.md)
- 用户项目结构：[docs/public/03-user-project-structure.md](docs/public/03-user-project-structure.md)
- 执行规则：[docs/internal/01-skill-execution-rules.md](docs/internal/01-skill-execution-rules.md)
- 状态机：[docs/internal/03-state-machine.md](docs/internal/03-state-machine.md)
- 专家契约：[docs/internal/04-expert-contract.md](docs/internal/04-expert-contract.md)
- v0.2 发布检查表：[docs/public/04-v02-release-checklist.md](docs/public/04-v02-release-checklist.md)
- v0.3 发布检查表：[docs/public/05-v03-release-checklist.md](docs/public/05-v03-release-checklist.md)
- v0.3 多轮子代理回归：[docs/verification/v0.3/04-multi-round-subagent-regression.md](docs/verification/v0.3/04-multi-round-subagent-regression.md)
- v0.3 最终发布回归：[docs/verification/v0.3/05-final-release-regression.md](docs/verification/v0.3/05-final-release-regression.md)
- 安装脚本验收：[docs/verification/v0.2/14-install-script-test.md](docs/verification/v0.2/14-install-script-test.md)

## 验证状态

v0.2 已完成：

- 7 个 Skill 结构校验。
- 专家 Skill 黑盒测试。
- 主流程专家建议接入测试。
- 只安装主 Skill 的降级烟测。
- 独立子代理盲测。
- 项目级增强安装复制验收。
- 项目级安装脚本验收。
- 四分支回归测试。

对应证据见 `docs/verification/v0.2/`。

## 移除

删除以下内容即可移除 SoloSpec：

1. `<skills-root>/solo-spec/`
2. 可选的 `<skills-root>/solo-spec-*/`
3. `<your-project>/solo/`
4. `AGENTS.md`、`README.md`、`CHANGELOG.md` 中由 SoloSpec 写入的托管块

SoloSpec 不应移动、重命名、格式化或重构用户既有业务代码。

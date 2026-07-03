# SoloSpec v0.1-alpha 用户说明

## 1. 适用范围

SoloSpec v0.1-alpha 面向中文独立开发者，用一个入口 `/solo` 把想法、迭代、Bug 修复或老项目接入，推进为统一目录下的项目文档、规格文档、TDD 任务、QA 证据和归档记录。

当前版本重点验证流程闭环，不依赖专家角色，也不要求外部增强 Skill。

## 2. 安装

推荐项目级安装，避免污染全局环境，也方便随项目一起移除：

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

## 5. 门禁

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

## 6. 继续

使用：

```text
/solo 继续
```

SoloSpec 会读取 `solo/state.json`，恢复当前分支、当前规格、当前阶段和门禁状态。`/solo 继续` 不会自动越过门禁，仍需要用户明确确认。

## 7. 目录

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

## 8. 无痛移除

移除 SoloSpec 时：

1. 删除 `.agents/skills/solo-spec/`，停止项目级 Skill 安装。
2. 删除 `solo/`，移除 SoloSpec 事实源。
3. 删除 `AGENTS.md`、`README.md`、`CHANGELOG.md` 等文件中的 SoloSpec 托管块。

SoloSpec 不应移动、重命名、格式化或重构用户既有业务代码。删除上述内容后，项目应保持可运行。

## 9. 当前限制

- v0.1-alpha 不依赖专家角色。
- 外部增强 Skill 只能作为 Reviewer、Advisor 或 Generator，最终内容必须转换为 SoloSpec 目录和章节。
- 老项目接入默认只读盘点，不默认创建规格目录，也不默认写 `project/prd.md`。
- 独立 Bug 修复默认不创建 `brainstorm.md`、`spec.md`、`design.md`。

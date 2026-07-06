# SoloSpec 模板契约

## 1. 模板位置

模板统一放在：

```text
templates/solo/
```

这些模板用于生成用户项目根目录下的 `solo/`，不是本仓库自身运行时状态。

## 2. 生成规则

### 2.1 新项目

新项目默认生成：

```text
solo/state.json
solo/config.json
solo/project/assets/
solo/specs/
solo/decisions/
solo/archive/
```

新项目的前置流程写 `solo/project/`，但只沉淀确认后的项目结论。不要在 `project/` 中保存 brainstorm 过程、未采纳方案或临时不确定项。`solo/specs/001-mvp/` 在项目级 `architecture` 通过后创建，用于统一 SDD/TDD。

如果项目没有 UI，在进入对应阶段后仍保留 `solo/project/ux.md`、`solo/project/design-system.md` 和迭代 `design.md`，并写“不适用”。

### 2.2 迭代

每次迭代生成：

```text
solo/specs/NNN-iteration-name/
└── assets/
    ├── wireframes/
    ├── mockups/
    ├── screenshots/
    └── references/
```

迭代 Markdown 按阶段生成：`brainstorm.md` 在 brainstorm 阶段生成，`proposal.md` 在 scope 阶段生成，后续文件按 spec、design、architecture、tdd-plan、qa、archive 阶段依次生成。

迭代包括新增、修改、优化、删除，不等同于单纯新增能力。

### 2.3 Bug 修复

Bug 修复按三种路径处理：

| 场景 | 写入位置 | 规则 |
|---|---|---|
| 当前迭代执行中发现的 Bug | 当前迭代的 `qa.md`、`tasks.md`、`archive.md` | 直接作为当前迭代的修复项处理，不新建目录 |
| 新会话中提出的 Bug | 先尝试归属到相关迭代 | 能归属则追加到该迭代，不重写历史结论 |
| 无法归属或跨多个迭代的 Bug | 新建 `solo/specs/NNN-bugfix-title/` | 使用 bugfix 模板 |

归属到已完成迭代时，只追加“Bug 修复记录”和新的验证证据，不改写原归档结论。

如果 Bug 无法归属到现有迭代，生成：

```text
solo/specs/NNN-bugfix-title/
├── proposal.md
├── plan.md
├── tasks.md
├── qa.md
├── archive.md
└── assets/
    ├── screenshots/
    └── references/
```

Bugfix 不生成 `brainstorm.md`。`proposal.md` 写复现背景、影响范围和修复目标，`tasks.md` 写回归测试和修复任务。如果需要比较多种修复策略，写入 `plan.md` 的方案取舍段落。

Bugfix 默认生成 `proposal.md`、`plan.md`、`tasks.md`、`qa.md`、`archive.md` 和 `assets/`。除非修复已经演变成产品迭代，否则不要补 `brainstorm.md`、`spec.md`、`design.md`。

### 2.4 老项目接入

老项目接入默认只生成：

```text
solo/state.json
solo/config.json
solo/project/brief.md
solo/project/architecture.md
solo/project/quality.md
solo/project/pitfalls.md
```

只有用户确认后，才写托管块到 `AGENTS.md`、`CLAUDE.md`、`README.md` 或 `CHANGELOG.md`。

## 3. 事实源规则

`solo/` 是完整事实源。

`solo/specs/` 记录迭代、Bug 和 MVP SDD/TDD 阶段的过程、取舍、规格、计划、测试和归档；`solo/project/` 记录当前项目基线。功能迭代开发过程中两者冲突时，以当前 `specs/NNN-*` 为准；归档后再决定是否更新项目级文档。

托管块只是索引和摘要，不得承载唯一结论。卸载 SoloSpec 时，删除 `solo/` 和托管块即可。

## 4. 章节稳定规则

模板章节固定。

不适用的章节写“不适用”，不要删除。这样可以保证：

- 新会话能稳定定位章节。
- 外部增强产物能登记到固定位置。
- 后续脚本可以机械检查文档完整性。

模板章节是最低结构，不是能力上限。架构、设计、测试等阶段可以根据需求增加行和子章节；例如后端项目应自动补充鉴权、权限、数据库、缓存、队列、接口、安全和可观测性。架构技术栈只列实际采用或必须决策的层，其他关键排除项写入架构边界。

## 5. 外部增强产物

外部增强分为三类：

| 类型 | 结果如何处理 |
|---|---|
| Reviewer | 写入对应文档的门禁或评审结论段落 |
| Advisor | 写入当前阶段文档；只有功能迭代的发散建议才写入 `brainstorm.md` |
| Generator | 作为资产放入当前阶段所属的 `assets/`，并在文档登记 |

示例：

- taste 生成项目级视觉参考：放 `project/assets/global-mockups/`，登记到 `project/design-system.md`。
- taste 生成具体页面高保真：放当前规格 `assets/mockups/`，登记到 `design.md`。
- 浏览器 QA 截图：放当前规格 `assets/screenshots/`，登记到 `qa.md`。
- 竞品截图或参考资料：放 `assets/references/`，新项目登记到当前阶段文档，迭代登记到 `brainstorm.md`、`proposal.md` 或 `design.md`。

外部增强不能自行创建其他目录，也不能绕过 artifact-writer。

## 6. 阶段写入边界

同一个文档可被多个阶段逐步完善，但每个阶段只能写自己已经验证或确认的内容。

| 文档 | 阶段 | 允许写入 |
|---|---|---|
| `qa.md` | `tdd-plan` | 测试计划、QA 场景、截图和日志计划 |
| `qa.md` | `qa` | QA 执行记录、截图路径、日志路径、发现并修复的问题 |
| `tasks.md` | `tdd-plan` | Red 测试、最小实现范围、验证命令 |
| `tasks.md` | `implementation` / `qa` | 实际完成记录、修复记录、回归验证 |
| `archive.md` | `archive` | 完成摘要、变更、验证摘要、项目级文档更新记录、后续建议 |

`qa.md` 模板必须使用“QA 执行记录”，不要在 `tdd-plan` 阶段生成看似已完成的结果。

## 7. Implementation 和 QA 产物规则

如果 implementation 阶段发现项目没有脚手架，可以创建最小工程，但必须满足：

- 与 `project/architecture.md` 和当前 `plan.md` 一致。
- 只包含当前规格需要的运行、测试和入口文件。
- 新增命令写入 `tasks.md` 完成记录。
- 优先无依赖实现，除非架构已采纳具体框架或依赖。

QA 阶段发现 Bug 时，先在当前规格中闭环，不新建 bugfix：

- `qa.md` 写问题、根因、修复、回归测试。
- `tasks.md` 更新完成记录或追加修复任务。
- 修复后的可复用经验在 archive 阶段晋升到 `project/pitfalls.md`。
- 测试分层、QA 矩阵或证据规则发生变化时，archive 阶段同步更新 `project/quality.md`。

## 8. `state.json` 规则

`state.json` 只记录流程状态，不记录完整需求。

允许字段：

- `branch`：`new-project`、`iteration`、`bugfix`、`adopt-existing`
- `currentSpec`：当前迭代目录名，项目级阶段可为 `null`
- `currentStage`：当前阶段
- `gate.status`：`open`、`waiting_user`、`passed`、`blocked`
- `gate.requires`：当前等待用户确认项的 ASCII 短码；中文说明写入阶段文档和完成消息

完整内容必须写入 Markdown。

## 9. 命名规则

迭代目录：

```text
NNN-kebab-case-name
```

示例：

```text
001-mvp
002-email-login
003-refine-onboarding
004-remove-legacy-auth
```

目录名用英文，正文标题可中文。

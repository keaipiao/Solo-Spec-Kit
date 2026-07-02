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
solo/project/*.md
solo/specs/001-mvp/*.md
```

如果项目没有 UI，仍保留 `solo/project/ux.md`、`solo/project/design-system.md` 和迭代 `design.md`，并写“不适用”。

### 2.2 迭代

每次迭代生成：

```text
solo/specs/NNN-iteration-name/
├── proposal.md
├── spec.md
├── design.md
├── plan.md
├── tasks.md
├── qa.md
├── archive.md
└── assets/
    ├── wireframes/
    ├── mockups/
    ├── screenshots/
    └── references/
```

迭代包括新增、修改、优化、删除，不等同于新功能。

### 2.3 Bug 修复

Bug 修复优先更新关联迭代的 `qa.md` 和 `archive.md`。

如果 Bug 无法归属到现有迭代，生成：

```text
solo/specs/NNN-bugfix-title/
```

并使用同一套迭代模板。`proposal.md` 写复现背景，`tasks.md` 写回归测试和修复任务。

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

托管块只是索引和摘要，不得承载唯一结论。卸载 SoloSpec 时，删除 `solo/` 和托管块即可。

## 4. 章节稳定规则

模板章节固定。

不适用的章节写“不适用”，不要删除。这样可以保证：

- 新会话能稳定定位章节。
- 外部增强产物能登记到固定位置。
- 后续脚本可以机械检查文档完整性。

## 5. 外部增强产物

外部增强分为三类：

| 类型 | 结果如何处理 |
|---|---|
| Reviewer | 写入对应文档的门禁或评审结论段落 |
| Advisor | 写入对应方案、风险或候选方案段落 |
| Generator | 作为资产放入当前迭代 `assets/`，并在文档登记 |

示例：

- taste 生成 HTML 高保真：放 `assets/mockups/`，登记到 `design.md`。
- 浏览器 QA 截图：放 `assets/screenshots/`，登记到 `qa.md`。
- 竞品截图或参考资料：放 `assets/references/`，登记到 `proposal.md` 或 `design.md`。

外部增强不能自行创建其他目录，也不能绕过 artifact-writer。

## 6. `state.json` 规则

`state.json` 只记录流程状态，不记录完整需求。

允许字段：

- `branch`：`new-project`、`iteration`、`bugfix`、`adopt-existing`
- `currentSpec`：当前迭代目录名，项目级阶段可为 `null`
- `currentStage`：当前阶段
- `gate.status`：`open`、`waiting_user`、`passed`、`blocked`
- `gate.requires`：当前等待用户确认的内容

完整内容必须写入 Markdown。

## 7. 命名规则

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


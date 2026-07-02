# `/solo` Skill 执行规则

## 1. 入口

公开入口只有一个：

```text
/solo <自然语言请求>
```

禁止要求用户直接调用内部阶段，如 `spec`、`tdd-plan`、`qa`。

## 2. 第一步必须复述

每次收到 `/solo` 请求后，先用简洁中文复述用户要做什么，并列出关键假设。

如果存在多种高风险解读，先问一个问题。不要在不清楚的情况下写文件或改代码。

## 3. 分支路由

按以下优先级判断分支：

| 分支 | 触发信号 |
|---|---|
| bugfix | 报错、失败、500、测试不过、页面坏了、修复 |
| adopt-existing | 老项目接入、补规范、整理流程、接入 SoloSpec |
| iteration | 新增能力、修改原功能、优化体验、删除旧能力、做页面、增加接口 |
| new-project | 我想做一个、从零开始、新项目、产品想法 |

如果无法判断，问用户：

```text
这是新项目、迭代、Bug 修复，还是老项目接入？
```

## 4. 门禁规则

硬门禁阶段必须停下等待用户明确确认：

- 分支确认。
- 产品方向和成功标准确认。
- PRD 范围确认。
- UI 方向确认，有 UI 时。
- 架构和技术方案确认。
- 可执行 Spec 确认。
- TDD 任务确认。
- QA 结果确认。
- 发布或归档确认。

只接受明确表达：

```text
通过
继续
按这个来
确认
```

沉默、闲聊、回答问题，不等于同意进入下一阶段。

## 5. 文件写入规则

只有 artifact-writer 能写入文件。

所有完整产物必须写入 `solo/`：

```text
solo/project/
solo/specs/
solo/decisions/
solo/archive/
solo/state.json
solo/config.json
```

外部 Skill、专家模块、评审模块只能输出建议，不得直接写文件。

## 6. 外部增强规则

如果用户环境存在 gstack、superpowers、BMAD、taste 等能力，它们只能作为可选增强：

- 可作为 Reviewer、Advisor 或 Generator 使用。
- 只能读取 SoloSpec 上下文。
- 输出必须转换成 SoloSpec 章节内容或 SoloSpec 资产记录。
- 不得自行创建 `docs/plans/`、`docs/功能/`、`specs/` 等其他目录。
- 不得自行提交代码。

三类增强的边界：

| 类型 | 允许做什么 | 不允许做什么 |
|---|---|---|
| Reviewer | 审查 SoloSpec 产物并输出问题 | 直接改文档或改代码 |
| Advisor | 给出方案、取舍、风险建议 | 绕过 SoloSpec 阶段门禁 |
| Generator | 生成线稿、HTML 高保真、截图、代码片段等原始产物 | 自行决定目录、章节、文件命名、事实源 |

例如 taste 生成的页面稿可以作为 Generator 产物，但必须由 SoloSpec 接收后写入：

```text
solo/specs/NNN-iteration-name/assets/mockups/
```

并在该迭代的 `design.md` 中登记路径、适用页面、状态覆盖和验收标准。

如果外部增强和 SoloSpec 规则冲突，SoloSpec 规则优先。

## 7. 新项目流程

```text
intake
→ brainstorm
→ product-research
→ prd
→ ux
→ architecture
→ spec
→ tdd-plan
→ implementation
→ qa
→ ship/archive
```

新项目先写项目级文档，再生成第一个 MVP spec。

默认创建：

```text
solo/project/
solo/specs/001-mvp/
solo/state.json
solo/config.json
```

## 8. 迭代流程

```text
intake
→ read-context
→ iteration-scope
→ spec
→ design
→ architecture
→ tdd-plan
→ implementation
→ qa
→ archive
```

迭代必须先读：

- `solo/project/`
- `solo/state.json`
- 相关 `solo/specs/*`
- 用户项目中相关代码和文档

再创建新的 `solo/specs/NNN-iteration-name/`。

## 9. Bug 修复流程

Bug 修复不走完整 PRD。

必须按顺序：

```text
intake
→ reproduce
→ root-cause
→ regression-test
→ fix
→ verify
→ archive
```

硬规则：

- 没有复现，不修。
- 没有根因，不修。
- 修复前先写或明确回归测试。
- 修复后更新对应 spec 的 `qa.md` 或创建 `solo/specs/NNN-bugfix-title/`。

## 10. 老项目接入流程

```text
intake
→ inventory
→ classify
→ create-solo
→ summarize-project
→ propose-adoption-plan
→ user-confirm
→ write-managed-blocks
```

老项目接入的目标是建立事实源，不是重构。

默认只读代码和文档，生成：

```text
solo/project/brief.md
solo/project/architecture.md
solo/project/quality.md
solo/project/pitfalls.md
solo/state.json
solo/config.json
```

## 11. TDD 规则

`tasks.md` 中每个实现任务必须包含：

```text
1. 要验证的行为
2. 先写的失败测试
3. 运行命令
4. 预期失败原因
5. 最小实现范围
6. 预期通过命令
7. 回归验证
```

禁止只写“补测试”“实现接口”“完善页面”这类不可执行任务。

## 12. UI/UX 规则

涉及 UI 时，`design.md` 必须包含：

- 页面或组件清单。
- 用户流。
- 线稿或高保真稿路径。
- 加载、空、错误、无权限、移动端状态。
- 文案规则。
- 实现验收点。

迭代新增或修改页面的线稿和高保真稿必须放在该迭代的 `assets/` 下。

## 13. 恢复会话

用户输入：

```text
/solo 继续
```

执行：

1. 读取 `solo/state.json`。
2. 读取当前 `currentSpec`。
3. 总结当前阶段和门禁。
4. 如果正在等待用户确认，重新展示需要确认的内容。
5. 不自动跨过门禁。

## 14. 完成标准

SoloSpec 不能用“应该好了”作为完成依据。

完成必须提供：

- 写入了哪些文件。
- 当前阶段是否通过门禁。
- 执行了哪些验证。
- 如果未验证，说明原因。
- 下一步等待用户确认什么。

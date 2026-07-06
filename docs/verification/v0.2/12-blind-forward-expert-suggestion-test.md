# 主 Skill 盲测前向测试报告

## 1. 测试结论

通过。

本轮使用一个不继承当前对话上下文的独立子代理，在全新目录中只安装主 `solo-spec` Skill，执行一次完整 iteration，验证主流程能在未安装专家 Skill 时表达专家增强为可选能力、拒绝自动调用，并降级完成基础流程。

测试目录：

```text
E:\test\solo-spec-blind-forward-20260705
```

子代理：

```text
019f325f-8866-7332-b0a5-4adaf1e49f40
```

## 2. 输入任务

```text
$solo-spec 给一个现有的 React 小工具增加 CSV 导入功能，需要页面交互、错误状态、TDD 和 QA。
```

约束：

- 只在测试目录创建或修改文件。
- 只安装 `solo-spec` 主 Skill。
- 不安装、不复制、不调用任何专家 sibling。
- 门禁用“模拟用户确认：确认”推进，便于完成闭环。
- 记录专家建议、自动调用情况和降级情况。

## 3. 执行结果

| 项 | 结果 |
|---|---|
| 分支 | `iteration` |
| 规格目录 | `solo/specs/001-csv-import/` |
| 最终阶段 | `archive` |
| `state.json` | `gate.requires` 为 `none` |
| 应用实现 | Vite + React + TypeScript CSV 导入工具 |
| QA 截图 | `solo/specs/001-csv-import/assets/screenshots/csv-import-success.png` |
| 子代理报告 | `blind-forward-report.md` |

## 4. 专家建议验证

| 阶段 | 建议专家 | 是否自动调用 | 未安装时是否降级 |
|---|---|---|---|
| `brainstorm` | `solo-spec-product` | 否 | 是 |
| `design` | `solo-spec-ux` | 否 | 是 |
| `architecture` / `plan` | `solo-spec-architecture` | 否 | 是 |
| `tdd-plan` | `solo-spec-tdd` | 否 | 是 |
| `qa` | `solo-spec-qa` | 否 | 是 |
| `archive` | `solo-spec-release` | 否 | 是 |

测试目录 `.agents/skills` 仅包含：

```text
solo-spec
```

## 5. 复核命令

| 命令 | 结果 |
|---|---|
| `npm test -- --run` | 2 个测试文件、8 个测试通过 |
| `npm run build` | TypeScript 检查和 Vite 构建通过 |
| `npm run qa` | Chromium 1 个 Playwright 测试通过 |
| `Get-Content -Raw solo/state.json \| ConvertFrom-Json` | JSON 解析通过 |

## 6. 发现并处理的问题

| 问题 | 影响 | 处理 |
|---|---|---|
| 子代理报告主 Skill 模板在 Windows shell 中显示乱码 | 不阻断流程，但影响中文用户体验 | 已在主 Skill 增加 UTF-8 读写规则，要求 Windows shell 读取中文文件时显式指定 UTF-8 |
| 测试目标目录没有现有 React 源码 | 与“现有小工具”输入不完全一致 | 按 Skill 规则创建最小可运行脚手架，未影响专家建议验证 |

## 7. 判定

`solo-spec` 主 Skill 的专家建议层满足当前要求：

- 用户仍只需要 `$solo-spec` 一个入口。
- 专家 Skill 是可选增强，不是流程依赖。
- 主流程必须在可增强阶段的门禁前报告当前阶段专家状态。
- 主流程不枚举全部 Skill。
- 未安装专家时不阻塞流程。
- 没有自动调用专家。
- 没有专家写文件、改状态机或通过门禁。

当前可进入提交前总检查。

## 8. 2026-07-06 入口与专家提示回归

文档入口统一为 `$solo-spec` 后，重新用 Codex CLI 在临时项目中验证 `brainstorm` 阶段专家提示。

测试输入：

```text
$solo-spec 我想做一个面向个人的极简待办清单 Web 应用，支持新增、完成、筛选和本地保存。这是新项目，我确认进入流程。请直接做到 brainstorm 选项门禁后停下，不要替我选择 MVP 方向，也不要进入下一阶段。
```

初始复测发现：主流程进入 `brainstorm` 后虽然输出了 `专家增强` 字段，但只写“未调用专家”，没有说明 `$solo-spec-product` 是否安装，也没有给出明确选择。已加固 `skills/solo-spec/SKILL.md` 和 `skills/solo-spec/references/experts.md`：mapped stage 的 `专家增强` 必须写出映射专家、安装检测结果、状态和允许的下一步选择。

复测结果：

| 安装模式 | 预期 | 结果 |
|---|---|---|
| `basic` | 只安装 `solo-spec`；`brainstorm` 提示 `$solo-spec-product` 未安装，可跳过或指定其他 Skill / 工具 | 通过 |
| `enhanced` | 安装主 Skill 和专家 Skill；`brainstorm` 提示 `$solo-spec-product` 已安装，可调用专家或跳过专家选择方向 | 通过 |

断言覆盖：

- 输出包含 `专家增强`。
- 输出包含当前阶段映射专家 `$solo-spec-product`。
- `basic` 输出包含未安装 / 不可用 / 指定其他 Skill 或工具。
- `enhanced` 输出包含已安装 / 调用 `$solo-spec-product` / 跳过专家。
- 两个临时项目的 `solo/state.json` 均可 JSON 解析。
- 临时项目已清理。

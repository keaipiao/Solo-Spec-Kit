# 四分支回归测试报告

## 1. 测试结论

通过。

本轮在全新目录中创建四个测试项目，均使用 `scripts/install-project-skills.ps1 -Mode enhanced` 安装 v0.2 最终增强形态，验证新项目、迭代、Bug 修复和老项目接入四条分支的目录、状态和文档边界仍符合 SoloSpec 规则。

测试目录：

```text
E:\test\solo-spec-four-branch-regression-20260705
```

## 2. 安装形态

四个测试项目均安装：

```text
solo-spec
solo-spec-architecture
solo-spec-product
solo-spec-qa
solo-spec-release
solo-spec-tdd
solo-spec-ux
```

## 3. 分支用例

| 测试项目 | 分支 | 场景 | 结果 |
|---|---|---|---|
| `new-project` | `new-project` | 从零创建本地任务提醒工具 | 通过 |
| `iteration` | `iteration` | 给已有表格工具增加 CSV 导入 | 通过 |
| `bugfix` | `bugfix` | 修复 token 刷新后旧 token 竞态 | 通过 |
| `adopt-existing` | `adopt-existing` | 接入已有 Node 小工具 | 通过 |

## 4. 断言规则

全局断言：

- 每个测试项目均安装 7 个 Skill。
- 每个测试项目均有合法 `solo/state.json`。
- 每个闭环流程的 `gate.status` 为 `passed`。
- 每个闭环流程的 `gate.requires` 为 `none`。

新项目断言：

- 项目级结论写入 `solo/project/brief.md`、`prd.md`、`ux.md`、`design-system.md`、`architecture.md`。
- 项目级 architecture 通过后创建 `solo/specs/001-mvp/`。
- `solo/specs/001-mvp/` 只包含共享 SDD/TDD 文档，不创建 `brainstorm.md` 和 `proposal.md`。

迭代断言：

- 当前迭代创建 `solo/specs/002-csv-import/`。
- 迭代包含 `brainstorm.md`、`proposal.md`、`spec.md`、`design.md`、`plan.md`、`tasks.md`、`qa.md`、`archive.md`。

Bug 修复断言：

- 独立 Bugfix 创建 `solo/specs/003-bugfix-token-refresh/`。
- Bugfix 只包含 `proposal.md`、`plan.md`、`tasks.md`、`qa.md`、`archive.md`。
- Bugfix 不创建 `brainstorm.md`、`spec.md`、`design.md`。

老项目接入断言：

- 默认只生成 `solo/project/brief.md`、`architecture.md`、`quality.md`、`pitfalls.md`。
- `state.json.currentSpec` 为 `null`。
- 默认不创建 `solo/specs/`。

## 5. 验证命令

```text
scripts/install-project-skills.ps1 -ProjectPath <case> -Mode enhanced
```

生成四分支最小闭环产物后，使用 JSON 和文件系统断言检查目录结构、状态文件和禁止生成项。

结果：

```text
PASS
```

## 6. 判定

v0.2 最终安装形态没有破坏四条主流程：

- 新项目仍先写项目级结论，再进入统一 SDD/TDD。
- 迭代仍保留当前迭代的 brainstorm 和 proposal。
- Bugfix 仍使用缩减规格，不误生成功能级文档。
- 老项目接入仍默认不创建 specs，不改业务代码。

四分支流程可以作为 v0.2 后续回归基线。

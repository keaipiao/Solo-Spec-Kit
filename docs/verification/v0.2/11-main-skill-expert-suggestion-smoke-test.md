# 主 Skill 专家建议接入烟测

## 1. 测试结论

通过。

本轮验证更新后的 `solo-spec` 主 Skill 在只安装主 Skill、未安装任何专家 sibling 的情况下，仍能保留基础流程，并明确表达专家模块是“门禁前提示状态、需确认、可降级”的增强能力。

测试目录：

```text
E:\test\solo-spec-main-suggestion-smoke-20260705
```

## 2. 安装形态

测试目录只复制：

```text
.agents/skills/solo-spec
```

未复制：

```text
solo-spec-product
solo-spec-ux
solo-spec-architecture
solo-spec-tdd
solo-spec-qa
solo-spec-release
```

该形态用于验证主流程不依赖专家 Skill 存在。

## 3. 验证项

| 验证项 | 结果 |
|---|---|
| 主流程声明无专家时仍可运行 | 通过 |
| 复杂阶段可加载 `references/experts.md` | 通过 |
| 使用专家前必须说明收益并询问用户 | 通过 |
| 不默认自动调用专家 | 通过 |
| 专家不可用时降级到基础流程 | 通过 |
| `brainstorm` / `scope` 映射产品专家 | 通过 |
| `ux` / `design` 映射 UX 专家 | 通过 |
| `architecture` / `plan` / `root-cause` 映射架构专家 | 通过 |
| `tdd-plan` / `regression-test` 映射 TDD 专家 | 通过 |
| `qa` / `verify` 映射 QA 专家 | 通过 |
| `archive` / `write-managed-blocks` 映射 Release 专家 | 通过 |
| expert packet 有消费顺序 | 通过 |
| 专家不能通过门禁 | 通过 |
| 只允许当前阶段写入目标 | 通过 |
| 无旧版 `v0.1 flow validation` 或 `contract-only` 残留 | 通过 |

## 4. 断言输出

```text
installed_siblings: solo-spec
result: PASS
```

## 5. 判定

主 Skill 已完成专家增强层接入：

- 用户仍只需要 `$solo-spec` 一个入口。
- 主流程必须在可增强阶段的门禁前报告当前阶段专家状态。
- 主流程不枚举全部 Skill。
- 专家调用必须经过用户确认。
- 未安装专家时不阻塞流程。
- 专家输出仍由主流程消费，不直接写文件、不改状态机、不通过门禁。

真实独立子代理盲测已完成，见 `docs/verification/v0.2/12-blind-forward-expert-suggestion-test.md`。

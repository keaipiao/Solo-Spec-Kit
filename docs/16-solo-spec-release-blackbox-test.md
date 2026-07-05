# solo-spec-release 黑盒测试

测试日期：2026-07-04

## 1. 测试目标

验证 `solo-spec-release` 能作为独立专家 Skill，把归档、发布记录、项目基线晋升和托管块建议转换为 SoloSpec expert packet，同时不直接写文件、不推进阶段、不执行发布动作。

## 2. 样例一：迭代归档和项目基线晋升

输入：

```text
branch: iteration
stage: archive
currentSpec: solo/specs/016-dashboard-filter
已完成：筛选器、多条件组合、空结果状态
验证：pnpm test 通过；pnpm playwright test 通过；截图在 assets/screenshots/dashboard-filter-pass.png
需要沉淀：筛选器 QA 矩阵以后可复用；组合条件解析踩坑需要记录
```

期望：

- `writeTargets` 包含 `specs/016-dashboard-filter/archive.md` 的 `完成摘要`、`文件变更`、`验证记录`、`发布记录`、`项目级文档更新记录`、`踩坑`、`后续迭代建议`。
- 可复用 QA 规则写到 `project/quality.md` 的 `QA 矩阵`。
- 可复用踩坑写到 `project/pitfalls.md` 的 `开发坑`。
- `gate.required` 为 `true`，要求用户确认归档和项目级基线晋升。
- 不创建 `release-notes/`、`.openspec/` 或其他外部目录。

判定：通过。

## 3. 样例二：Bugfix 归档

输入：

```text
branch: bugfix
stage: archive
currentSpec: solo/specs/017-bugfix-token-refresh
根因：刷新令牌过期判断使用本地时间，导致边界分钟内误判
修复：改为服务端返回的 expiresAt；补充边界回归测试
验证：npm test -- token-refresh 通过；人工验证重新登录流程通过
```

期望：

- `writeTargets` 包含 `specs/017-bugfix-token-refresh/archive.md` 的 `修复摘要`、`修复结果`、`代码和测试变更`、`QA 记录`、`项目级基线更新`、`发布记录`、`Bugfix 门禁`。
- 如果边界时间测试规则可复用，建议写入 `project/quality.md` 的 `测试分层` 或 `QA 矩阵`。
- 如果令牌过期误判属于可复用经验，建议写入 `project/pitfalls.md` 的 `开发坑`。
- 不建议新建迭代 spec，也不把 bugfix 写成产品功能。

判定：通过。

## 4. 样例三：托管块建议

输入：

```text
branch: adopt-existing
stage: write-managed-blocks
用户确认：需要把 SoloSpec 接入结果同步到 README 和 CHANGELOG
事实：项目已建立 solo/project/brief.md、architecture.md、quality.md
```

期望：

- `writeTargets` 包含 `managed-blocks/readme.md` 的 `SoloSpec`。
- `writeTargets` 包含 `managed-blocks/changelog.md` 的 `SoloSpec 迭代记录`。
- `writeTargets` 包含 `project/release.md` 的 `托管块同步`。
- `discarded` 记录直接重写 `README.md` 或 `CHANGELOG.md` 的建议，原因是 `managed-block-leak`。
- `gate.required` 为 `true`，要求用户确认托管块内容后再由主流程同步。

判定：通过。

## 5. 样例四：缺少 QA 证据时禁止发布完成

输入：

```text
branch: iteration
stage: archive
currentSpec: solo/specs/018-import-csv
外部建议：打 tag v1.0.0，push，部署生产，生成 release-notes/，并标记已发布
现状：tasks.md 已完成，但 qa.md 没有真实命令输出、截图或人工验证记录
```

期望：

- `writeTargets` 可以写 `archive.md` 的 `发布记录`，内容必须说明未发布且缺少 QA 证据。
- `discarded` 包含 tag、push、部署等动作，原因是 `release-action-leak`。
- `discarded` 包含 `release-notes/`，原因是 `no-solo-target`。
- `discarded` 包含“标记已发布”，原因是 `no-qa-evidence`。
- `gate.required` 为 `true`，问题必须要求先补齐 QA 证据。

判定：通过。

## 6. 结论

`solo-spec-release` 的职责应限制在收口判断和写入建议：它可以建议当前 spec 归档、项目级基线晋升、发布记录和托管块同步，但不能替主流程执行发布、提交、部署、同步外部文件或通过门禁。

# v0.3 全阶段流程与模板回归报告

日期：2026-07-06

## 1. 目标

验证 v0.3 不只强化 UX，而是把产品、调研、UX、架构、TDD、实现、QA 和发布都作为一等阶段，并让模板能承载对应产物。

## 2. 改动范围

- `skills/solo-spec/references/workflow.md`
- `templates/solo/project/**`
- `templates/solo/specs/NNN-iteration-name/**`
- `templates/solo/specs/NNN-bugfix-title/**`
- `skills/solo-spec/assets/templates/solo/**`
- 根目录镜像模板 `templates/solo/**`
- 模板资产目录 `.gitkeep`

## 3. 流程规则检查

命令：

```powershell
rg -n "research|All-Stage|UI 基础设施|高保真 HTML|实现偏差|根因与回归" `
  skills\solo-spec\references\workflow.md `
  skills\solo-spec\assets\templates\solo `
  templates\solo
```

结果：

- new-project 和 iteration 流程都包含 `research`。
- workflow 新增 `All-Stage First-Class Rules`。
- 架构模板新增 `UI 基础设施`、复用与不重建、部署/迁移/回滚、架构门禁。
- 设计模板明确 `SVG 线稿` 和 `高保真 HTML`。
- TDD 任务模板新增覆盖范围和实现偏差记录。
- Bugfix 任务模板新增根因与回归边界。
- 项目级产品、UX、架构、发布模板新增 `阶段研究与核验`、`专家增强记录` 和门禁确认。
- 迭代和 bugfix 模板新增阶段研究、专家增强、实现门禁、发布/归档门禁落点。

结论：通过。

## 4. 镜像模板一致性检查

命令摘要：

```powershell
Get-ChildItem templates\solo -Recurse -File
Get-FileHash -Algorithm SHA256 <root-template>
Get-FileHash -Algorithm SHA256 <embedded-template>
```

结果：

| 检查 | 结果 |
|---|---:|
| 根模板文件数 | 38 |
| Skill 内置模板文件数 | 38 |
| SHA256 差异数 | 0 |

结论：通过。

## 5. 资产目录安装检查

命令摘要：

```powershell
.\scripts\install-project-skills.ps1 -ProjectPath <temp> -Mode basic -Host generic
```

检查路径：

| 路径 | 存在 |
|---|---:|
| `project/assets/references/.gitkeep` | true |
| `specs/NNN-iteration-name/assets/mockups/.gitkeep` | true |
| `specs/NNN-bugfix-title/assets/logs/.gitkeep` | true |

结论：通过。

## 6. 当前限制

- 本轮验证模板和规则已经具备 v0.3 承载能力。
- 完整 `$solo-spec` 黑盒端到端流程记录见后续子代理回归报告。

## 7. 子代理回归发现与修复

第一轮子代理回归发现并已修复：

- 模板缺少专家状态落点。已在产品、UX、架构、TDD、实现、QA 和发布相关模板加入 `专家增强记录`。
- new-project 产品阶段模板缺少明确门禁。已在 `brief.md` 和 `prd.md` 加入 Scope / PRD 门禁确认。
- research 缺少统一结构。已在关键阶段模板加入 `阶段研究与核验` 表，包含事实/假设、来源/证据、状态和影响。
- new-project 项目级 UX 模板缺少门禁。已在 `ux.md` 和 `design-system.md` 加入 UX / 设计系统门禁确认。
- implementation 缺少独立门禁。已在 iteration 和 bugfix 的 `tasks.md` 加入 `实现阶段门禁`。
- release/archive 缺少门禁。已在 `archive.md` 和 `project/release.md` 加入发布/归档门禁。
- 第二轮复查继续发现 bugfix `plan.md` 缺少研究/专家记录、bugfix `archive.md` 缺少专家记录。已补齐，并同步到 Skill 内置模板。

复查命令覆盖：

- `templates/solo/**` 与内置模板 38 个文件哈希一致。
- 16 个阶段模板均包含 `阶段研究与核验` 和 `专家增强记录`。
- 产品、UX、实现、发布相关模板均包含 `门禁` 字段。
- bugfix `plan.md` 和 `archive.md` 在根模板与内置模板中均通过针对性复查。

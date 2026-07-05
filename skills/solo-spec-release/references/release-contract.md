# SoloSpec Release Contract

Use this reference to map archive summaries, release records, baseline promotions, pitfalls, quality updates, and managed-block suggestions into SoloSpec artifacts.

This file defines where release content may land. It does not grant write, commit, publish, or deploy permission.

## 1. Stage Boundaries

| Branch / stage | Allow | Reject |
|---|---|---|
| new-project `ship/archive` | MVP completion summary, verification record, release notes, project baseline updates after confirmed ship | archiving without QA evidence, publishing/tagging without explicit user action |
| iteration `archive` | current spec completion summary, file changes, verification record, release record, baseline promotion suggestions, pitfalls, follow-ups | changing project docs mid-implementation, promoting unverified experiments |
| bugfix `archive` | fix summary, fix result, code/test changes, QA record, project baseline update, release record, bugfix gate advice | broad release notes unrelated to the bug, new feature scope |
| adopt-existing `write-managed-blocks` | managed-block content suggestions and project summary blocks after confirmation | rewriting whole README/CHANGELOG/AGENTS outside managed blocks |

Project baseline promotion happens at archive/release time, not during brainstorm, design, architecture, TDD, or QA.

## 2. Section Mapping

Paths are relative to `solo/`.

| Output | File | Section |
|---|---|---|
| iteration completion summary | current spec `archive.md` | 完成摘要 |
| iteration file changes | current spec `archive.md` | 文件变更 |
| iteration verification record | current spec `archive.md` | 验证记录 |
| iteration release record | current spec `archive.md` | 发布记录 |
| iteration project-doc updates | current spec `archive.md` | 项目级文档更新记录 |
| iteration pitfalls | current spec `archive.md` | 踩坑 |
| iteration follow-ups | current spec `archive.md` | 后续迭代建议 |
| bugfix summary | current bugfix spec `archive.md` | 修复摘要 |
| bugfix result | current bugfix spec `archive.md` | 修复结果 |
| bugfix code/test changes | current bugfix spec `archive.md` | 代码和测试变更 |
| bugfix QA record | current bugfix spec `archive.md` | QA 记录 |
| bugfix baseline update | current bugfix spec `archive.md` | 项目级基线更新 |
| bugfix release record | current bugfix spec `archive.md` | 发布记录 |
| bugfix gate | current bugfix spec `archive.md` | Bugfix 门禁 |
| release environment | `project/release.md` | 环境 |
| release process | `project/release.md` | 发布流程 |
| version rules | `project/release.md` | 版本规则 |
| rollback strategy | `project/release.md` | 回滚策略 |
| managed-block sync | `project/release.md` | 托管块同步 |
| quality testing layers | `project/quality.md` | 测试分层 |
| quality TDD rules | `project/quality.md` | TDD 规则 |
| quality QA matrix | `project/quality.md` | QA 矩阵 |
| quality security | `project/quality.md` | 安全 |
| quality performance/observability | `project/quality.md` | 性能和可观测性 |
| development pitfall | `project/pitfalls.md` | 开发坑 |
| deployment pitfall | `project/pitfalls.md` | 部署坑 |
| product/design pitfall | `project/pitfalls.md` | 产品 / 设计坑 |
| README managed block | `managed-blocks/readme.md` | SoloSpec |
| CHANGELOG managed block | `managed-blocks/changelog.md` | SoloSpec 迭代记录 |

If the exact section is missing, use the closest existing section and explain the fit in `recommendation`.

## 3. Baseline Promotion Rules

Promote to project baseline only when:

- current spec is complete
- QA evidence exists
- gate was or will be explicitly confirmed by the user
- the lesson or decision is reusable beyond the current spec
- the target project document has a matching section

Do not promote:

- rejected brainstorm options
- unverified UX/architecture/TDD ideas
- one-off implementation detail
- temporary workaround unless it is a known pitfall
- local bug detail that does not affect future quality rules

If unsure, keep the item in current `archive.md` and set a gate question.

## 4. Managed Block Rules

Managed-block output is a suggestion, not a direct external file edit.

Allowed targets:

- `managed-blocks/readme.md`
- `managed-blocks/changelog.md`
- `managed-blocks/agents.md` when a matching section exists or the main workflow has a managed-block rule
- `project/release.md` section `托管块同步`

Do not rewrite whole README, CHANGELOG, AGENTS, CLAUDE, or other external docs.

## 5. Evidence Rules

Archive and release summaries must cite available evidence:

- QA command or method
- screenshot/log path if relevant
- tasks completed
- changed files or modules
- release/deploy command if actually run by the main workflow
- residual risk or not-tested scope

If evidence is missing, set `gate.required: true` and do not recommend release completion.

## 6. Discard Rules

Discard these items instead of mapping them:

- release complete claim without QA evidence
- commit, tag, push, deploy, publish, or version bump action
- unconfirmed managed-block edits
- whole-file README/CHANGELOG/AGENTS rewrite outside managed blocks
- project baseline promotion before archive
- unverified experiment promoted to project docs
- external release directories such as `release-notes/`, `docs/changelog/`, `.changeset/`
- unrelated follow-up work hidden inside archive

Use short machine-readable discard reasons when possible:

```text
no-qa-evidence
requires-user-confirmation
release-action-leak
managed-block-leak
baseline-pollution
wrong-stage
future-work
no-solo-target
```

## 7. Gate Advice

Set `gate.required` to `true` when:

- QA evidence is missing or incomplete
- release/deploy status is unknown
- project baseline promotion needs user approval
- managed-block content needs confirmation
- residual risk remains
- archive would close an incomplete spec

Set `gate.question` as one concise Chinese question. Do not mark the gate as passed.

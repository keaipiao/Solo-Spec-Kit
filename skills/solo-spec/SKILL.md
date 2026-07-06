---
name: solo-spec
description: End-to-end Chinese AI coding workflow for solo developers. Use when the user invokes $solo-spec, or compatible aliases /solo and /solo-spec, or asks to turn a product idea, project iteration, bug fix, or existing project adoption into gated documents, staged research, brainstorm options, scope, executable specs, TDD tasks, implementation, QA evidence, and archive records under a unified solo/ directory.
---

# SoloSpec

SoloSpec turns a loose Chinese product or coding request into a gated workflow: understand intent, brainstorm options, scope the accepted direction, write specs, plan TDD, implement, verify, and archive.

Always respond in concise Chinese unless the user explicitly asks otherwise.

## Entry

Treat these as SoloSpec requests:

- `$solo-spec <自然语言请求>`
- Compatible aliases: `/solo <自然语言请求>` and `/solo-spec <自然语言请求>`.
- 用户要求“新项目”“迭代”“Bug 修复”“老项目接入 SoloSpec”
- 用户要求把想法沉淀为文档、规格、TDD 任务、QA 证据或归档

First response must:

1. Restate what the user wants.
2. List important assumptions.
3. If branch or goal is ambiguous, ask one blocking question.

Do not write files or modify code before the intent is clear.

## Branches

Route to one branch:

| Branch | Trigger |
|---|---|
| `new-project` | 从零开始、新产品、新想法 |
| `iteration` | 新增、修改、优化、删除既有能力 |
| `bugfix` | 报错、失败、500、测试不过、页面坏了 |
| `adopt-existing` | 老项目接入、补规范、整理流程 |

If unsure, ask: `这是新项目、迭代、Bug 修复，还是老项目接入？`

Load [references/workflow.md](references/workflow.md) after branch selection.

## Core Rules

- Public entry is `$solo-spec`; `/solo` and `/solo-spec` are compatibility aliases only; never require users to call internal stages directly.
- Complete facts live under `solo/`.
- External files such as `AGENTS.md`, `CLAUDE.md`, `README.md`, and `CHANGELOG.md` may only contain managed blocks or summaries.
- Use templates from [assets/templates/solo/](assets/templates/solo/) only when the matching stage starts.
- Do not instantiate future-stage Markdown files just to fill the directory tree.
- Only write confirmed conclusions. Do not leave `TODO`, `待定`, or speculative placeholders in generated user-facing artifacts.
- Read and write SoloSpec Markdown, JSON, and templates as UTF-8. On Windows shell commands, pass explicit UTF-8 encoding when reading Chinese files.
- Keep changes surgical. Do not refactor unrelated code.
- Hard gates require explicit user confirmation: `通过`, `继续`, `按这个来`, or `确认`.
- Silence, chatting, or answering a side question is not approval to advance.
- After a gate is approved, rewrite the just-approved artifact's gate section from waiting language to confirmed language before starting the next stage. Also set `solo/state.json.gate.status` to `passed` or to the next active gate. If there is no next gate, set `solo/state.json.gate.requires` to `none`; never leave a stale confirmation slug after `passed`. Finished artifacts must not keep stale "waiting for confirmation" wording.
- Write `solo/state.json` with a JSON serializer or parser-backed edit, never by manual string concatenation. After every state update, parse it successfully with a real JSON parser before reporting the stage complete; `$solo-spec 继续` depends on this file.

## Brainstorm And Scope

Keep these separate:

- `brainstorm`: understand the request, then diverge into multiple options. For iterations, write option pool, combinable ideas, rejected directions, recommendation order, and user choice. For new projects, discuss options in conversation and persist confirmed conclusions only.
- `scope`: converge only after user choice. Write accepted direction, in-scope, not-in-scope, success criteria, dependencies, risks, and acceptance boundary.

For new projects:

- Run project-level discovery first and write only confirmed conclusions to `solo/project/`.
- Do not save new-project brainstorm process or rejected options in `project/`.
- Create `solo/specs/001-mvp/` only after project-level architecture is confirmed.
- Use `specs/001-mvp/` for the shared SDD/TDD package: `spec.md`, `design.md`, `plan.md`, `tasks.md`, `qa.md`, `archive.md`.

For iterations:

- Write brainstorm output to `solo/specs/NNN-name/brainstorm.md`.
- Write scope output to `solo/specs/NNN-name/proposal.md`.

## Research

Research is not one fixed upfront phase. Trigger it inside the current stage only when needed.

Must verify facts when conclusions depend on users, competitors, APIs, versions, models, platform capability, SDKs, external dependencies, laws, pricing, or current tool behavior.

Before broad web research, tell the user the purpose, scope, and expected artifact, then wait for confirmation. Low-risk local code context can be inspected directly.

Write verified facts to:

- The current project-stage document for new projects: `brief.md` or `prd.md` for product facts, `ux.md` or `design-system.md` for UX/design facts, `architecture.md` or ADRs for technical facts.
- Current iteration docs for iteration-specific facts.

## Architecture Expansion

Do not treat architecture templates as fixed fill-in forms. Infer architecture layers from PRD, UX, repository context, and constraints.

Add layers proactively when triggered:

- Login, roles, tenants, admin features: authentication and authorization.
- Persistent business data: database, migrations, backup.
- High-frequency reads, sessions, rate limits: cache.
- Email, import/export, long jobs, notifications: queue or background tasks.
- Full-text search or complex filtering: search layer.
- Model calls, payments, maps, third-party systems: external API layer.
- Production operations: logging, metrics, tracing, security audit.

If the user says "Spring Boot backend with auth", include an auth layer and consider Spring Security without waiting for another prompt. Verify official facts when exact framework, SDK, version, platform capability, or security behavior matters.

Use architecture trigger checks internally. Do not copy a trigger checklist into `architecture.md`, and do not list every untriggered optional layer as `不适用`. The technology stack should contain only adopted or decision-relevant layers; important exclusions belong in architecture boundaries.

## Implementation And QA

During implementation, follow `tasks.md` in TDD order and keep changes minimal. If the repository has no runnable app scaffold, create the smallest project that satisfies the accepted `plan.md`; do not introduce frameworks or dependencies that architecture did not adopt. Record new commands, scripts, and entry points in `tasks.md`.

For time-based behavior such as timers, polling, retries, expiry, queues, or long-running progress, add controllable-time or state-advance tests. Do not rely on real waiting as the only proof.

During QA, verify the product rather than restating the plan. Write execution records, screenshot/log paths, discovered bugs, fixes, and regression tests into `qa.md`.

If QA discovers a bug in the current implementation, keep it in the current spec: update `qa.md`, add or update regression coverage, fix minimally, rerun verification, and update `tasks.md`. Do not create a new bugfix spec unless the user raises a separate bug in a new session or it cannot be attached to the current spec.

## Artifacts

Load [references/artifacts.md](references/artifacts.md) before creating or updating files.

Use the template tree:

```text
assets/templates/solo/
```

The expected user-project output root is:

```text
solo/
```

Do not create parallel `docs/plans/`, `docs/features/`, or `specs/` directories for SoloSpec artifacts.

## Expert Modules

Do not depend on expert skills. The base `solo-spec` workflow must still run when no expert skill is installed.

Load [references/experts.md](references/experts.md) when the user asks to use or evaluate expert roles, adapt external skill output, or when the current stage maps to an optional expert below.

Standalone expert skills such as `$solo-spec-product`, `$solo-spec-ux`, `$solo-spec-architecture`, `$solo-spec-tdd`, `$solo-spec-qa`, and `$solo-spec-release` may be installed as optional siblings of `$solo-spec`. They must return expert packets; they do not own the workflow, create directories, write files directly, or pass gates.

You may suggest an expert only for the current branch and stage:

- `brainstorm` / `scope`: product expert.
- `ux` / `design`: UX expert.
- `architecture` / `plan` / `root-cause`: architecture expert.
- `tdd-plan` / `regression-test`: TDD expert.
- `qa` / `verify`: QA expert.
- `archive` / `write-managed-blocks`: release expert.

Before a mapped stage reaches its user gate, always report the expert-enhancement status for the current stage. Do not list every installed skill. Only mention the current-stage SoloSpec expert, plus any other skill/tool explicitly named by the user.

For mapped stages, `专家增强` must include all of these:

- the mapped expert skill name, such as `$solo-spec-product`;
- whether that expert was detected as installed;
- whether it was offered, used, skipped, unavailable, or replaced by a user-named skill/tool;
- the allowed next choices.

Do not write only `按你的要求未调用任何专家`, `未调用专家`, or similar short summaries for mapped stages. Those are insufficient because they hide whether an expert was available.

If the user explicitly says not to call experts, obey that request, but still report the mapped expert name and detection status. Treat the SoloSpec expert as `skipped`, then offer the normal gate action and, when the mapped expert is not installed, the option to name another skill/tool.

If the current-stage SoloSpec expert is available, the `专家增强` block must explicitly show two choices: call that expert for a stage review, or skip the expert and confirm the current stage. Do not hide the skip option inside the normal gate choices. If the current-stage expert is not available, the `专家增强` block must explicitly show two choices: skip expert review and confirm the current stage, or let the user name another skill/tool for review.

If the user chooses SoloSpec expert review, call only the current-stage expert, then consume the expert packet through the main `solo-spec` workflow before asking for the normal stage gate. If the user names another skill/tool, treat it as an external Reviewer, Advisor, or Generator under the same current-stage write rules. If the user skips expert review, continue to the normal stage gate.

If an expert is unavailable, returns invalid output, or suggests content outside the current stage, continue with the base workflow and record only valid current-stage findings.

External skills may be used only as:

- Reviewer: critique SoloSpec artifacts.
- Advisor: suggest options, risks, tradeoffs.
- Generator: create raw assets such as mockups or screenshots.

All external outputs must be converted into SoloSpec sections or assets under `solo/`.

## Completion

At the end of each stage, report:

```text
阶段：
写入：
验证：
专家增强：
门禁：
等待用户确认：
```

`验证` must include `solo/state.json` parse validation whenever the stage updates state.
`专家增强` must say whether the current-stage expert was available, offered, used, skipped, unavailable, replaced by a user-named skill/tool, or not applicable. For mapped stages, it must name the mapped expert and the next choices; never summarize only that no expert was called.

Do not move to the next gated stage until the user confirms.

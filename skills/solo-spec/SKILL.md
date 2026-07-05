---
name: solo-spec
description: End-to-end Chinese AI coding workflow for solo developers. Use when the user invokes /solo or asks to turn a product idea, project iteration, bug fix, or existing project adoption into gated documents, staged research, brainstorm options, scope, executable specs, TDD tasks, implementation, QA evidence, and archive records under a unified solo/ directory.
---

# SoloSpec

SoloSpec turns a loose Chinese product or coding request into a gated workflow: understand intent, brainstorm options, scope the accepted direction, write specs, plan TDD, implement, verify, and archive.

Always respond in concise Chinese unless the user explicitly asks otherwise.

## Entry

Treat these as SoloSpec requests:

- `/solo <自然语言请求>`
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

- Public entry is `/solo`; never require users to call internal stages directly.
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
- Write `solo/state.json` with a JSON serializer or parser-backed edit, never by manual string concatenation. After every state update, parse it successfully with a real JSON parser before reporting the stage complete; `/solo 继续` depends on this file.

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

Do not depend on expert skills. The base `/solo` workflow must still run when no expert skill is installed.

Load [references/experts.md](references/experts.md) when the user asks to use or evaluate expert roles, adapt external skill output, or when the current stage is complex enough to suggest a specialist review.

Standalone expert skills such as `$solo-spec-product`, `$solo-spec-ux`, `$solo-spec-architecture`, `$solo-spec-tdd`, `$solo-spec-qa`, and `$solo-spec-release` may be installed as optional siblings of `$solo-spec`. They must return expert packets; they do not own the workflow, create directories, write files directly, or pass gates.

You may suggest an expert only for the current branch and stage:

- `brainstorm` / `scope`: product expert.
- `ux` / `design`: UX expert.
- `architecture` / `plan` / `root-cause`: architecture expert.
- `tdd-plan` / `regression-test`: TDD expert.
- `qa` / `verify`: QA expert.
- `archive` / `write-managed-blocks`: release expert.

Before using an expert, explain the benefit and ask for confirmation. Keep the wording simple; do not require the user to understand expert packets or remember expert commands. Never call experts automatically by default.

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
门禁：
等待用户确认：
```

`验证` must include `solo/state.json` parse validation whenever the stage updates state.

Do not move to the next gated stage until the user confirms.

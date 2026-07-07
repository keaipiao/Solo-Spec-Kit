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
- Do not skip to implementation just because the user phrases the request as coding work, such as "现在接入接口", "直接实现", or "把这个功能加上". Unless `solo/state.json.currentStage` is already `implementation` or `fix` and all required upstream gates have passed, treat it as intake or the current gated stage first.
- If no valid `solo/state.json` exists, the first SoloSpec response must stay in `intake`: classify the branch, state assumptions, create or update only SoloSpec state/artifacts allowed by intake, and wait for the required gate. Do not edit business code.
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

For third-party services, QA must first verify service availability before skipping related tests. Use the cheapest real check that matches the integration, such as an authenticated health/status request, a sandbox API call, a documented ping endpoint, or the product's actual integration path with test credentials. If the service cannot be reached because credentials, network, quota, sandbox access, or provider outage blocks testing, record the exact attempted command/method, timestamp, result/error, and why it blocks only that QA item. Do not mark QA passed when an in-scope third-party dependency is untested without evidence.

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
Load [references/host-adapters.md](references/host-adapters.md) before reporting that a mapped expert is unavailable.

Standalone expert skills such as `$solo-spec-product`, `$solo-spec-ux`, `$solo-spec-architecture`, `$solo-spec-tdd`, `$solo-spec-qa`, and `$solo-spec-release` may be installed as siblings of `$solo-spec`. In v0.3 they are current-stage virtual team members, not separate public workflow entries. They must return expert packets; they do not own the workflow, create directories, write standard `solo/` files directly, or pass gates.

When checking whether the current-stage expert is installed, inspect host-specific project skill roots before reporting unavailable:

- the parent directory of the running `solo-spec` skill, because experts are usually sibling directories;
- the active host adapter roots from [references/host-adapters.md](references/host-adapters.md);
- compatible project roots from [references/host-adapters.md](references/host-adapters.md) when the active host is unknown.

Treat an expert as installed when `<skills-root>/<expert-name>/SKILL.md` exists in any known root. Do not report a mapped expert as unavailable until these roots have been checked or the host provides an equivalent skill registry that clearly excludes it.

You may suggest an expert only for the current branch and stage:

- `brainstorm` / `scope`: product expert.
- `ux` / `design`: UX expert.
- `architecture` / `plan` / `root-cause`: architecture expert.
- `tdd-plan` / `regression-test`: TDD expert.
- `implementation` / `fix`: TDD expert for red-green scope plus architecture expert for structural risk review.
- `qa` / `verify`: QA expert.
- `archive` / `write-managed-blocks`: release expert.

Before a mapped stage reaches its user gate, always report the expert-enhancement status for the current stage. Do not list every installed skill. Only mention the current-stage SoloSpec expert, what it did or why it was skipped/unavailable, plus any other skill/tool explicitly named by the user.

For mapped stages, `专家增强` must include all of these:

- the mapped expert skill name, such as `$solo-spec-product`;
- whether that expert was detected as installed;
- whether it was used, skipped, unavailable, or replaced by a user-named skill/tool;
- the allowed next choices.

Do not write only `按你的要求未调用任何专家`, `未调用专家`, or similar short summaries for mapped stages. Those are insufficient because they hide whether an expert was available.

If the user explicitly says not to call experts, obey that request, but still report the mapped expert name and detection status. Treat the SoloSpec expert as `skipped`, then offer the normal gate action and, when the mapped expert is not installed, the option to name another skill/tool.

If the current-stage SoloSpec expert is available, use it by default for the current stage and current mode: `co-create`, `generate-assets`, or `review`. Do not wait for the user to ask for that expert. The only reasons to skip an available mapped expert are: the user explicitly said to skip experts, the stage is not mapped, the expert output would require a separate user-approved side effect such as broad web research or asset generation, or the expert returns invalid/out-of-stage output. If expert action may take time, perform external research, generate assets, change the stage conclusion, or affect a project baseline, explain the impact before doing it and ask only for that side effect when required. If the current-stage expert is not available, the `专家增强` block must explicitly say the base workflow continues and allow the user to name another skill/tool.

When a SoloSpec expert returns output, consume the expert packet through the main `solo-spec` workflow before asking for the normal stage gate. If the user names another skill/tool, treat it as `external-adapter` output under the same current-stage write rules. If the user skips expert use, continue to the normal stage gate.

If an expert is unavailable, returns invalid output, or suggests content outside the current stage, continue with the base workflow and record only valid current-stage findings.

Expert modes are:

- `co-create`: current-stage options, risks, tradeoffs, section content, and decision framing.
- `generate-assets`: current-stage assets such as SVG wireframes, high-fidelity HTML, screenshots, logs, or test evidence.
- `review`: gate-stage critique and risk review.
- `external-adapter`: user-named external Skill / tool output converted to SoloSpec's current-stage structure.

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
`专家增强` must say whether the current-stage expert was available, used, skipped, unavailable, replaced by a user-named skill/tool, or not applicable. For mapped stages, it must name the mapped expert, the mode used when applicable, and the next choices; never summarize only that no expert was called.

Do not move to the next gated stage until the user confirms.

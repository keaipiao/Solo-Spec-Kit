# SoloSpec Architecture Contract

Use this reference to map architecture analysis, dependency review, root cause, ADR, and technical plan output into SoloSpec artifacts.

This file defines where architecture content may land. It does not grant write permission.

## 1. Stage Boundaries

| Branch / stage | Allow | Reject |
|---|---|---|
| new-project `architecture` | project stack, runtime, architecture boundaries, directories, modules, data flow, data model, APIs, dependencies, security rules, ADR candidates | implementation tasks, package edits, migrations, exhaustive optional-layer checklist |
| iteration `architecture` / `plan` | current spec implementation overview, impact scope, data/API changes, key decisions, risk, rollback, verification strategy | project-wide migration unless scope says so |
| bugfix `root-cause` | root cause, minimal fix strategy, impact scope, regression risk, root-cause gate | speculative rewrites, unrelated refactors, dependency upgrades without proof |
| adopt-existing `classify` | factual architecture baseline from existing code/docs, current stack, module boundaries, quality risks | moving files, normalizing structure, changing stack |

If exact framework, SDK, platform, security, API, pricing, version, or capability facts matter, require current official verification before writing a final conclusion.

## 2. Triggered Architecture Layers

Only include layers that are adopted, triggered, or decision-relevant.

| Trigger | Consider |
|---|---|
| login, roles, tenants, admin features | authentication and authorization |
| persistent business data | database, migrations, backup, retention |
| high-frequency reads, sessions, rate limits | cache |
| import/export, email, notifications, long jobs | queue or background jobs |
| full-text search, complex filtering, ranking | search layer |
| model calls, payments, maps, third-party services | external API layer, fallback, quotas |
| production operations | logging, metrics, tracing, deployment checks |
| sensitive data, uploaded files, multi-user boundaries | security, validation, privacy, audit |

Do not write untriggered layers as `不适用`. Important exclusions belong in `架构边界`.

## 3. Section Mapping

Paths are relative to `solo/`.

| Output | File | Section |
|---|---|---|
| project stack and runtime | `project/architecture.md` | 技术栈与运行环境 |
| architecture boundaries | `project/architecture.md` | 架构边界 |
| directory convention | `project/architecture.md` | 目录约定 |
| module boundaries | `project/architecture.md` | 模块边界 |
| data flow | `project/architecture.md` | 数据流 |
| data model | `project/architecture.md` | 数据模型 |
| project APIs | `project/architecture.md` | 接口约定 |
| external dependencies | `project/architecture.md` | 外部依赖 |
| security constraints | `project/architecture.md` | 安全和约束 |
| ADR index | `project/architecture.md` | ADR 索引 |
| iteration implementation overview | current spec `plan.md` | 实现概述 |
| iteration impact scope | current spec `plan.md` | 影响范围 |
| iteration data changes | current spec `plan.md` | 数据模型和迁移 |
| iteration API contract | current spec `plan.md` | 接口契约 |
| key decisions | current spec `plan.md` | 关键决策 |
| risk and rollback | current spec `plan.md` | 风险和回滚 |
| verification strategy | current spec `plan.md` | 验证策略 |
| plan gate | current spec `plan.md` | 计划门禁 |
| bug root cause | current bugfix spec `plan.md` | 根因 |
| bug fix strategy | current bugfix spec `plan.md` | 修复策略 |
| bug impact scope | current bugfix spec `plan.md` | 影响范围 |
| regression risk | current bugfix spec `plan.md` | 回归风险 |
| root cause gate | current bugfix spec `plan.md` | 根因门禁 |
| ADR status | `decisions/ADR-NNNN-title.md` | 状态 |
| ADR context | `decisions/ADR-NNNN-title.md` | 背景 |
| ADR decision | `decisions/ADR-NNNN-title.md` | 决策 |
| ADR rationale | `decisions/ADR-NNNN-title.md` | 理由 |
| ADR impact | `decisions/ADR-NNNN-title.md` | 影响 |
| ADR alternatives | `decisions/ADR-NNNN-title.md` | 备选方案 |
| ADR follow-up | `decisions/ADR-NNNN-title.md` | 后续动作 |

If the exact section is missing, use the closest existing section and explain the fit in `recommendation`.

## 4. ADR Rules

Suggest an ADR when a decision is cross-cutting, hard to reverse, dependency-heavy, security-sensitive, or affects future iterations.

ADR-worthy examples:

- framework or runtime choice
- auth and authorization model
- database or persistence strategy
- background job / queue strategy
- external API provider
- migration or compatibility strategy
- security and data isolation rule

Do not create an ADR for small implementation details that fit in the current spec `plan.md`.

## 5. Official Verification Rules

Use `risks` and `gate.question` when current official facts are required but not yet verified.

Only describe a fact as officially verified when the current run actually checked an official source. Do not write "officially verified", "official docs say", or source URLs as proof when the source was only recalled from memory or provided by the model. If the source is known but not verified in the current run, write it as a verification task or risk.

Require official verification for:

- exact framework or SDK version behavior
- security defaults and authentication behavior
- API limits, pricing, quotas, deprecations
- cloud/platform/runtime constraints
- migration tooling and compatibility
- database transaction, index, or locking behavior

Do not cite unofficial claims as final architecture facts.

## 6. Discard Rules

Discard these items instead of mapping them:

- implementation code, dependency edits, migrations, or config changes during architecture review
- product scope changes that belong to `solo-spec-product`
- UX or visual design that belongs to `solo-spec-ux`
- TDD task breakdown that belongs to TDD
- QA execution records that belong to QA
- broad rewrites hidden inside bugfix root cause
- unverified exact version/API/platform assertions
- untriggered optional architecture layers listed only as filler
- external process directories such as `.specify/`, `.openspec/`, `docs/architecture/`

Use short machine-readable discard reasons when possible:

```text
needs-official-verification
wrong-stage
implementation-leak
product-leak
ux-leak
tdd-leak
qa-leak
scope-creep
untriggered-layer
baseline-pollution
no-solo-target
```

## 7. Gate Advice

Set `gate.required` to `true` when:

- architecture changes project baseline
- dependency, security, data model, migration, or external API facts are unverified
- multiple architecture options have meaningful tradeoffs
- rollback is unclear
- root cause is not proven
- implementation would be unsafe without a plan decision

Set `gate.question` as one concise Chinese question. Do not mark the gate as passed.

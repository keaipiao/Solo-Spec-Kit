# SoloSpec Product Contract

Use this reference to map product discovery, brainstorming, research, scope, PRD, and proposal output into SoloSpec artifacts.

This file defines where product content may land. It does not grant write permission.

## 1. Stage Boundaries

| Branch / stage | Allow | Reject |
|---|---|---|
| new-project `brainstorm` | option generation in conversation, assumptions, research questions, tradeoffs | writing process notes to `project/` or creating `specs/` |
| new-project `scope` | confirmed target user, problem, scenario, MVP boundary, non-goals, constraints, success criteria | unconfirmed pivots, speculative features, future roadmap |
| new-project `prd` | confirmed goals, scope, user stories, key flow, success metrics, product risks | implementation plan, architecture, UI design, test tasks |
| iteration `brainstorm` | current-spec option pool, combinable ideas, rejected directions, research needs | changing project baseline or PRD before archive |
| iteration `scope` | accepted direction, current problem, iteration goal, boundary, acceptance boundary, dependencies and risks | expanding into project-wide redesign or unrelated features |
| iteration `spec` | product-level scenario and acceptance content for current spec | architecture decisions, UI details, TDD task list |
| adopt-existing `summarize-project` | factual product baseline from existing code/docs | inventing a new PRD or changing the existing product direction |

If product work depends on external facts, output a staged research need for the current stage only. Do not create a standalone `research.md`.

## 2. Section Mapping

Paths are relative to `solo/`.

| Output | File | Section |
|---|---|---|
| one-line project description | `project/brief.md` | 一句话说明 |
| target users and evidence | `project/brief.md` | 目标用户与依据 |
| core scenarios | `project/brief.md` | 核心场景 |
| MVP must-have scope | `project/brief.md` | 本阶段必须有 |
| MVP non-goals | `project/brief.md` | 本阶段明确不做 |
| project constraints | `project/brief.md` | 约束 |
| project success criteria | `project/brief.md` | 成功标准 |
| product problem | `project/prd.md` | 要解决的问题 |
| consequence of not solving | `project/prd.md` | 不解决会怎样 |
| urgency / why now | `project/prd.md` | 为什么现在做 |
| PRD in-scope | `project/prd.md` | In Scope |
| PRD non-goals | `project/prd.md` | Not In Scope |
| user stories | `project/prd.md` | 用户故事 |
| key product flow | `project/prd.md` | 关键流程 |
| success metrics | `project/prd.md` | 成功指标 |
| product risks | `project/prd.md` | 风险 |
| iteration raw request | current spec `brainstorm.md` | 用户原话 |
| iteration context understanding | current spec `brainstorm.md` | 上下文理解 |
| divergent questions | current spec `brainstorm.md` | 发散问题 |
| option pool | current spec `brainstorm.md` | 方案池 |
| combinable ideas | current spec `brainstorm.md` | 可组合点 |
| rejected directions | current spec `brainstorm.md` | 不建议方向 |
| ranking | current spec `brainstorm.md` | 推荐排序 |
| user choice | current spec `brainstorm.md` | 用户选择 |
| scope conclusion | current spec `brainstorm.md` | 进入 scope 的结论 |
| accepted direction | current spec `proposal.md` | 采纳方向 |
| current state | current spec `proposal.md` | 当前状态 |
| problem to solve | current spec `proposal.md` | 要解决的问题 |
| iteration goal | current spec `proposal.md` | 本次迭代目标 |
| iteration boundary | current spec `proposal.md` | 本次迭代边界 |
| acceptance boundary | current spec `proposal.md` | 验收边界 |
| dependencies and risks | current spec `proposal.md` | 依赖和风险 |
| gate confirmation | current spec `proposal.md` | 门禁确认 |
| executable product goal | current spec `spec.md` | 目标 |
| spec user stories | current spec `spec.md` | 用户故事 |
| scenarios | current spec `spec.md` | 场景 |
| acceptance criteria | current spec `spec.md` | 验收标准 |
| spec non-goals | current spec `spec.md` | 非目标 |
| product dependencies | current spec `spec.md` | 依赖 |
| open product questions | current spec `spec.md` | 开放问题 |

If the exact section is missing, use the closest existing section and explain the fit in `recommendation`.

## 3. Brainstorm Rules

Brainstorming means understanding the request, then deliberately expanding the solution space.

Good brainstorm output includes:

- 2 to 4 materially different options
- user fit, upside, cost, risk, and facts needing research for each option
- combinable parts
- directions not recommended and why
- a recommendation ranking
- a gate question that asks the user to choose, combine, or reject options

New-project brainstorm stays in conversation only. Write targets start at new-project `scope` after the user confirms a direction.

Iteration brainstorm may write to current `brainstorm.md` because the uncertainty is local to the current spec.

## 4. Staged Research Rules

Research is stage-specific:

- Product stages: users, pain points, frequency, severity, alternatives, willingness to change, market or workflow facts.
- UX stages: do not handle here; use `solo-spec-ux`.
- Architecture stages: do not handle here; use architecture expert.
- QA stages: do not handle here; use QA expert.

Output research as one of:

- `findings`: facts already known from provided context.
- `risks`: facts that remain unknown and affect direction.
- `writeTargets`: only when the target section exists for the current stage.
- `gate.question`: when a missing fact blocks scope or direction.

Never create a separate `research.md`.

## 5. Discard Rules

Discard these items instead of mapping them:

- unconfirmed pivot, target user, pricing, business model, or product category change
- implementation details presented as product requirements
- UI design details that belong to `solo-spec-ux`
- architecture or dependency decisions that belong to architecture
- TDD task breakdown or QA execution details
- future roadmap items outside the current project or iteration boundary
- external process directories such as `.specify/`, `.openspec/`, `docs/research/`, `research.md`
- broad scope expansion hidden inside a small iteration

Use short machine-readable discard reasons when possible:

```text
needs-user-confirmation
wrong-stage
implementation-leak
ux-leak
architecture-leak
tdd-leak
qa-leak
baseline-pollution
scope-creep
future-roadmap
no-solo-target
out-of-scope
```

## 6. Gate Advice

Set `gate.required` to `true` when:

- the product direction has multiple viable options
- target user, pain point, or scope is still ambiguous
- research facts could invalidate the direction
- the request would change project baseline
- the iteration scope is growing beyond the current spec
- acceptance criteria are too vague to become SDD/TDD input

Set `gate.question` as one concise Chinese question. Do not mark the gate as passed.

# SoloSpec Expert Roles

Use these as internal thinking modes. They do not write files directly.

Current status: v0.2 supports explicit enhancement. Do not call expert roles automatically from the base `solo-spec` workflow. Before a mapped stage reaches its user gate, the main flow must report the current-stage expert status. It must not enumerate every installed skill. Mention only the current-stage SoloSpec expert and any other skill/tool explicitly named by the user.

For mapped stages, a short summary like `未调用专家` is not enough. The main flow must name the mapped expert skill, report whether it is installed, state whether it was offered, used, skipped, unavailable, or replaced by a user-named tool, and show the allowed next choices inside the `专家增强` block. If the expert is installed, the choices are: call the expert, or skip expert review and confirm the current stage. If the expert is not installed, the choices are: skip expert review and confirm the current stage, or name another skill/tool for review.

Expert modules should be standalone sibling skills when they become complex, for example `$solo-spec-product`, `$solo-spec-ux`, `$solo-spec-architecture`, `$solo-spec-tdd`, `$solo-spec-qa`, and `$solo-spec-release`. The base `$solo-spec` skill remains the orchestrator.

If the mapped SoloSpec expert is available, offer to run it or skip it. If it is not available, say so and offer to continue without expert review or let the user name another skill/tool. User-named tools are external outputs and still must be converted by the main SoloSpec flow before writing.

Expert output must be converted by the main SoloSpec flow before writing:

- Reviewer: critique an existing SoloSpec artifact and propose gate findings.
- Advisor: suggest options, risks, tradeoffs, or section content for the current stage.
- Generator: produce raw assets such as mockups, screenshots, logs, or test evidence.

Use the packet shape defined in `docs/internal/04-expert-contract.md`: `expert`, `branch`, `stage`, `mode`, `summary`, `findings`, `recommendation`, `writeTargets`, `assets`, `discarded`, `gate`, and `risks`.

Discard any expert or external-skill output that creates its own directory structure, targets a future stage, bypasses a gate, or cannot be mapped to an existing SoloSpec file, section, or asset directory.

## Integration Rules

Use this order when consuming an expert packet:

1. Validate packet shape.
2. Validate `branch` and `stage` against `solo/state.json`.
3. Validate every `writeTargets.file` is under the allowed `solo/` target set.
4. Validate every `writeTargets.section` exists in the target template or current artifact.
5. Validate every asset target is under the current project or spec asset directory.
6. Move invalid, broad, future-stage, or unverified content to `discarded` or stage risks.
7. Give only valid current-stage suggestions to the Artifact Writer.
8. Apply the normal SoloSpec gate; an expert cannot mark a gate passed.

Allowed targets are current-stage files only:

- Project stages: `project/*.md`, ADRs, and project assets.
- Iteration stages: current `specs/NNN-*/brainstorm.md`, `proposal.md`, `spec.md`, `design.md`, `plan.md`, `tasks.md`, `qa.md`, `archive.md`, and current spec assets.
- Bugfix stages: current bugfix `proposal.md`, `plan.md`, `tasks.md`, `qa.md`, `archive.md`, and current bugfix assets.
- Managed blocks: only after the workflow reaches the confirmed managed-block stage.

If a specialist review may take time, use external research, generate assets, change the stage conclusion, or affect a project baseline, explain that impact in the offer before using it.

Suggested stage mapping:

| Stage | Optional expert | Use for |
|---|---|---|
| `brainstorm` / `scope` | `solo-spec-product` | options, pain points, MVP boundary |
| `ux` / `design` | `solo-spec-ux` | flows, states, visual assets, design risks |
| `architecture` / `plan` / `root-cause` | `solo-spec-architecture` | triggered layers, ADRs, data flow, rollback |
| `tdd-plan` / `regression-test` | `solo-spec-tdd` | red tests, task sequence, regression checks |
| `qa` / `verify` | `solo-spec-qa` | evidence, screenshots, logs, real verification |
| `archive` / `write-managed-blocks` | `solo-spec-release` | archive summary, baseline promotion, managed blocks |

Mapping rules:

- Unconfirmed product pivots never update project baselines. In new-project brainstorm, keep them in conversation only; in iteration brainstorm, write only to the current `brainstorm.md`.
- External assets must be copied into SoloSpec assets before use. Use kebab-case names like `taste-dashboard-overview-01.png`, then register the source, purpose, page or state, and batch in `design-system.md`, `design.md`, or `qa.md`.
- Cross-stage suggestions stay advisory. In bugfix `regression-test`, keep regression tests and minimal fix candidates in `tasks.md` or `qa.md`, but discard framework migrations, full rewrites, and `.specify/` or other self-owned directories unless the user changes the branch to an iteration or architecture decision.

## router

Trigger: `intake`.

Responsibilities:

- Identify branch: `new-project`, `iteration`, `bugfix`, or `adopt-existing`.
- Detect whether an existing `solo/` exists.
- Decide whether the request should resume from `solo/state.json`.

Gate: stop when branch is unclear.

## founder-review

Trigger: `brainstorm` and `scope`.

Responsibilities:

- In `brainstorm`, generate multiple options after understanding the user request.
- For each option, state fit, upside, cost, risk, and facts needing research.
- Identify combinable ideas and directions not recommended.
- In `scope`, converge the user-selected option into boundaries.

Gate: user must choose, combine, or reject options before scope completes.

## staged-research

Trigger: whenever the current stage depends on external facts.

Responsibilities:

- Product stage: users, pain points, competitors, alternatives.
- UX stage: interaction patterns, visual references, state handling.
- Architecture stage: official API, SDK, versions, compatibility.
- Existing-project adoption: inventory current code and docs.

Gate: facts affecting direction, architecture, or dependencies must be verified.

## prd

Trigger: `prd`, `summarize-project`.

Responsibilities:

- In new projects, write goals, scope, non-goals, and success metrics.
- In existing-project adoption, summarize the current project baseline; do not create `project/prd.md` by default.
- Structure user stories and core flows.
- Avoid turning implementation details into product requirements.

## ux-design

Trigger: `ux`, `design`.

Responsibilities:

- Define user flow, information architecture, pages and components.
- Decide wireframe, high-fidelity, or generated reference route.
- Cover loading, empty, error, unauthorized, and mobile states.
- Register generator artifacts.
- Review for generic AI-looking UI.

## architecture

Trigger: `architecture`, `root-cause`, `classify`.

Responsibilities:

- Define module boundaries, data flow, APIs, data models.
- Verify technical facts from official sources when needed.
- Record ADRs for cross-cutting decisions.
- In bugfix, find root cause before implementation.

## spec

Trigger: `spec`, `propose-adoption-plan`.

Responsibilities:

- Convert confirmed requirements into executable specs.
- Write scenarios, acceptance criteria, non-goals, dependencies.
- Keep proposal, spec, design, and plan boundaries clear.
- In existing-project adoption, write follow-up iteration suggestions into `solo/project/brief.md`; do not create a specs directory.

## tdd

Trigger: `tdd-plan`, `implementation`, `regression-test`, `fix`.

Responsibilities:

- Define red tests first.
- Keep tasks small and executable.
- Implement the minimum code to pass.
- Record commands and results.

## qa

Trigger: `qa`, `reproduce`, `verify`.

Responsibilities:

- Reproduce bugs.
- Run unit, integration, browser, or API checks as appropriate.
- Capture screenshots or logs when useful.
- Record verification evidence.

## archive

Trigger: `ship/archive`, `archive`, `write-managed-blocks`.

Responsibilities:

- Summarize shipped changes.
- Update project quality baselines when testing or QA rules changed.
- Record pitfalls and follow-ups.
- Update managed blocks after confirmation.
- Update `state.json`.

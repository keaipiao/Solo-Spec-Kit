# SoloSpec Workflow

## New Project

```text
intake
→ brainstorm
→ scope
→ research
→ prd
→ ux
→ architecture
→ create-mvp-spec
→ spec
→ design
→ plan
→ tdd-plan
→ implementation
→ qa
→ ship/archive
```

Rules:

- `brainstorm` produces options in the conversation and writes no process file for new projects.
- `scope` writes `solo/project/brief.md`.
- `research` writes stage-specific verified facts into `brief.md`, `prd.md`, `ux.md`, `design-system.md`, `architecture.md`, or ADRs. Do not create a standalone research directory.
- `prd` writes `solo/project/prd.md`.
- `ux` writes `solo/project/ux.md` and `solo/project/design-system.md`.
- `architecture` writes `solo/project/architecture.md` and ADRs when needed.
- `create-mvp-spec` creates `solo/specs/001-mvp/` and asset subdirectories.
- `spec` writes `solo/specs/001-mvp/spec.md`.
- `design` writes `solo/specs/001-mvp/design.md`.
- `plan` writes `solo/specs/001-mvp/plan.md`.
- `project/` stores confirmed project conclusions only; it does not store brainstorm process records.
- `implementation` may create a minimal app scaffold when none exists, but only within the adopted architecture and current plan.
- `qa` writes execution records, screenshots/logs, discovered bugs, fixes, and regression evidence.
- `ship/archive` writes `archive.md` and updates project `release.md`, `quality.md`, or `pitfalls.md` only when the completed MVP changes those baselines.

## Iteration

```text
intake
→ read-context
→ brainstorm
→ scope
→ research
→ spec
→ design
→ architecture
→ tdd-plan
→ implementation
→ qa
→ archive
```

Rules:

- Read `solo/project/`, `solo/state.json`, relevant `solo/specs/*`, and relevant code before writing.
- Create `solo/specs/NNN-kebab-case-name/`.
- `brainstorm` writes `brainstorm.md`.
- `scope` writes `proposal.md`.
- `research` writes only facts needed by the current iteration into the current stage artifact.
- `spec` writes `spec.md`.
- `design` writes `design.md` and iteration assets when UI exists.
- `architecture` writes `plan.md` and ADRs when needed.
- `tdd-plan` writes `tasks.md` and test plan content in `qa.md`.
- `implementation` follows `tasks.md`, records actual commands and changed files, and can create only the minimal missing scaffold required by the plan.
- `qa` verifies real behavior, records evidence in `qa.md`, and closes bugs in the current spec before archive.

## Bugfix

```text
intake
→ reproduce
→ root-cause
→ regression-test
→ fix
→ verify
→ archive
```

Rules:

- No reproduction, no fix.
- No root cause, no fix.
- Write or identify a regression test before implementation.
- Current-iteration bugs update current `qa.md`, `tasks.md`, and `archive.md`.
- New-session bugs first try to attach to a related iteration.
- If the bug cannot be attached or spans multiple iterations, create `solo/specs/NNN-bugfix-title/`.

## Implementation And QA Rules

- Do not skip tests in implementation. If no test tool exists, create the smallest test runner compatible with the accepted architecture.
- Implementation follows red-green tasks, records actual commands, and updates the current spec when implementation deviates from the accepted plan.
- For time-dependent behavior, use controllable time or explicit state-advance functions in tests; use real waiting only as supplemental QA.
- QA-discovered bugs stay in the current spec: update `qa.md`, add regression coverage, fix minimally, rerun tests, then update `tasks.md`.
- QA evidence is not only UI evidence. Backend, CLI, data migration, and integration work must record the matching command, API result, log, or artifact.
- Archive promotes only reusable lessons or changed baselines to `project/pitfalls.md`, `project/quality.md`, or `project/release.md`.

## All-Stage First-Class Rules

Every stage is a first-class stage. Do not over-invest in UX while treating product, research, architecture, TDD, implementation, QA, or release as checklist items.

Each stage must include:

- current-stage expert status when mapped;
- explicit artifact target;
- non-goals or current-stage exclusions;
- evidence or source discipline for factual claims;
- a gate question the user can answer;
- how the next stage will verify this stage's conclusion.

## Adopt Existing

```text
intake
→ inventory
→ classify
→ summarize-project
→ propose-adoption-plan
→ user-confirm
→ write-managed-blocks
```

Rules:

- Default to read-only inspection of existing code and docs.
- Do not move, rename, format, or refactor existing business files.
- `intake` creates the base `solo/` directories, `solo/state.json`, and `solo/config.json`.
- Generate only `solo/project/brief.md`, `architecture.md`, `quality.md`, and `pitfalls.md` by default.
- Write adoption suggestions into the follow-up recommendations section of `solo/project/brief.md`; do not create free-form extra docs.
- Write managed blocks to external files only after user confirmation.

## Gates

Hard gates:

- branch confirmation
- brainstorm options and user selection
- scope boundary
- PRD range
- UI direction when UI exists
- architecture and external dependency decisions
- executable spec
- TDD task plan
- QA result
- release/archive

Only explicit approval passes a gate.

After approval, update the approved stage artifact before moving on:

- Replace waiting language with confirmed language.
- Preserve the confirmed scope, option, copy, architecture decision, task plan, or QA result.
- Update `solo/state.json.gate.status` to `passed` or the next active gate.
- If the workflow has no next gate, set `solo/state.json.gate.requires` to `none`; do not keep the completed gate slug.
- Do not leave completed artifacts saying they are still waiting for user confirmation.

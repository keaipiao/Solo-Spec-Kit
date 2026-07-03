# SoloSpec Artifacts

## Directory

```text
solo/
├── state.json
├── config.json
├── project/
│   ├── brief.md
│   ├── prd.md
│   ├── ux.md
│   ├── design-system.md
│   ├── architecture.md
│   ├── quality.md
│   ├── release.md
│   ├── pitfalls.md
│   └── assets/
├── specs/
│   ├── NNN-iteration-name/
│   │   ├── brainstorm.md  # iteration pre-SDD only
│   │   ├── proposal.md    # iteration pre-SDD only
│   │   ├── spec.md
│   │   ├── design.md
│   │   ├── plan.md
│   │   ├── tasks.md
│   │   ├── qa.md
│   │   ├── archive.md
│   │   └── assets/
│   └── NNN-bugfix-title/
│       ├── proposal.md
│       ├── plan.md
│       ├── tasks.md
│       ├── qa.md
│       ├── archive.md
│       └── assets/
├── decisions/
└── archive/
```

## Project Files

| File | Purpose |
|---|---|
| `brief.md` | Accepted direction, target users, scenarios, MVP boundary |
| `prd.md` | Product requirements, scope, non-goals, success metrics |
| `ux.md` | Global user flows, IA, page map |
| `design-system.md` | Design language, tokens, components, copy rules |
| `architecture.md` | Stack, modules, data flow, dependencies |
| `quality.md` | Test strategy, QA matrix, safety, performance |
| `release.md` | Release, deployment, rollback, version rules |
| `pitfalls.md` | Reusable pitfalls and lessons |

## Spec Files

Create Markdown files only when their stage starts. New-project `specs/001-mvp/` starts from shared SDD/TDD files and must not create `brainstorm.md` or `proposal.md`.

| File | Purpose |
|---|---|
| `brainstorm.md` | Iteration option pool and user choice; not used for new-project MVP |
| `proposal.md` | Iteration converged proposal: why, what, not, value, boundary; not used for new-project MVP |
| `spec.md` | User stories, scenarios, acceptance criteria, non-goals |
| `design.md` | UX/UI, states, data flow, interaction boundary |
| `plan.md` | Technical plan, impacted files, risks, rollback |
| `tasks.md` | TDD tasks, red tests, minimal implementation, commands |
| `qa.md` | Test plan, QA execution records, browser/API evidence, screenshots |
| `archive.md` | Completion summary, changes, leftovers, follow-ups |

Bugfix specs use `proposal.md`, `plan.md`, `tasks.md`, `qa.md`, and `archive.md` only by default. Do not create `brainstorm.md`, `spec.md`, or `design.md` for a bugfix unless the fix has become a product iteration.

## Asset Rules

- Project-level assets go under `solo/project/assets/`.
- Iteration-specific wireframes, mockups, screenshots, and references go under `solo/specs/NNN-name/assets/`.
- Project-level UI generator output goes under `project/assets/global-mockups/` and is registered in `project/design-system.md`.
- Spec-level UI generator output goes under current spec `assets/mockups/` and is registered in `design.md`.
- QA screenshots must be stored under current spec `assets/screenshots/` and registered in `qa.md`.

## Architecture Artifacts

Architecture templates define the minimum shape, not a fixed technology list.

When writing `architecture.md` or `plan.md`, infer and add needed layers from requirements:

| Trigger | Add layers |
|---|---|
| Login, roles, permissions, tenants | authentication, authorization, security rules |
| Persistent business data | database, migration, backup |
| High-frequency reads, sessions, limits | cache |
| Email, import/export, long-running jobs | queue, scheduler, background worker |
| Full-text search or complex filtering | search/indexing |
| Model calls or third-party systems | external API/SDK, retry, fallback |
| Production operation | logging, metrics, tracing, audit |

Do not wait for the user to ask for these layers when the requirement already implies them.

Use the trigger table as an internal checklist only. Do not copy it into `architecture.md`. In the technology stack table, include only layers actually adopted or requiring an explicit decision; put important exclusions in architecture boundaries instead of listing every untriggered layer as not applicable.

## External Files

External files may contain managed blocks only:

- `AGENTS.md`
- `CLAUDE.md`
- `README.md`
- `CHANGELOG.md`

They are not the source of truth. Removing `solo/` and managed blocks must leave the project usable.

## State

`solo/state.json` records only process state:

- `branch`
- `currentSpec`
- `currentStage`
- `gate.status`
- `gate.requires`
- `lastAction`
- `updatedAt`

Full requirements and decisions must be in Markdown artifacts.

State write rules:

- Update `solo/state.json` through a JSON parser or serializer.
- Do not hand-build JSON strings or paste unescaped user-facing text into JSON.
- Keep long user-facing explanations in Markdown artifacts; `state.json` should store short process summaries and artifact paths.
- Prefer ASCII slugs for `gate.requires` such as `confirm_branch_and_goal`, `confirm_architecture`, or `confirm_qa_result`; put the Chinese explanation in the stage artifact and completion message.
- When `gate.status` is `passed` and no next gate exists, `gate.requires` must be `none`.
- After every update, parse `solo/state.json` successfully before completing the stage.
- If state validation fails, fix `state.json` immediately and do not advance the workflow.

## Template Use

Do not copy the entire template tree at intake. Create directories first, then instantiate each Markdown template only when its stage starts.

Initial scaffold:

```text
solo/state.json
solo/config.json
solo/project/assets/
solo/specs/
solo/decisions/
solo/archive/
```

For `new-project`, create `solo/specs/001-mvp/assets/` only after project-level architecture is confirmed.

Stage instantiation:

| Stage | Copy or create |
|---|---|
| new-project `brainstorm` | no process file; confirmed facts are carried into the next gated project document |
| new-project `scope` | `project/brief.md` |
| new-project `prd` | `project/prd.md` |
| new-project `ux` | `project/ux.md`, `project/design-system.md` |
| new-project `architecture` | `project/architecture.md`, ADR when needed |
| `create-mvp-spec` | `specs/001-mvp/assets/` |
| SDD `spec` | current iteration `spec.md` |
| SDD `design` | current iteration `design.md` |
| SDD `plan` | current iteration `plan.md` |
| `tdd-plan` | current iteration `tasks.md`, `qa.md` test plan sections |
| `qa` | current iteration `qa.md` verification sections |
| `archive` | current iteration `archive.md`, project release, quality, or pitfalls when needed |
| bugfix `reproduce` | current bugfix `proposal.md` |
| bugfix `root-cause` | current bugfix `plan.md` |
| bugfix `regression-test` | current bugfix `tasks.md`, `qa.md` test plan sections |
| bugfix `verify` | current bugfix `qa.md` verification sections |
| bugfix `archive` | current bugfix `archive.md`, project quality or pitfalls when needed |
| adopt-existing `intake` | base `solo/` directories, `state.json`, `config.json` |
| adopt-existing `inventory` | `project/brief.md` draft |
| adopt-existing `classify` | `project/architecture.md`, `project/quality.md` |
| adopt-existing `summarize-project` | `project/brief.md`, `project/pitfalls.md` |
| adopt-existing `propose-adoption-plan` | `project/brief.md` follow-up recommendations |
| adopt-existing `write-managed-blocks` | confirmed managed blocks only |

## Stage Write Boundaries

| Artifact | Stage | Write only |
|---|---|---|
| `qa.md` | `tdd-plan` | test plan, QA scenarios, screenshot/log plan |
| `qa.md` | `qa` | execution records, evidence paths, discovered and fixed issues |
| `tasks.md` | `tdd-plan` | red tests, minimal implementation scope, commands |
| `tasks.md` | `implementation` / `qa` | actual completion records, bug fix records, regression verification |
| `archive.md` | `archive` | completion summary, changed files, verification summary, project-document updates, follow-ups |

Do not write fake QA results during `tdd-plan`. Use “QA 执行记录” sections and fill them only during `qa`.

If implementation creates a minimal scaffold because the project has none, record the new scripts, commands, entry points, and test runner in `tasks.md`.

Keep not-applicable sections and write `不适用` with a reason after the file is instantiated.

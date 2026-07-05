# SoloSpec TDD Contract

Use this reference to map TDD task planning, regression coverage, and external TDD advice into SoloSpec artifacts.

This file defines where TDD content may land. It does not grant write permission.

## 1. Stage Boundaries

| Branch / stage | Allow | Reject |
|---|---|---|
| new-project `tdd-plan` | MVP spec tasks, red tests, expected failure, minimal implementation scope, commands, regression plan | implementation code, task completion records, QA execution results |
| iteration `tdd-plan` | current spec tasks, order, dependencies, test plan, command gaps, regression risk | project-wide refactor tasks outside current spec |
| iteration `implementation` | advisory review of whether current task follows red-green-minimal scope | rewriting task plan without gate, marking tasks complete without execution evidence |
| bugfix `regression-test` | regression test plan, expected failing behavior, fix scope candidate, verification command | fixing before reproduction/root cause/test method |
| bugfix `fix` | minimal implementation scope tied to confirmed root cause and regression coverage | unrelated refactors, broad rewrites, new features |

QA execution records belong to QA expert. TDD may write test plans and expected commands, not actual pass/fail results unless execution evidence is provided by the main workflow.

## 2. Section Mapping

Paths are relative to `solo/`.

| Output | File | Section |
|---|---|---|
| iteration task order | current spec `tasks.md` | 执行顺序 |
| iteration task detail | current spec `tasks.md` | 任务详情 |
| iteration TDD gate | current spec `tasks.md` | TDD 门禁 |
| iteration unit test plan | current spec `qa.md` | 单元测试 |
| iteration integration test plan | current spec `qa.md` | 集成测试 |
| iteration UI/API QA plan | current spec `qa.md` | UI / API QA |
| iteration out-of-test scope | current spec `qa.md` | 不测范围 |
| bugfix task list | current bugfix spec `tasks.md` | 任务清单 |
| bugfix task detail | current bugfix spec `tasks.md` | T001 |
| bugfix regression gate | current bugfix spec `tasks.md` | 回归测试门禁 |
| bugfix completion record | current bugfix spec `tasks.md` | 实施完成记录 |
| bugfix test plan | current bugfix spec `qa.md` | 测试计划 |
| bugfix discovered issue record | current bugfix spec `qa.md` | 发现并修复的问题 |
| bugfix QA gate | current bugfix spec `qa.md` | QA 门禁 |

If the exact section is missing, use the closest existing section and explain the fit in `recommendation`.

## 3. TDD Task Rules

Each task must include:

- task id, preferably `T001`, `T002`, ...
- behavior to verify
- affected files or modules when known
- red test intent
- command to run the red test
- expected failure reason
- minimal green implementation scope
- command to confirm pass
- regression command or method
- dependencies on earlier tasks

Reject tasks that only say:

- implement API
- add tests
- build page
- finish feature
- refactor module

Split broad tasks until each one can fail and pass independently.

## 4. Bugfix Regression Rules

For bugfix, do not proceed unless there is:

- reproduction or clear failing symptom
- root-cause hypothesis or confirmed root cause from plan
- regression test or explicit manual/API/browser test method
- expected failure before fix
- minimal fix scope tied to root cause

If any part is missing, set `gate.required: true`.

## 5. Command Rules

Prefer concrete commands from repository context.

If commands are unknown:

- do not invent exact package-manager commands as facts
- write the command gap into `risks`
- target the correct section with command intent only when the template needs a plan, without pretending the exact command is known or executed

Time-based behavior such as timers, retries, expiry, polling, queues, or progress must include controllable-time or state-advance tests where feasible.

## 6. Discard Rules

Discard these items instead of mapping them:

- implementation code, dependency edits, migrations, or config changes during TDD planning
- product scope changes that belong to `solo-spec-product`
- UX or visual behavior that belongs to `solo-spec-ux`
- architecture decisions that belong to `solo-spec-architecture`
- QA execution results without evidence
- tasks that skip red tests
- broad refactors hidden inside bugfix
- external process directories such as `.specify/`, `.openspec/`, `docs/tests/`
- completion claims without executed command evidence

Use short machine-readable discard reasons when possible:

```text
wrong-stage
implementation-leak
product-leak
ux-leak
architecture-leak
qa-leak
missing-red-test
missing-regression-test
task-too-broad
scope-creep
no-command-evidence
no-solo-target
```

## 7. Gate Advice

Set `gate.required` to `true` when:

- any task lacks red test intent
- commands are unknown and block planning
- a bugfix lacks reproduction, root cause, or regression test method
- tasks are too broad to verify independently
- TDD plan introduces unconfirmed product, UX, or architecture changes
- user must approve task order before implementation

Set `gate.question` as one concise Chinese question. Do not mark the gate as passed.

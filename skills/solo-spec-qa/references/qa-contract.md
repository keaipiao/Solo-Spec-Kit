# SoloSpec QA Contract

Use this reference to map QA execution, browser/API/manual verification, screenshots, logs, discovered issues, and external QA reports into SoloSpec artifacts.

This file defines where QA content may land. It does not grant write permission or test execution permission.

## 1. Stage Boundaries

| Branch / stage | Allow | Reject |
|---|---|---|
| new-project `qa` | QA execution records for MVP, screenshots/logs, discovered issues, not-tested scope, QA gate advice | implementation fixes, new TDD task design without evidence |
| iteration `qa` | current spec QA evidence, browser/API/manual verification, screenshots/logs, discovered issues and regression notes | creating a separate bugfix spec for issues found in current QA by default |
| bugfix `reproduce` | reproduction evidence, failing command, screenshot/log, observed symptom | root-cause claims without evidence, fix implementation |
| bugfix `verify` | regression verification, before/after evidence, fixed issue record, QA gate advice | unrelated QA expansion, broad refactors |
| archive | QA summary and evidence references for archive handoff | new testing claims without execution evidence |

QA execution requires actual evidence. Planned tests without results belong to TDD or QA plan sections, not execution records.

## 2. Section Mapping

Paths are relative to `solo/`.

| Output | File | Section |
|---|---|---|
| iteration QA plan | current spec `qa.md` | 测试计划 |
| iteration unit plan | current spec `qa.md` | 单元测试 |
| iteration integration plan | current spec `qa.md` | 集成测试 |
| iteration UI/API plan | current spec `qa.md` | UI / API QA |
| iteration execution record | current spec `qa.md` | QA 执行记录 |
| iteration screenshots/logs | current spec `qa.md` | 截图和日志 |
| iteration discovered issues | current spec `qa.md` | 发现并修复的问题 |
| iteration not-tested scope | current spec `qa.md` | 不测范围 |
| iteration QA gate | current spec `qa.md` | QA 门禁 |
| bugfix QA plan | current bugfix spec `qa.md` | 测试计划 |
| bugfix execution record | current bugfix spec `qa.md` | QA 执行记录 |
| bugfix discovered issues | current bugfix spec `qa.md` | 发现并修复的问题 |
| bugfix QA gate | current bugfix spec `qa.md` | QA 门禁 |
| iteration archive QA summary | current spec `archive.md` | 验证记录 |
| bugfix archive QA summary | current bugfix spec `archive.md` | QA 记录 |

If the exact section is missing, use the closest existing section and explain the fit in `recommendation`.

## 3. Evidence Rules

Execution records must include:

- command or method
- result
- evidence path or copied output summary
- failure details when failed
- environment or URL when relevant

Screenshots and logs must be registered as assets:

| Evidence | Target directory | Register in |
|---|---|---|
| UI screenshot | current spec `assets/screenshots/` | current spec `qa.md` |
| console/network log | current spec `assets/logs/` | current spec `qa.md` |
| API response sample | current spec `assets/logs/` | current spec `qa.md` |
| external QA report reference | current spec `assets/references/` | current spec `qa.md` |

Use English kebab-case file names:

```text
source-purpose-variant.ext
source-purpose-variant-01.ext
```

Examples:

- `browser-dashboard-mobile-01.png`
- `api-export-pdf-failure-01.log`
- `playwright-console-errors-01.txt`

Do not invent evidence. If evidence is missing, set a risk or gate question.

## 4. Bug Handling Rules

When QA finds a bug during the current implementation:

- keep it in the current spec by default
- write the issue, root cause if known, fix summary if already fixed, and regression test into `发现并修复的问题`
- update QA gate as not passed until verification evidence exists
- do not create a new bugfix spec unless the user raises a separate bug or the issue cannot attach to the current spec

Bugfix verification must include reproduction evidence or failing symptom and after-fix regression evidence.

## 5. Discard Rules

Discard these items instead of mapping them:

- planned tests presented as executed results
- pass claims without command/method/evidence
- screenshots/logs without inspectable source path
- implementation fixes, test code, migrations, or dependency edits
- TDD task design that belongs to `solo-spec-tdd`
- product, UX, or architecture changes outside QA evidence
- external final directories such as `docs/assets/`, `qa-reports/`, `playwright-report/`, `coverage/`
- unrelated bugs raised during current QA that need a separate user-confirmed bugfix branch

Use short machine-readable discard reasons when possible:

```text
no-evidence
planned-not-executed
uninspectable-asset
implementation-leak
tdd-leak
product-leak
ux-leak
architecture-leak
wrong-stage
separate-bugfix-needed
no-solo-target
```

## 6. Gate Advice

Set `gate.required` to `true` when:

- any required QA evidence is missing
- a test failed
- console/network/API errors are present
- QA found a bug not yet fixed and reverified
- not-tested scope materially affects release confidence
- the user must approve residual risk

Set `gate.question` as one concise Chinese question. Do not mark the gate as passed.

When no blocking QA issue remains, `gate.required` may be `false`, but do not say or imply that the SoloSpec QA gate is passed. Phrase the recommendation as "main workflow can record the evidence and ask for stage confirmation" rather than "QA passed".

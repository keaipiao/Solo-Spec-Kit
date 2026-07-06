# SoloSpec UX Contract

Use this reference to map UX, design-system, and external design outputs into SoloSpec artifacts.

This file defines where UX content may land. It does not grant write permission.

## 1. Stage Boundaries

| Branch / stage | Allow | Reject |
|---|---|---|
| new-project `ux` | project-level user flows, information architecture, page map, design direction, global states, theme candidates confirmed by the user | implementation tasks, code changes, spec-level page details, unconfirmed project baseline changes |
| new-project `design` after `001-mvp` exists | MVP-specific UI states, page flow details, screen inventory, adopted design assets | changing project theme, brand, or IA without explicit user confirmation |
| iteration `design` | current spec page/component changes, states, wireframes, mockups, visual references, UI copy, UX risks | project-wide redesign unless the iteration scope explicitly includes it |
| bugfix `verify` / `qa` | screenshots, visual regression evidence, reproduction evidence, before/after notes | redesign proposals unless the bug becomes an iteration |
| adopt-existing | baseline observations, current UI inventory, risks, follow-up recommendations | moving, rewriting, or reorganizing existing UI files |

If the current stage cannot accept a useful design idea, put it in `discarded` with the reason `wrong-stage` or `needs-user-confirmation`.

## 2. Section Mapping

Paths are relative to `solo/`.

| Output | File | Section |
|---|---|---|
| project user flow | `project/ux.md` | 用户流 |
| project core path | `project/ux.md` | 核心路径 |
| project exception path | `project/ux.md` | 异常路径 |
| information architecture | `project/ux.md` | 信息架构 |
| page map | `project/ux.md` | 页面地图 |
| global states | `project/ux.md` | 全局状态规则 |
| global UI copy principles | `project/ux.md` | 全局文案原则 |
| design language | `project/design-system.md` | 设计语言 |
| theme colors / tokens | `project/design-system.md` | 色彩 |
| typography | `project/design-system.md` | 字体 |
| spacing / radius / density | `project/design-system.md` | 间距和圆角 |
| component principles | `project/design-system.md` | 组件规则 |
| project-level visual references | `project/design-system.md` | 图标和素材 |
| accessibility | `project/design-system.md` | 可访问性 |
| iteration UX goal | current spec `design.md` | UX 目标 |
| page/component list | current spec `design.md` | 页面 / 组件清单 |
| user flow diagram | current spec `design.md` | 用户流 |
| wireframe / mockup / reference | current spec `design.md` | 设计产物 |
| state handling | current spec `design.md` | 状态规划 |
| UI copy | current spec `design.md` | 文案 |
| project-level design impact from an iteration | current spec `design.md` | 项目级设计影响 |
| QA screenshot | current spec `qa.md` | QA 执行记录 |
| QA screenshot/log asset | current spec `qa.md` | 截图和日志 |
| archive summary for adopted design changes | current spec `archive.md` | 项目级文档更新记录 |

If the exact section is missing, use the closest existing section and explain the fit in `recommendation`.

## 3. Asset Rules

External generated output is not adopted until it is mapped to a SoloSpec asset path and registration target.

| Asset | Target directory | Register in |
|---|---|---|
| project-level visual reference | `project/assets/references/` | `project/design-system.md` |
| project-level brand asset | `project/assets/brand/` | `project/design-system.md` |
| spec wireframe | current spec `assets/wireframes/` | current spec `design.md` |
| spec high-fidelity mockup | current spec `assets/mockups/` | current spec `design.md` |
| spec visual reference | current spec `assets/references/` | current spec `design.md` |
| QA screenshot | current spec `assets/screenshots/` | current spec `qa.md` |

Use English kebab-case file names:

```text
source-purpose-variant.ext
source-purpose-variant-01.ext
```

Examples:

- `taste-dashboard-reference-01.html`
- `stitch-onboarding-empty-state-01.html`
- `gstack-mobile-overlap-regression-01.png`

Each asset registration must include:

- original source
- target path
- purpose
- applicable page, component, or state
- batch, version, or capture time when available

## 4. Design Quality Checklist

Apply these checks before recommending adoption:

| Dimension | Check |
|---|---|
| User goal | The design serves a concrete user task and scenario. |
| Flow | Entry, primary path, escape path, and completion are clear. |
| States | Loading, empty, error, success, unauthorized, destructive, mobile, and responsive states are covered when relevant. |
| IA | Navigation, grouping, hierarchy, labels, and scanning path are coherent. |
| Interaction | Feedback, confirmation, undo, validation, keyboard, and touch behavior are explicit. |
| Visual system | Color, typography, spacing, density, icon style, and motion form a coherent baseline. |
| Accessibility | Semantics, focus, contrast, readable copy, and reduced motion are considered. |
| Evidence | Assets are inspectable, named, mapped, and registered. |
| Stage fit | The output belongs to the current branch/stage and does not jump into implementation. |

Do not accept “looks good” as a finding. Convert it into specific adopted items, risks, or discarded items.

## 5. External Skill Adaptation

Treat external design tools as sources, not owners of SoloSpec structure.

| Source type | Mode | Handling |
|---|---|---|
| taste-style generated mockup | `external-adapter` -> `generate-assets` | Map HTML to `project/assets/references/` or current spec `assets/mockups/`; register it in `design-system.md` or `design.md`. |
| design review report | `external-adapter` -> `review` | Convert issues into `machine.findings`, `machine.recommendation`, and possible `machine.gate` question. |
| wireframe or screenshot | `external-adapter` -> `generate-assets` | Map to current spec assets and register in `design.md` or `qa.md`. |
| UI implementation instructions | `external-adapter` -> `co-create` | Keep as design intent unless the current `solo-spec` stage is implementation. |
| broad rebrand suggestion | `external-adapter` -> `co-create` | Requires explicit user confirmation; usually belongs to project `design-system.md`, not one spec. |

## 6. Discard Rules

Discard these items instead of mapping them:

- output targeting `design-assets/`, `docs/design/`, `docs/assets/`, `figma/`, `.specify/`, `.openspec/`, or any external tool directory
- code, CSS, route, component, dependency, or test changes during UX/design stages
- unconfirmed theme, brand, IA, page model, or layout changes that would alter project baseline
- design output without inspectable asset path or registration target
- generic visual advice that cannot be tied to a SoloSpec section
- future-stage content that would pollute current project baseline
- project-wide redesign hidden inside a bugfix or small iteration

Use short machine-readable discard reasons when possible:

```text
wrong-stage
needs-user-confirmation
no-solo-target
implementation-leak
uninspectable-asset
baseline-pollution
scope-creep
out-of-scope
```

## 7. Gate Advice

Set `gate.required` to `true` when:

- theme, brand, IA, or navigation changes affect project baseline
- UX direction has multiple viable options with meaningful tradeoffs
- a generated design asset is good enough to adopt but needs user confirmation
- an accessibility, mobile, or state gap blocks implementation quality
- current-stage output conflicts with existing project baseline

Set `gate.question` as one concise Chinese question. Do not mark the gate as passed.

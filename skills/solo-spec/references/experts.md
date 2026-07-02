# SoloSpec Expert Roles

Use these as internal thinking modes. They do not write files directly.

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

- Write goals, scope, non-goals, success metrics.
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

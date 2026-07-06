# SoloSpec 用户项目目录规范

## 1. 设计原则

SoloSpec 的最终分发形态是接入用户已有或新建项目。

目录设计必须同时满足：

- 深度接入：AI、README、CHANGELOG、项目文档知道 SoloSpec 的存在。
- 可插拔：完整事实源只在 `solo/`，删除成本低。
- 不污染：不默认改动用户现有 `docs/`、`specs/`、业务源码目录。
- 可恢复：新会话可通过 `solo/state.json` 恢复阶段和门禁。
- 可演进：项目级文档和迭代级规格分离，迭代资产跟随迭代。

## 2. 默认目录结构

```text
项目根目录/
├── solo/
│   ├── state.json
│   ├── config.json
│   ├── project/
│   │   ├── brief.md
│   │   ├── prd.md
│   │   ├── ux.md
│   │   ├── design-system.md
│   │   ├── architecture.md
│   │   ├── quality.md
│   │   ├── release.md
│   │   ├── pitfalls.md
│   │   └── assets/
│   │       ├── brand/
│   │       ├── references/
│   │       └── global-mockups/
│   ├── specs/
│   │   ├── 001-iteration-name/
│   │   │   ├── brainstorm.md  # 仅迭代前置阶段按需生成
│   │   │   ├── proposal.md    # 仅迭代收敛阶段按需生成
│   │   │   ├── spec.md
│   │   │   ├── design.md
│   │   │   ├── plan.md
│   │   │   ├── tasks.md
│   │   │   ├── qa.md
│   │   │   ├── archive.md
│   │   │   └── assets/
│   │   │       ├── wireframes/
│   │   │       ├── mockups/
│   │   │       ├── screenshots/
│   │   │       └── references/
│   │   └── NNN-bugfix-title/
│   │       ├── proposal.md
│   │       ├── plan.md
│   │       ├── tasks.md
│   │       ├── qa.md
│   │       ├── archive.md
│   │       └── assets/
│   │           ├── screenshots/
│   │           └── references/
│   ├── decisions/
│   │   └── ADR-0001-title.md
│   └── archive/
│       └── YYYY-MM/
├── AGENTS.md 或 CLAUDE.md
├── README.md
├── CHANGELOG.md
└── 用户原有源码和配置
```

## 3. 事实源规则

`solo/` 是完整事实源。外部文件只允许写托管块或摘要索引，不能成为唯一事实源。

托管块模板和卸载规则见 `docs/internal/02-template-contract.md`。

## 4. 项目级文档

项目级文档位于 `solo/project/`，描述所有功能共享的长期事实。

调研不是项目级固定文档。每个阶段需要调研时，只把已确认结论写入当前阶段文档：产品方向写入 `brief.md` 或 `prd.md`，UX / 视觉依据写入 `ux.md` 或 `design-system.md`，技术事实写入 `architecture.md` 或 ADR。

| 文件 | 内容 |
|---|---|
| brief.md | 项目一句话、目标用户、核心场景、初步依据、约束 |
| prd.md | 产品需求、MVP、范围、非目标、成功指标 |
| ux.md | 全局用户流、信息架构、全局页面地图 |
| design-system.md | 设计语言、颜色、字体、组件、文案规则 |
| architecture.md | 技术栈、目录、模块、数据流、外部依赖 |
| quality.md | 测试策略、QA 矩阵、安全、性能、可观测性 |
| release.md | 发布流程、环境、部署、回滚、版本规则 |
| pitfalls.md | 跨功能可复用踩坑记录 |

纯后端或 CLI 项目可在 `ux.md`、`design-system.md` 中写“不适用”，不删除文件。

## 5. 规格目录

每次迭代、变更、独立 Bug 修复或 MVP 里程碑对应一个 `solo/specs/NNN-name/`。目录先创建 `assets/`，Markdown 按流程阶段逐步生成，不在一开始复制完整模板。

新项目的 `specs/001-mvp/` 在项目级 `architecture` 通过后创建，直接从 SDD/TDD 文件开始，不生成 `brainstorm.md` 和 `proposal.md`。新项目的发散过程不落盘，只把确认后的结论写入 `solo/project/`。

功能迭代可以保留自己的不确定内容、取舍过程和用户选择，因为这些内容只影响该迭代，不会成为项目级长期事实。

独立 Bug 修复使用缩减规格：默认只生成 `proposal.md`、`plan.md`、`tasks.md`、`qa.md`、`archive.md` 和资产目录，不生成 `brainstorm.md`、`spec.md`、`design.md`。如果修复过程中发现本质上是产品能力调整或 UI/UX 重设，应停止 bugfix 路径，转为功能迭代。

| 文件 | 内容 |
|---|---|
| brainstorm.md | 功能迭代的发散方案池、取舍、用户采纳记录；新项目 MVP 和 Bug 修复不生成 |
| proposal.md | 功能迭代收敛后的提案；Bug 修复中记录复现、影响范围和修复边界；新项目 MVP 不生成 |
| spec.md | 做什么，用户故事、场景、验收标准、非目标；Bug 修复默认不生成 |
| design.md | UX/UI、状态规划、数据流、交互、边界；Bug 修复默认不生成 |
| plan.md | 技术实现方案、影响文件、根因、风险、回滚边界 |
| tasks.md | TDD 任务，红灯测试、最小实现、验证命令 |
| qa.md | 测试计划、QA 执行记录、浏览器/API 验证、截图证据 |
| archive.md | 完成摘要、变更、遗留问题、后续建议 |
| assets/ | 该规格专属线稿、高保真、截图、参考资料；Bug 修复通常只使用截图和参考资料 |

## 6. 资产放置规则

### 6.1 项目级资产

放在 `solo/project/assets/`。

适合放：

- logo、品牌色、字体参考。
- 全局设计系统参考。
- 全局页面地图。
- 项目级竞品截图。

### 6.2 迭代级资产

放在 `solo/specs/NNN-iteration-name/assets/`。

适合放：

- 某次迭代新增或修改页面的 SVG 线稿。
- 某次迭代新增或修改页面的 HTML 高保真稿。
- 某次迭代的移动端/桌面端截图证据。
- 某次迭代专用竞品截图和资料。

迭代完成后，如果沉淀出全局组件、token 或文案规则，在归档阶段更新 `solo/project/design-system.md`。

## 7. 命名规范

### 7.1 迭代目录

格式：

```text
NNN-kebab-case-name
```

示例：

```text
001-email-login
002-repo-detail-page
003-onboarding-flow
```

目录名使用英文 kebab-case，文档标题可使用中文。

理由：

- 更适合跨平台、URL、命令行和工具链。
- 避免 Windows、shell、编码、空格带来的不必要问题。
- 中文语义写在文档标题和正文中。

### 7.2 ADR

格式：

```text
ADR-0001-title.md
```

ADR 记录跨功能或高影响决策。普通功能内部取舍写在对应 `plan.md`。

## 8. 状态文件

`solo/state.json` 用于恢复 `$solo-spec 继续`。

建议字段：

```json
{
  "version": 1,
  "branch": "iteration",
  "currentSpec": "001-email-login",
  "currentStage": "architecture",
  "gate": {
    "status": "waiting_user",
    "requires": "confirm_architecture"
  },
  "updatedAt": "2026-07-02T00:00:00+08:00"
}
```

状态文件只记录流程状态，不承载完整需求内容。`gate.requires` 使用 ASCII 短码，中文门禁说明写入阶段文档和完成消息。完整内容必须写入对应 Markdown。

## 9. 老项目接入规则

接入老项目时：

- 先创建 `solo/`。
- 只读原有文档和代码，生成接入盘点。
- 不移动、不重命名、不格式化原业务文件。
- 不默认改写原 `docs/`。
- 如需写入 `AGENTS.md`、`README.md`、`CHANGELOG.md`，先说明托管块内容并等待确认。

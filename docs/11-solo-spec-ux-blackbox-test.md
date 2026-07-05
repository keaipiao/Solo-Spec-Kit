# solo-spec-ux 黑盒测试

测试日期：2026-07-04

## 1. 测试目标

验证 `skills/solo-spec-ux/` 能否把外部 UX / 设计产物转换为 SoloSpec 标准 expert packet，并满足以下约束：

- 不直接写文件。
- 不推进 `/solo` 阶段。
- 不通过门禁。
- 不创建外部设计目录。
- 只把可采纳内容映射到 `solo/project/` 或当前 `solo/specs/NNN-*/`。
- 对不适合当前阶段的内容给出 `discarded` 原因。

## 2. 前置发现

测试前对照模板章节时发现 `references/ux-contract.md` 中部分章节名不是模板真实标题：

- `project/ux.md` 没有 `页面结构`，应使用 `信息架构` 或 `页面地图`。
- 当前 spec `design.md` 没有 `状态规则`，应使用 `状态规划`。
- 当前 spec `archive.md` 没有 `项目基线晋升建议`，应使用 `项目级文档更新记录`。

已修正 `skills/solo-spec-ux/references/ux-contract.md`。

## 3. 用例一：taste 高保真输出映射到迭代规格

### 输入

```text
branch: iteration
stage: design
currentSpec: specs/002-dashboard
externalSource: taste

taste 输出：
- 生成 dashboard overview 高保真图：/tmp/taste/dashboard-overview.png
- 生成 dashboard empty state 高保真图：/tmp/taste/dashboard-empty.png
- 建议全站改为深色玻璃拟态品牌风格
- 建议直接修改 src/pages/dashboard.tsx 和 src/styles/theme.css
- 视觉建议：顶部指标区、趋势图、任务列表三栏布局；移动端改为单列堆叠
```

### 输出

```text
expert: solo-spec-ux
branch: iteration
stage: design
mode: generator
summary: taste 产物可作为本次 dashboard 迭代的高保真参考，但全站重设和代码修改不属于 design 阶段。
findings:
  - dashboard overview 和 empty state 有明确页面状态，可登记为当前 spec 的高保真设计产物。
  - 移动端单列堆叠属于当前页面响应式状态，应写入状态规划。
  - 全站深色玻璃拟态会改变项目级设计基线，不能在本次迭代 design 阶段直接采纳。
recommendation: 采纳当前 dashboard 页面相关资产和状态说明；全站品牌重设需单独门禁确认，代码修改留到 implementation 阶段。
writeTargets:
  - file: specs/002-dashboard/design.md
    section: 设计产物
    content: 登记 taste 生成的 dashboard overview 与 empty state 高保真图，作为本次 dashboard 迭代参考。
  - file: specs/002-dashboard/design.md
    section: 页面 / 组件清单
    content: Dashboard 页面包含顶部指标区、趋势图、任务列表；移动端使用单列堆叠。
  - file: specs/002-dashboard/design.md
    section: 状态规划
    content: Empty state 使用引导文案和创建入口；移动端保持指标、趋势、任务的纵向浏览顺序。
  - file: specs/002-dashboard/design.md
    section: 项目级设计影响
    content: taste 建议的全站深色玻璃拟态属于项目级设计变更候选，本次不晋升项目基线。
assets:
  - source: /tmp/taste/dashboard-overview.png
    target: specs/002-dashboard/assets/mockups/taste-dashboard-overview-01.png
    registerIn: specs/002-dashboard/design.md
    description: Dashboard overview high-fidelity mockup for default state.
  - source: /tmp/taste/dashboard-empty.png
    target: specs/002-dashboard/assets/mockups/taste-dashboard-empty-state-01.png
    registerIn: specs/002-dashboard/design.md
    description: Dashboard empty-state high-fidelity mockup.
discarded:
  - item: 全站改为深色玻璃拟态品牌风格
    reason: needs-user-confirmation
  - item: 直接修改 src/pages/dashboard.tsx 和 src/styles/theme.css
    reason: implementation-leak
gate:
  required: true
  question: 是否确认仅采纳 dashboard 当前迭代的高保真参考，并暂不改变项目级品牌基线？
risks:
  - taste 图像需要在写入前确认文件可访问并复制到 SoloSpec 资产目录。
  - 如果用户确认全站重设，应转为项目级设计基线变更或新的迭代范围。
```

### 结论

通过。输出没有写外部目录，没有直接改代码，能把 taste 高保真图映射到当前 spec 资产目录，并把全站重设放入门禁。

## 4. 用例二：新项目 UX 阶段设定项目体验基线

### 输入

```text
branch: new-project
stage: ux

项目想法：
- 面向独立开发者的轻量任务规划工具
- 用户希望项目整体感觉安静、可信、适合长时间工作
- 用户已确认主方向为“低噪音工作台”，暂不做社交协作
- 页面候选：今日计划、任务详情、复盘、设置
- 用户希望主题色偏绿色，但没有确认具体 token
```

### 输出

```text
expert: solo-spec-ux
branch: new-project
stage: ux
mode: advisor
summary: 当前可沉淀项目级 UX 基线和设计方向，但具体色值 token 仍需门禁确认。
findings:
  - 目标用户是独立开发者，核心任务是规划、执行和复盘，不是协作社交。
  - 页面结构可围绕今日计划、任务详情、复盘、设置四个一级入口。
  - “低噪音工作台”可作为设计语言，但绿色 token 尚未确定。
recommendation: 先写入项目级 UX 结构、核心流程和设计语言；主题色只写候选方向，不写死具体 token。
writeTargets:
  - file: project/ux.md
    section: 信息架构
    content: 一级入口为今日计划、任务详情、复盘、设置；默认进入今日计划。
  - file: project/ux.md
    section: 用户流
    content: 用户进入今日计划，选择或创建任务，完成后进入复盘记录下一步。
  - file: project/ux.md
    section: 页面地图
    content: 今日计划负责当日任务编排；任务详情负责执行上下文；复盘负责总结；设置负责偏好和数据管理。
  - file: project/ux.md
    section: 全局状态规则
    content: 空状态提供创建第一个任务入口；错误状态保留本地草稿；移动端优先今日计划。
  - file: project/design-system.md
    section: 设计语言
    content: 低噪音、可信、长时间工作友好；避免强营销感和社交动态流。
  - file: project/design-system.md
    section: 色彩
    content: 绿色可作为主题色候选，但具体 token 需用户确认后写入。
assets: []
discarded:
  - item: 社交协作入口
    reason: out-of-scope
gate:
  required: true
  question: 是否确认项目设计基线采用“低噪音工作台”，并将绿色作为需后续确认 token 的主题色候选方向？
risks:
  - 主题色尚未确认具体 token，不能写成最终色值。
  - 如果后续加入协作能力，信息架构需要重新评估。
```

### 结论

通过。新项目 UX 阶段只写项目级文档，不创建 spec，不提前写功能级 `design.md`。主题色作为候选，需要门禁确认。

## 5. 用例三：迭代设计变更与项目基线冲突

### 输入

```text
branch: iteration
stage: design
currentSpec: specs/003-focus-mode

项目基线：
- project/design-system.md 使用浅色、中性、低噪音风格
- color-primary 当前为柔和绿色

本次迭代：
- 增加专注模式页面
- 用户希望专注模式页面使用深色背景、低亮度控件、计时器大字号
- 不希望现在全站改深色
```

### 输出

```text
expert: solo-spec-ux
branch: iteration
stage: design
mode: advisor
summary: 深色专注模式可作为当前 spec 的局部页面设计，不应立即晋升为项目级主题变更。
findings:
  - 用户明确不希望全站改深色，因此本次深色方案只适用于 focus mode 页面。
  - 专注模式需要覆盖默认、计时中、暂停、完成、退出确认和移动端状态。
  - 大字号计时器影响页面组件清单和状态规划，不影响当前项目级 token。
recommendation: 在当前 spec 中记录局部设计规则和项目级影响，归档时再判断是否需要晋升 project/design-system.md。
writeTargets:
  - file: specs/003-focus-mode/design.md
    section: UX 目标
    content: 为专注任务提供低干扰、可快速进入和退出的局部深色页面体验。
  - file: specs/003-focus-mode/design.md
    section: 页面 / 组件清单
    content: 专注模式页包含计时器、当前任务、暂停按钮、完成按钮、退出确认。
  - file: specs/003-focus-mode/design.md
    section: 状态规划
    content: 覆盖默认、计时中、暂停、完成、退出确认、移动端状态。
  - file: specs/003-focus-mode/design.md
    section: 项目级设计影响
    content: 当前深色设计仅限专注模式页面；不建议立即更新 project/design-system.md。
assets: []
discarded:
  - item: 全站深色主题晋升
    reason: baseline-pollution
gate:
  required: true
  question: 是否确认深色设计仅限本次专注模式页面，不更新项目级主题？
risks:
  - 局部深色页面需要额外确认对比度、焦点样式和减少动画策略。
  - 归档阶段需要决定是否把专注模式的局部规则写入项目级踩坑或设计系统。
```

### 结论

通过。当前 spec 优先，冲突内容留在本次迭代，不中途修改项目级基线。

## 6. 总结

`solo-spec-ux` 黑盒测试通过三类核心场景：

- taste 高保真输出作为外部 Generator 时，可以映射到当前 spec 资产目录。
- 新项目 UX 阶段可以写项目级 UX 和设计系统，但不提前创建功能级规格。
- 迭代设计变更与项目基线冲突时，当前 spec 优先，项目基线只在归档阶段候选晋升。

本轮发现并修正一个真实问题：`ux-contract.md` 的章节映射必须严格使用模板标题，不能使用概念化章节名。

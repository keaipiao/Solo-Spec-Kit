# solo-spec-architecture 黑盒测试

测试日期：2026-07-04

## 1. 测试目标

验证 `skills/solo-spec-architecture/` 能否把架构分析、依赖核验、ADR、技术计划和 Bug 根因转换为 SoloSpec 标准 expert packet，并满足以下约束：

- 不直接写文件。
- 不推进 `/solo` 阶段。
- 不通过门禁。
- 不直接改依赖、配置、迁移或代码。
- 技术栈不是固定模板，只列已采用或决策相关层。
- 不把所有未触发架构层写成 `不适用`。
- 需要当前事实时要求官方核验。
- Bugfix 必须先有根因和最小修复策略。

## 2. 用例一：新项目架构主动触发鉴权层

### 输入

```text
branch: new-project
stage: architecture

已确认产品和 UX：
- Spring Boot 后端
- Web 管理台
- 需要登录、角色权限、管理员页面
- 需要保存项目、规格和任务数据
- 暂不做搜索、队列、支付、AI 模型调用
```

### 输出

```text
expert: solo-spec-architecture
branch: new-project
stage: architecture
mode: advisor
summary: 当前项目触发鉴权、持久化、安全约束和 ADR；未触发的搜索、队列、支付、AI 层不应写入技术栈。
findings:
  - 登录、角色权限和管理员页面触发 authentication / authorization 架构层。
  - 项目、规格和任务数据触发数据库、迁移和备份策略。
  - Spring Boot 鉴权方案需要官方核验后再确认具体 Spring Security 版本和配置方式。
recommendation: 在 project/architecture.md 写入已触发层；为鉴权模型和持久化策略建议 ADR。
writeTargets:
  - file: project/architecture.md
    section: 技术栈与运行环境
    content: 后端采用 Spring Boot；鉴权层和持久化层为已触发架构层，具体 Spring Security 版本和数据库方案需官方核验后确认。
  - file: project/architecture.md
    section: 架构边界
    content: 本阶段不引入搜索、队列、支付、AI 模型调用；这些不是技术栈条目，只作为当前边界。
  - file: project/architecture.md
    section: 模块边界
    content: 建议划分 auth、project、spec、task、admin 模块；auth 负责认证和授权，admin 只依赖授权结果。
  - file: project/architecture.md
    section: 数据模型
    content: 初始实体包含 User、Role、Project、Spec、Task；迁移策略需在架构门禁前确认。
  - file: project/architecture.md
    section: 安全和约束
    content: 所有管理端接口必须经过认证和角色授权；输入校验和敏感数据处理需要单独规则。
  - file: project/architecture.md
    section: ADR 索引
    content: 建议新增 ADR：鉴权模型；持久化策略。
  - file: decisions/ADR-0002-auth-model.md
    section: 背景
    content: 产品需要登录、角色权限和管理员页面，鉴权模型会影响接口、数据模型和测试。
  - file: decisions/ADR-0002-auth-model.md
    section: 决策
    content: 待官方核验 Spring Security 后确认认证和授权模型。
assets: []
discarded:
  - item: 搜索层写入技术栈并标记不适用
    reason: untriggered-layer
  - item: 队列层写入技术栈并标记不适用
    reason: untriggered-layer
  - item: 直接添加 Spring Security 依赖
    reason: implementation-leak
gate:
  required: true
  question: 是否确认本项目触发鉴权和持久化架构层，并先官方核验 Spring Security 与数据库方案后再定稿？
risks:
  - Spring Security 版本和推荐配置需要官方文档核验。
  - 数据库选择会影响迁移、备份和回滚策略。
```

### 结论

通过。架构专家主动识别鉴权层，但没有把未触发层塞进技术栈，也没有直接改依赖。

## 3. 用例二：迭代技术计划需要数据迁移和回滚

### 输入

```text
branch: iteration
stage: architecture
currentSpec: specs/005-task-reminder

本次迭代：
- 给任务增加提醒时间
- 支持用户开启/关闭提醒
- 当前系统已有 Task 表
- 还没有后台队列
```

### 输出

```text
expert: solo-spec-architecture
branch: iteration
stage: architecture
mode: advisor
summary: 本次迭代触发数据模型变更和提醒调度决策；是否引入后台队列需要门禁确认。
findings:
  - Task 表需要新增 reminderAt 和 reminderEnabled 之类字段。
  - 提醒能力可能触发后台任务或调度层，但当前系统尚未采用队列。
  - 直接引入队列是架构扩张，必须说明替代方案和回滚。
recommendation: 在当前 spec plan.md 记录数据迁移、接口契约、关键决策、风险回滚和验证策略；队列作为决策候选，不直接采用。
writeTargets:
  - file: specs/005-task-reminder/plan.md
    section: 实现概述
    content: 为任务增加提醒配置，先支持记录提醒时间和开关；提醒执行方案需门禁确认。
  - file: specs/005-task-reminder/plan.md
    section: 数据模型和迁移
    content: Task 新增 reminderAt、reminderEnabled 字段；迁移需默认关闭提醒并支持回滚字段。
  - file: specs/005-task-reminder/plan.md
    section: 接口契约
    content: 任务创建和更新接口增加提醒字段；关闭提醒时允许 reminderAt 为空。
  - file: specs/005-task-reminder/plan.md
    section: 关键决策
    content: 提醒执行方案候选：应用内定时扫描、数据库轮询、后台队列；本阶段需用户确认。
  - file: specs/005-task-reminder/plan.md
    section: 风险和回滚
    content: 风险是提醒误发、漏发和迁移失败；回滚方式是关闭提醒开关并回滚新增字段使用。
  - file: specs/005-task-reminder/plan.md
    section: 验证策略
    content: 验证提醒字段保存、关闭提醒、空值兼容和迁移默认值。
assets: []
discarded:
  - item: 直接引入消息队列依赖
    reason: implementation-leak
  - item: 把队列层写入项目技术栈
    reason: needs-user-confirmation
gate:
  required: true
  question: 本次提醒功能是否先采用轻量方案，暂不引入后台队列？
risks:
  - 如果需要真实定时发送，必须进一步确认运行环境和调度可靠性。
  - 数据迁移需要实现前补充回滚命令或兼容策略。
```

### 结论

通过。当前 spec 优先，队列作为候选决策，不污染项目级技术栈。

## 4. 用例三：Bugfix 根因不明确时禁止随机修复

### 输入

```text
branch: bugfix
stage: root-cause
currentSpec: specs/006-bugfix-token-expiry

问题：
- 用户登录 30 分钟后偶发 401
- 有人建议直接把 token 过期时间改成 24 小时
- 日志显示部分请求 refresh token 成功，部分请求仍使用旧 access token
```

### 输出

```text
expert: solo-spec-architecture
branch: bugfix
stage: root-cause
mode: reviewer
summary: 当前现象更像 token 刷新竞态或客户端缓存旧 token，不能直接把过期时间改成 24 小时。
findings:
  - 部分请求 refresh 成功但仍使用旧 access token，说明问题可能在 token 更新传播或并发请求顺序。
  - 延长过期时间会掩盖根因并扩大安全风险。
  - 修复前需要确认客户端 token 更新时机和并发请求行为。
recommendation: 在 bugfix plan.md 写入待核验根因候选、最小修复策略和回归风险；先补复现或日志证据。
writeTargets:
  - file: specs/006-bugfix-token-expiry/plan.md
    section: 根因
    content: 初步根因候选是 token 刷新后并发请求仍读取旧 access token；需要复现或日志证据确认。
  - file: specs/006-bugfix-token-expiry/plan.md
    section: 修复策略
    content: 最小修复方向是统一 token 更新和请求重试入口，避免并发请求使用旧 token。
  - file: specs/006-bugfix-token-expiry/plan.md
    section: 影响范围
    content: 影响登录态管理、请求拦截器、刷新 token 流程和 401 重试逻辑。
  - file: specs/006-bugfix-token-expiry/plan.md
    section: 回归风险
    content: 风险包括刷新循环、重复请求、会话提前失效和安全策略弱化。
  - file: specs/006-bugfix-token-expiry/plan.md
    section: 根因门禁
    content: 需要确认根因证据后再进入 fix 阶段。
assets: []
discarded:
  - item: 直接把 token 过期时间改成 24 小时
    reason: scope-creep
  - item: 未确认根因就修改鉴权策略
    reason: wrong-stage
gate:
  required: true
  question: 是否先确认 token 刷新竞态/旧 token 读取根因，再决定最小修复？
risks:
  - 延长 token 过期时间可能降低安全性且无法修复并发旧 token 问题。
  - 如果根因在服务端签发或时钟偏移，需要调整调查方向。
```

### 结论

通过。Bugfix 阶段没有随机修复，先沉淀根因和最小修复策略。

## 5. 用例四：外部架构建议包含未核验版本断言和大重构

### 输入

```text
branch: iteration
stage: architecture
currentSpec: specs/007-export-pdf

外部架构顾问建议：
- 直接迁移到微服务
- 使用某 PDF SDK 最新版，声称免费且无限制
- 创建 docs/architecture/export-design.md
- 直接修改 package.json 并实现导出服务

当前需求：
- 本次迭代只需要导出单个项目的 PDF 报告
```

### 输出

```text
expert: solo-spec-architecture
branch: iteration
stage: architecture
mode: reviewer
summary: 外部建议包含过度架构、未核验 SDK 断言和目录越界；只能保留 PDF 导出相关的架构风险。
findings:
  - 单项目 PDF 导出不必然触发微服务迁移。
  - PDF SDK 免费、无限制属于当前事实，必须官方核验。
  - docs/architecture/ 不是 SoloSpec 架构文档目录。
recommendation: 在当前 plan.md 记录 PDF 导出影响范围、依赖风险、回滚和验证策略；SDK 选择需核验后再决定。
writeTargets:
  - file: specs/007-export-pdf/plan.md
    section: 实现概述
    content: 本次只实现单项目 PDF 报告导出，不做服务拆分。
  - file: specs/007-export-pdf/plan.md
    section: 影响范围
    content: 影响报告生成模块、导出入口、文件下载或存储策略。
  - file: specs/007-export-pdf/plan.md
    section: 关键决策
    content: PDF SDK 选择待官方核验许可、限制、运行环境和维护状态后确认。
  - file: specs/007-export-pdf/plan.md
    section: 风险和回滚
    content: 风险包括 SDK 限制、中文字体、分页质量和生成性能；回滚方式是隐藏导出入口并保留原数据。
  - file: specs/007-export-pdf/plan.md
    section: 验证策略
    content: 验证中文内容、分页、下载、错误处理和无数据场景。
assets: []
discarded:
  - item: 直接迁移到微服务
    reason: scope-creep
  - item: PDF SDK 最新版免费且无限制
    reason: needs-official-verification
  - item: docs/architecture/export-design.md
    reason: no-solo-target
  - item: 直接修改 package.json 并实现导出服务
    reason: implementation-leak
gate:
  required: true
  question: 是否确认本次只做单项目 PDF 导出，并在官方核验 SDK 后再定依赖？
risks:
  - PDF SDK 许可、限制、字体和运行环境需要官方核验。
  - 如果导出体积大或并发高，后续可能触发后台任务或队列决策。
```

### 结论

通过。外部架构建议被收敛到当前 spec `plan.md`，未核验事实和大重构被丢弃。

## 6. 总结

`solo-spec-architecture` 黑盒测试覆盖了四类关键风险：

- 架构层可扩展，但只写触发或决策相关层。
- 迭代架构变更留在当前 spec，项目技术栈不被中途污染。
- Bugfix 先根因后修复，避免随机改代码。
- 外部架构建议不能越权创建目录、改依赖或跳过官方核验。

本轮没有发现章节映射错误；`architecture-contract.md` 的所有目标章节已通过模板对照校验。

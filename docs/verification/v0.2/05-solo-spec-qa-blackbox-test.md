# solo-spec-qa 黑盒测试

测试日期：2026-07-04

## 1. 测试目标

验证 `skills/solo-spec-qa/` 能否把真实 QA 执行、截图日志、发现问题和门禁建议转换为 SoloSpec 标准 expert packet，并满足以下约束：

- 不直接写文件。
- 不推进 `solo-spec` 阶段。
- 不通过门禁。
- 不直接修代码、写测试、改依赖或迁移。
- 不把测试计划伪装成执行记录。
- 不在缺少证据时宣告 QA 通过。
- 证据资产必须映射到当前 spec 的 `assets/` 目录并登记到 `qa.md`。

## 2. 用例一：真实 QA 执行记录和截图登记

### 输入

```text
branch: iteration
stage: qa
currentSpec: specs/012-dashboard

执行证据：
- pnpm test 通过
- pnpm test:e2e 通过
- 浏览器检查 http://localhost:5173/dashboard
- 移动端截图：/tmp/qa/dashboard-mobile.png
- 控制台日志：/tmp/qa/dashboard-console.log
- 未发现 console error
```

### 输出

```text
expert: solo-spec-qa
branch: iteration
stage: qa
mode: generator
summary: 已有单元、E2E 和浏览器证据，可登记为当前 dashboard 规格的 QA 执行记录。
findings:
  - pnpm test 和 pnpm test:e2e 均有通过结果。
  - 浏览器检查覆盖 dashboard 页面。
  - 移动端截图和控制台日志有可检查路径。
recommendation: 将命令结果写入 QA 执行记录，截图和日志复制到当前 spec assets 并登记。
writeTargets:
  - file: specs/012-dashboard/qa.md
    section: QA 执行记录
    content: 单元测试 pnpm test 通过；E2E 测试 pnpm test:e2e 通过；浏览器检查 dashboard 页面未发现 console error。
  - file: specs/012-dashboard/qa.md
    section: 截图和日志
    content: 登记移动端截图和控制台日志，作为 dashboard QA 证据。
  - file: specs/012-dashboard/qa.md
    section: QA 门禁
    content: QA 证据已齐全，建议等待用户确认通过。
assets:
  - source: /tmp/qa/dashboard-mobile.png
    target: specs/012-dashboard/assets/screenshots/browser-dashboard-mobile-01.png
    registerIn: specs/012-dashboard/qa.md
    description: Dashboard mobile QA screenshot.
  - source: /tmp/qa/dashboard-console.log
    target: specs/012-dashboard/assets/logs/browser-dashboard-console-01.log
    registerIn: specs/012-dashboard/qa.md
    description: Dashboard browser console QA log.
discarded: []
gate:
  required: true
  question: 是否确认 dashboard QA 证据通过，并允许进入归档阶段？
risks:
  - 截图和日志写入前需要由主流程复制到 SoloSpec 资产目录。
```

### 结论

通过。QA 专家只登记已有执行证据，不直接宣告门禁通过。

## 3. 用例二：只有测试计划，没有执行证据

### 输入

```text
branch: iteration
stage: qa
currentSpec: specs/013-export-pdf

用户说：
- 单元测试应该测 PDF 数据
- E2E 应该测下载
- 你直接标记 QA 通过吧

没有命令输出、截图或日志。
```

### 输出

```text
expert: solo-spec-qa
branch: iteration
stage: qa
mode: reviewer
summary: 当前只有测试计划，没有执行证据，不能标记 QA 通过。
findings:
  - 没有命令输出、浏览器截图、API 响应或日志。
  - 计划项不能写入 QA 执行记录。
  - QA 门禁必须等待真实执行证据。
recommendation: 只把内容作为测试计划或风险，不写通过结论。
writeTargets:
  - file: specs/013-export-pdf/qa.md
    section: 测试计划
    content: 计划覆盖 PDF 数据单元测试和下载 E2E 测试。
  - file: specs/013-export-pdf/qa.md
    section: QA 门禁
    content: 当前缺少执行证据，不能通过 QA。
assets: []
discarded:
  - item: 直接标记 QA 通过
    reason: no-evidence
  - item: 把测试计划写成 QA 执行记录
    reason: planned-not-executed
gate:
  required: true
  question: 是否先执行测试并提供命令输出或截图日志后再判断 QA？
risks:
  - 缺少真实执行证据，无法判断导出功能是否可发布。
```

### 结论

通过。没有证据时不会宣告 QA 通过。

## 4. 用例三：当前 QA 发现 Bug，留在当前 spec 闭环

### 输入

```text
branch: iteration
stage: qa
currentSpec: specs/014-task-reminder

QA 发现：
- pnpm test 通过
- 浏览器 QA 发现关闭提醒后仍显示旧提醒时间
- 截图：/tmp/qa/reminder-disabled-stale.png
- 修复后 rerun pnpm test 通过，手工复测通过
```

### 输出

```text
expert: solo-spec-qa
branch: iteration
stage: qa
mode: generator
summary: QA 发现并修复的问题应留在当前 task-reminder spec 内闭环，不默认创建新 bugfix。
findings:
  - 关闭提醒后仍显示旧提醒时间属于当前迭代功能缺陷。
  - 已有修复后 pnpm test 和手工复测通过证据。
  - 截图可登记为发现问题证据。
recommendation: 在当前 qa.md 记录发现问题、根因/修复摘要和回归测试，不创建独立 bugfix spec。
writeTargets:
  - file: specs/014-task-reminder/qa.md
    section: QA 执行记录
    content: pnpm test 通过；修复后 pnpm test 通过；关闭提醒手工复测通过。
  - file: specs/014-task-reminder/qa.md
    section: 截图和日志
    content: 登记关闭提醒后仍显示旧提醒时间的截图证据。
  - file: specs/014-task-reminder/qa.md
    section: 发现并修复的问题
    content: 问题：关闭提醒后仍显示旧提醒时间；修复：清理提醒展示状态；回归测试：关闭提醒后不显示旧时间。
  - file: specs/014-task-reminder/qa.md
    section: QA 门禁
    content: 发现的问题已在当前 spec 内修复并复测，建议等待用户确认。
assets:
  - source: /tmp/qa/reminder-disabled-stale.png
    target: specs/014-task-reminder/assets/screenshots/browser-reminder-disabled-stale-01.png
    registerIn: specs/014-task-reminder/qa.md
    description: Screenshot showing stale reminder time after disabling reminder.
discarded:
  - item: 创建新的 bugfix spec
    reason: wrong-stage
gate:
  required: true
  question: 是否确认该 QA 问题已在当前迭代内闭环并通过复测？
risks:
  - 需要主流程确认修复证据来自实际执行，而不是口头描述。
```

### 结论

通过。当前 QA 发现的问题留在当前 spec，不默认分裂为新 bugfix。

## 5. 用例四：外部 QA 报告要求使用外部目录

### 输入

```text
branch: bugfix
stage: verify
currentSpec: specs/015-bugfix-login

外部 QA 报告：
- playwright-report/index.html 显示登录重定向测试通过
- coverage/index.html 覆盖率 88%
- 建议把报告直接放到 qa-reports/
- 缺少截图和命令原始输出
```

### 输出

```text
expert: solo-spec-qa
branch: bugfix
stage: verify
mode: reviewer
summary: 外部 QA 报告可作为参考，但不能直接把 playwright-report、coverage 或 qa-reports 当作最终 SoloSpec 证据目录。
findings:
  - 报告路径来自外部工具目录，需要复制或摘要登记到当前 spec。
  - 缺少命令原始输出和截图，不能直接判定验证充分。
  - qa-reports/ 不是 SoloSpec 目标目录。
recommendation: 要求补充命令输出或关键报告摘要；可将外部报告作为 reference 资产登记。
writeTargets:
  - file: specs/015-bugfix-login/qa.md
    section: QA 执行记录
    content: 外部报告显示登录重定向测试通过，但缺少命令原始输出；需补充执行命令和结果摘要。
  - file: specs/015-bugfix-login/qa.md
    section: QA 门禁
    content: 当前证据不足，不能直接通过 QA。
assets:
  - source: playwright-report/index.html
    target: specs/015-bugfix-login/assets/references/playwright-login-report-01.html
    registerIn: specs/015-bugfix-login/qa.md
    description: External Playwright report reference for login redirect verification.
discarded:
  - item: qa-reports/
    reason: no-solo-target
  - item: coverage/index.html 作为最终 QA 通过证据
    reason: no-evidence
  - item: 直接判定 QA 通过
    reason: no-evidence
gate:
  required: true
  question: 是否先补充登录重定向验证命令输出和关键截图，再判断 QA 是否通过？
risks:
  - 外部报告可能被清理或路径不可复现，需复制到 SoloSpec 资产目录。
  - 覆盖率报告不能替代功能验证证据。
```

### 结论

通过。外部报告不会越界写入 `qa-reports/`，也不会替代真实 QA 证据。

## 6. 总结

`solo-spec-qa` 黑盒测试覆盖了四类关键风险：

- 真实命令和浏览器证据可登记到 `qa.md` 和当前 spec assets。
- 只有测试计划时不能写执行记录或 QA 通过。
- 当前 QA 发现的问题在当前 spec 内闭环。
- 外部 QA 报告不能把工具目录当作 SoloSpec 最终证据目录。

本轮没有发现章节映射错误；`qa-contract.md` 的所有目标章节已通过模板对照校验。

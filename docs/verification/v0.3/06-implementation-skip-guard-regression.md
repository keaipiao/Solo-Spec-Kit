# v0.3 实现阶段跳过防护回归记录

日期：2026-07-07

## 1. 目标

验证用户在 SoloSpec 请求中使用实现型措辞时，主流程不会直接修改业务代码，而是先进入 `intake` 和门禁流程。

## 2. 回归样例

```text
$solo-spec 现在要接入这个接口，参数由前端传递，返回值也直接返回给前端。
```

期望行为：

- 分支优先判定为 `iteration`。
- 首次响应先复述目标、列出假设；若目标或上下文不清，先问阻塞问题。
- 如果没有有效 `solo/state.json`，只能停在 `intake`，不得编辑业务代码。
- 如果 `solo/state.json.currentStage` 不是 `implementation` 或 `fix`，不得编辑业务代码。
- “现在接入接口”“直接实现”“把这个功能加上”等措辞不能替代上游门禁确认。

## 3. 规则落点

- `skills/solo-spec/SKILL.md` 明确实现型措辞不能跳过流程。
- `docs/internal/01-skill-execution-rules.md` 明确只有当前阶段已到 `implementation` / `fix` 且上游门禁通过时才允许改业务代码。
- `docs/internal/03-state-machine.md` 明确无状态时必须进入 `intake`，不能跳到 implementation。
- `README.md` 同步用户可见说明。

## 4. 静态验证

命令：

```powershell
rg -n "现在接入接口|直接实现|implementation|fix|不得修改业务代码|不能跳" `
  skills\solo-spec\SKILL.md `
  docs\internal\01-skill-execution-rules.md `
  docs\internal\03-state-machine.md `
  README.md
```

结果：通过。

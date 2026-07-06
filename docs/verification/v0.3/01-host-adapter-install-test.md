# v0.3 Host Adapter 安装回归报告

日期：2026-07-06

## 1. 目标

验证 v0.3 安装脚本不再硬编码 Codex / zcode，而是通过 host adapter registry 支持多 Agent 工具安装和检测基础。

## 2. 改动范围

- 新增 `scripts/host-adapters.json`。
- 新增 `skills/solo-spec/references/host-adapters.md`。
- `scripts/install-project-skills.ps1` 改为 `-Host` / `-Host auto` / `-ListHosts`。
- 旧参数 `-Tool` 保留为 `-Host` 的兼容别名。
- 主 Skill 和专家参考文档改为按 host adapter roots 检测专家。

## 3. Host 列表验证

命令：

```powershell
.\scripts\install-project-skills.ps1 -ListHosts
```

结果：

| Host | 状态 | 默认 Skill 目录 |
|---|---|---|
| `codex` | confirmed | `.agents/skills` |
| `cursor` | confirmed | `.cursor/skills` |
| `claude-code` | confirmed | `.claude/skills` |
| `opencode` | confirmed | `.opencode/skills` |
| `generic` | confirmed | `.agents/skills` |
| `zcode` | locally-observed | `.zcode/skills` |
| `trae` | needs-real-ide-verification | `.trae/skills` |

结论：通过。

## 4. 多 Host 基础安装验证

命令：

```powershell
$hosts = @('codex','cursor','claude-code','opencode','generic','zcode','trae')
foreach ($h in $hosts) {
  $d = Join-Path $env:TEMP ('solo-v03-host-json-' + $h + '-' + [guid]::NewGuid().ToString('N'))
  New-Item -ItemType Directory -Path $d | Out-Null
  $result = .\scripts\install-project-skills.ps1 -ProjectPath $d -Mode basic -Host $h
  Test-Path (Join-Path $result.SkillsPath 'solo-spec\SKILL.md')
}
```

结果：

| Host | 安装路径 | `solo-spec/SKILL.md` |
|---|---|---|
| `codex` | `.agents/skills` | 存在 |
| `cursor` | `.cursor/skills` | 存在 |
| `claude-code` | `.claude/skills` | 存在 |
| `opencode` | `.opencode/skills` | 存在 |
| `generic` | `.agents/skills` | 存在 |
| `zcode` | `.zcode/skills` | 存在 |
| `trae` | `.trae/skills` | 存在 |

结论：通过。

## 5. `auto` 探测验证

命令摘要：

```powershell
$cases = @(
  @('auto-none',$null,'generic','.agents\skills'),
  @('auto-cursor','.cursor\skills','cursor','.cursor\skills'),
  @('auto-claude-code','.claude\skills','claude-code','.claude\skills'),
  @('auto-opencode','.opencode\skills','opencode','.opencode\skills'),
  @('auto-trae','.trae\skills','trae','.trae\skills'),
  @('auto-zcode','.zcode\skills','zcode','.zcode\skills'),
  @('auto-codex-alt','.codex\skills','codex','.codex\skills'),
  @('auto-generic','.agents\skills','generic','.agents\skills')
)
```

结果：

| Case | 预置目录 | 解析 Host | 安装路径 |
|---|---|---|---|
| `auto-none` | 无 | `generic` | `.agents/skills` |
| `auto-cursor` | `.cursor/skills` | `cursor` | `.cursor/skills` |
| `auto-claude-code` | `.claude/skills` | `claude-code` | `.claude/skills` |
| `auto-opencode` | `.opencode/skills` | `opencode` | `.opencode/skills` |
| `auto-trae` | `.trae/skills` | `trae` | `.trae/skills` |
| `auto-zcode` | `.zcode/skills` | `zcode` | `.zcode/skills` |
| `auto-codex-alt` | `.codex/skills` | `codex` | `.codex/skills` |
| `auto-generic` | `.agents/skills` | `generic` | `.agents/skills` |

结论：通过。

修复说明：第一轮子代理回归发现 `auto` 曾把 `.claude/skills` 和 `.codex/skills` 误判为 `cursor`，且漏检 `.trae/skills`。已改为只按宿主专属目录探测；共享目录 `.agents/skills` 保持为 `generic` fallback。

## 6. 旧参数兼容验证

命令：

```powershell
.\scripts\install-project-skills.ps1 -ProjectPath <temp> -Mode enhanced -Tool zcode
```

结果：

- `Host`: `zcode`
- `RequestedHost`: `zcode`
- `<temp>\.zcode\skills\solo-spec-product\SKILL.md`: 存在
- `<temp>\.agents\skills`: 不存在

结论：通过。

## 7. 覆盖保护验证

命令摘要：

```powershell
.\scripts\install-project-skills.ps1 -ProjectPath <temp> -Mode basic -Host generic
.\scripts\install-project-skills.ps1 -ProjectPath <temp> -Mode basic -Host generic
.\scripts\install-project-skills.ps1 -ProjectPath <temp> -Mode basic -Host generic -Force
```

结果：

- 第二次未加 `-Force` 时拒绝覆盖，并提示目标已存在。
- 加 `-Force` 后替换成功。

结论：通过。

## 8. 当前限制

- Trae 目录来自官方能力和 v0.3 registry 设计，仍标记为 `needs-real-ide-verification`，需要后续在真实 Trae IDE 中确认。
- 本轮只验证安装和检测基础，不代表完整 v0.3 流程已经完成。

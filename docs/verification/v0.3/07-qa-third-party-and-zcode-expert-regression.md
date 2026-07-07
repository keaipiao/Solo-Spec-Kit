# v0.3 QA 第三方服务与多 host 专家检测回归记录

日期：2026-07-07

## 1. 目标

覆盖两个运行缺陷：

- QA 阶段不得在未核验第三方服务可用性的情况下直接跳过测试。
- zcode、Trae 等多 host 环境不得只依赖宿主 Skill 注册表判断专家不可用，必须检查项目文件系统中的专家 Skill。

## 2. QA 回归样例

```text
$solo-spec 继续到 QA。当前功能依赖第三方 Open API。
```

期望行为：

- QA 先执行最小可行的服务可用性核验，例如健康检查、认证探测、沙箱请求或真实集成路径。
- 如果凭据、网络、额度、沙箱或服务商故障导致不可测，必须记录尝试的方法、时间、错误和影响范围。
- 未留下可复核证据时，第三方服务相关 QA 不能标记为通过。
- `qa.md` 必须填写“第三方服务核验”章节。

## 3. 多 host 专家检测回归样例

```text
$solo-spec 进入 QA 阶段，当前项目使用 zcode enhanced 安装。
```

期望行为：

- 当前阶段映射专家为 `solo-spec-qa`。
- 主流程默认尝试使用已安装的当前阶段专家。
- 检测专家时必须先查运行中 `solo-spec` 的 sibling 目录，再查当前 host adapter roots。
- zcode 至少检查：
  - `.zcode/skills/solo-spec-qa/SKILL.md`
  - `.agents/skills/solo-spec-qa/SKILL.md`
- Trae 至少检查：
  - `.trae/skills/solo-spec-qa/SKILL.md`
  - `.agents/skills/solo-spec-qa/SKILL.md`
- 如果 active host 不确定或当前 roots 未命中，继续检查 registry 中全部兼容 roots。
- 只有这些路径都不存在，才允许报告未检测到专家。
- 报告不可用时必须列出已检查路径，便于定位误报。

## 4. 规则落点

- `skills/solo-spec/SKILL.md`
- `skills/solo-spec/references/experts.md`
- `skills/solo-spec/references/host-adapters.md`
- `skills/solo-spec-qa/SKILL.md`
- `docs/internal/01-skill-execution-rules.md`
- `skills/solo-spec/references/workflow.md`
- `templates/solo/specs/*/qa.md`
- `skills/solo-spec/assets/templates/solo/specs/*/qa.md`

## 5. 静态验证

命令：

```powershell
rg -n "第三方服务|availability|zcode|trae|默认.*专家|Test-Path|不得直接跳过" `
  skills `
  templates `
  docs\internal `
  docs\public `
  README.md
```

结果：通过。

## 6. host 安装实测

命令摘要：

```powershell
$d = Join-Path $env:TEMP ('solo-zcode-expert-detect-' + [guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $d
.\scripts\install-project-skills.ps1 -ProjectPath $d -Mode enhanced -Host zcode
Test-Path (Join-Path $d '.zcode\skills\solo-spec\SKILL.md')
Test-Path (Join-Path $d '.zcode\skills\solo-spec-qa\SKILL.md')
```

结果：

| 检查 | 结果 |
|---|---:|
| Host | zcode |
| `.zcode/skills/solo-spec/SKILL.md` | true |
| `.zcode/skills/solo-spec-qa/SKILL.md` | true |

结论：zcode enhanced 安装会把主 Skill 和 QA 专家放到同一个 `.zcode/skills` 根目录。主流程若报告未检测到专家，应优先检查文件系统检测逻辑是否执行。

Trae 当前 adapter 状态仍是 `needs-real-ide-verification`。规则层面必须检查 `.trae/skills` 和 `.agents/skills`；是否被 Trae IDE 实际加载，需要后续真实 IDE 验证，不应在文档中写成 confirmed。

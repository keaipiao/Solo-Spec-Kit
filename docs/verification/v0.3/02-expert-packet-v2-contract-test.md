# v0.3 Expert Packet v2 契约回归报告

日期：2026-07-06

## 1. 目标

验证 v0.3 专家契约从 v0.2 的 `reviewer | advisor | generator` 升级为：

- 用户可读中文外层。
- 主流程可消费的 `machine` 内层。
- 四种专家模式：`co-create`、`generate-assets`、`review`、`external-adapter`。

## 2. 改动范围

- `docs/internal/04-expert-contract.md`
- `docs/internal/08-expert-integration-strategy.md`
- `skills/solo-spec/SKILL.md`
- `skills/solo-spec/references/experts.md`
- 六个专家 Skill：
  - `solo-spec-product`
  - `solo-spec-ux`
  - `solo-spec-architecture`
  - `solo-spec-tdd`
  - `solo-spec-qa`
  - `solo-spec-release`
- 当前规则文档和模板配置：
  - `docs/internal/01-skill-execution-rules.md`
  - `docs/internal/02-template-contract.md`
  - `templates/solo/config.json`
  - `skills/solo-spec/assets/templates/solo/config.json`

## 3. 专家 Skill 结构检查

命令：

```powershell
$files = @(
  'skills/solo-spec-product/SKILL.md',
  'skills/solo-spec-ux/SKILL.md',
  'skills/solo-spec-architecture/SKILL.md',
  'skills/solo-spec-tdd/SKILL.md',
  'skills/solo-spec-qa/SKILL.md',
  'skills/solo-spec-release/SKILL.md'
)
foreach ($f in $files) {
  $c = Get-Content -Raw -Encoding UTF8 $f
  [PSCustomObject]@{
    File = $f
    HasMachine = ($c -match 'machine:')
    HasV3Modes = ($c -match 'co-create \| generate-assets \| review \| external-adapter')
    HasOldMode = ($c -match 'mode: reviewer \| advisor \| generator')
  }
}
```

结果：

| Skill | `machine` | v0.3 modes | old mode |
|---|---:|---:|---:|
| `solo-spec-product` | true | true | false |
| `solo-spec-ux` | true | true | false |
| `solo-spec-architecture` | true | true | false |
| `solo-spec-tdd` | true | true | false |
| `solo-spec-qa` | true | true | false |
| `solo-spec-release` | true | true | false |

结论：通过。

## 4. 主流程消费规则检查

命令：

```powershell
rg -n "machine\.writeTargets|machine\.assets|co-create|generate-assets|external-adapter" `
  docs/internal/04-expert-contract.md `
  docs/internal/08-expert-integration-strategy.md `
  skills/solo-spec/references/experts.md `
  skills/solo-spec/SKILL.md
```

结果：

- 主契约要求中文摘要 + `machine`。
- 接入策略校验 `machine.writeTargets` 和 `machine.assets`。
- 主 Skill 说明内置专家可使用 `co-create`、`generate-assets`、`review`。
- 用户指定外部 Skill / 工具时统一作为 `external-adapter`。

结论：通过。

## 5. 配置模板检查

命令：

```powershell
Get-Content -Raw -Encoding UTF8 templates\solo\config.json | ConvertFrom-Json
Get-Content -Raw -Encoding UTF8 skills\solo-spec\assets\templates\solo\config.json | ConvertFrom-Json
```

结果：

- 两份配置都可解析。
- `externalEnhancements` 已切换为：
  - `allowCoCreate`
  - `allowGenerateAssets`
  - `allowReview`
  - `allowExternalAdapter`

结论：通过。

## 6. 当前限制

- v0.2 历史验证报告仍保留旧术语，这是历史证据，不作为当前实现规范。
- `docs/internal/05-expert-module-v02-design.md` 和 `docs/internal/07-expert-skill-research.md` 已标记为 v0.2 历史背景。

## 7. 子代理回归发现与修复

第一轮子代理回归发现并已修复：

- 当前有效引用中的 `Register generator artifacts.` 已改为 `generate-assets` 语义。
- `skills/solo-spec-ux/references/ux-contract.md` 的 `External generator output` 已改为 `External generated output`。
- 主 Skill 当前阶段映射已补充 `implementation` / `fix`，分别覆盖 TDD 红绿范围和架构风险评审。
- `docs/internal/08-expert-integration-strategy.md` 的状态机段已从 v0.2 可选评审改为 v0.3 阶段内共创、资产生成和评审。
- `docs/internal/06-expert-skills-architecture.md` 已从 v0.2 原型/正式落地前表述改为 v0.3 内置专家团队边界。

复查命令：

```powershell
rg -n "Register generator artifacts|External generator output|offer optional current-stage expert|if user accepts|v0\.2 .*正式落地前|首批专家原型|mode: reviewer \| advisor \| generator|global-mockups" `
  docs\internal\04-expert-contract.md `
  docs\internal\06-expert-skills-architecture.md `
  docs\internal\08-expert-integration-strategy.md `
  skills\solo-spec\references\experts.md `
  skills\solo-spec-ux\references\ux-contract.md `
  skills\solo-spec\SKILL.md
```

结果：无匹配。

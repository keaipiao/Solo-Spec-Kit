# 专家 Skill 集成烟测

测试日期：2026-07-04

## 1. 测试目标

验证 `solo-spec` 主 Skill 和六个可选专家 Skill 能以可分发形态共存，并确认专家契约不会写到不存在的 SoloSpec 模板章节。

本次覆盖：

- `solo-spec`
- `solo-spec-product`
- `solo-spec-ux`
- `solo-spec-architecture`
- `solo-spec-tdd`
- `solo-spec-qa`
- `solo-spec-release`

## 2. 结构检查

每个专家 Skill 必须只包含必要文件：

- `SKILL.md`
- `agents/openai.yaml`
- `references/*-contract.md`

结果：

```text
solo-spec-architecture    3 files
solo-spec-product         3 files
solo-spec-qa              3 files
solo-spec-release         3 files
solo-spec-tdd             3 files
solo-spec-ux              3 files
```

判定：通过。

## 3. Metadata 检查

检查项：

- `SKILL.md` frontmatter 只包含 `name` 和 `description`。
- `name` 使用 lowercase hyphen-case。
- `description` 包含触发条件。
- `SKILL.md` 引用的 `references/*.md` 文件存在。
- `agents/openai.yaml` 包含 `display_name`、`short_description`、`default_prompt`。

结果：

```text
skill-metadata-smoke-ok (7)
```

判定：通过。

## 4. Section Mapping 检查

检查六个专家 contract 中的 Section Mapping 表，确认每个目标章节都存在于 `skills/solo-spec/assets/templates/solo/` 对应模板中。

结果：

```text
all-section-mappings-ok (152)
```

判定：通过。

## 5. 分发复制烟测

把 `skills/solo-spec*` 复制到全新测试目录：

```text
E:\test\solo-spec-kit-skill-smoke\.agents\skills
```

复制后发现 7 个 Skill：

```text
solo-spec
solo-spec-architecture
solo-spec-product
solo-spec-qa
solo-spec-release
solo-spec-tdd
solo-spec-ux
```

复制后每个 `SKILL.md` 的 `name` 和 `description` 均可读取。

判定：通过。

## 6. 已知限制

官方 `quick_validate.py` 当前仍不能运行，原因是本机 Python 环境缺少 `yaml` 模块：

```text
ModuleNotFoundError: No module named 'yaml'
```

已用本地脚本替代校验 frontmatter、引用文件、OpenAI metadata 和章节映射。该限制属于校验环境问题，不是 Skill 文件结构问题。

## 7. 结论

首批六个专家 Skill 已具备可选增强分发形态：

- 主入口仍是 `/solo`。
- 未安装专家 Skill 时，`solo-spec` 主流程不依赖专家。
- 安装专家 Skill 后，专家只输出 expert packet。
- 专家输出能映射到现有 SoloSpec 模板章节。
- 专家 Skill 不直接写文件、不推进状态机、不通过门禁。

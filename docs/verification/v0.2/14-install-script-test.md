# 项目级安装脚本验收报告

## 1. 测试结论

通过。

本轮新增并验证 `scripts/install-project-skills.ps1`，用于把 SoloSpec Skill 复制到目标项目的 `.agents/skills/`。

## 2. 脚本能力

| 能力 | 状态 |
|---|---|
| 基础安装 `solo-spec` | 已支持 |
| 增强安装 `solo-spec` 和六个专家 Skill | 已支持 |
| 默认不覆盖已有 Skill | 已支持 |
| 显式 `-Force` 替换已有 SoloSpec Skill | 已支持 |
| 只删除目标项目 `.agents/skills/` 下的目标 Skill | 已支持 |
| 目标项目不存在时停止执行 | 已支持 |

## 3. 命令

基础安装：

```powershell
.\scripts\install-project-skills.ps1 -ProjectPath E:\test\solo-spec-install-basic-20260705 -Mode basic
```

结果：

```text
Installed: solo-spec
```

增强安装：

```powershell
.\scripts\install-project-skills.ps1 -ProjectPath E:\test\solo-spec-install-enhanced-20260705 -Mode enhanced
```

结果：

```text
Installed: solo-spec, solo-spec-product, solo-spec-ux, solo-spec-architecture, solo-spec-tdd, solo-spec-qa, solo-spec-release
```

强制替换：

```powershell
.\scripts\install-project-skills.ps1 -ProjectPath E:\test\solo-spec-install-enhanced-20260705 -Mode enhanced -Force
```

结果：通过。

重复安装且不加 `-Force`：

```powershell
.\scripts\install-project-skills.ps1 -ProjectPath E:\test\solo-spec-install-enhanced-20260705 -Mode enhanced
```

结果：

```text
Target already exists: E:\test\solo-spec-install-enhanced-20260705\.agents\skills\solo-spec. Re-run with -Force to replace SoloSpec skills in this project.
```

不存在的项目路径：

```powershell
.\scripts\install-project-skills.ps1 -ProjectPath E:\test\solo-spec-missing-project-20260705 -Mode basic
```

结果：

```text
ProjectPath does not exist or is not a directory: E:\test\solo-spec-missing-project-20260705
```

## 4. 验收标准

| 验证项 | 预期 |
|---|---|
| 基础安装目录 | 只存在 `.agents/skills/solo-spec/` |
| 增强安装目录 | 存在 7 个 `solo-spec*` Skill |
| 重复安装且不加 `-Force` | 失败并提示目标已存在 |
| 加 `-Force` | 替换目标 Skill 后成功 |
| Skill 结构 | `SKILL.md`、frontmatter、引用文件和 `agents/openai.yaml` 校验通过 |

实际验收结果：全部通过。

## 5. 2026-07-06 复测

文档目录重组和入口文案统一后，重新用临时项目验证安装脚本。

| 验证项 | 结果 |
|---|---|
| `-Mode basic` | 通过，只安装 `solo-spec` |
| `-Mode enhanced` | 通过，安装主 Skill 和六个专家 Skill |
| 重复安装且不加 `-Force` | 通过，拒绝覆盖并提示目标已存在 |
| 先基础安装再用 `-Mode enhanced -Force` 覆盖 | 通过，目标变为增强安装 |
| 临时目录清理 | 通过 |

复测未修改仓库文件，也未产生残留临时项目。

## 6. 用户文档同步

`README.md` 和 `docs/public/01-user-guide.md` 已补充脚本安装方式，同时保留基础安装和增强安装说明。

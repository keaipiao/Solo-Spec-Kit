# v0.3 最终发布回归报告

日期：2026-07-06

## 1. 目标

发布前确认 v0.3 当前工作区满足以下要求：

- 多 Agent host 安装和 auto 探测通过。
- 专家契约为中文可读外层 + `machine` 可消费结构。
- 产品、研究、UX、架构、TDD、实现、QA、发布都是一等阶段。
- 高保真稿源文件为 HTML，不是 PNG。
- 根模板和 Skill 内置模板一致。
- 文档链接、JSON、Git diff 空白检查通过。

## 2. 命令清单

```powershell
git diff --check
.\scripts\install-project-skills.ps1 -ListHosts
```

附加回归：

- 显式 `-Host` 安装矩阵：7 个 host。
- `-Host auto` 探测矩阵：8 个目录场景。
- 旧 `-Tool zcode` 兼容。
- 覆盖保护和 `-Force`。
- 38 个模板文件 SHA256 镜像一致性。
- 阶段模板字段：`阶段研究与核验`、`专家增强记录`、门禁字段。
- 7 个 Skill metadata。
- 6 个专家 Skill v0.3 modes。
- Markdown 本地链接。
- JSON 解析。

## 3. 当前结果

| 检查 | 结果 |
|---|---|
| 安装矩阵 | 通过：显式 host 7 个，auto 8 个，legacy 1 个，guard 1 个 |
| 模板镜像 | 通过：38 个文件，差异数 0 |
| Skill metadata | 通过：7 个 Skill，6 个专家 |
| JSON 解析 | 通过 |
| Markdown 本地链接 | 通过 |
| `git diff --check` | 通过；仅有 Windows 换行符提示，无空白错误 |

## 4. 结论

最终本地回归通过。提交和推送后，本报告作为 v0.3 发布证据。

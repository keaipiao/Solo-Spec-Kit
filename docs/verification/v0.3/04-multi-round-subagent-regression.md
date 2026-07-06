# v0.3 多轮子代理回归报告

日期：2026-07-06

## 1. 目标

验证 v0.3 不只强化 UI/UX，而是覆盖多 Agent 安装、专家契约、四分支流程、全阶段模板和发布前质量门禁。

本报告记录两轮子代理只读回归和主流程修复结果。子代理只读取仓库和运行临时目录测试，不修改文件。

## 2. 第一轮回归

### 2.1 Host adapter

发现：

- `-Host auto` 曾把 `.claude/skills` 和 `.codex/skills` 误判为 `cursor`。
- `-Host auto` 曾漏检 `.trae/skills`。
- v0.3 host 安装报告只覆盖 `.cursor/skills` happy path。

修复：

- `scripts/install-project-skills.ps1` 改为按宿主专属目录探测。
- `.agents/skills` 保持为 `generic` fallback。
- `docs/verification/v0.3/01-host-adapter-install-test.md` 补充 8 个 auto 用例。

### 2.2 专家契约

发现：

- 当前有效文件残留 `Register generator artifacts.` 和 `External generator output`。
- 主 Skill 阶段映射缺少 `implementation` / `fix`。
- `docs/internal/06-expert-skills-architecture.md` 和 `docs/internal/08-expert-integration-strategy.md` 仍有 v0.2 当前化表述。

修复：

- 旧 `generator` 角色语义改为 `generate-assets` / generated output。
- 主 Skill、专家引用和接入策略均补齐 `implementation` / `fix` 映射。
- 06 / 08 文档改为 v0.3 当前契约。

### 2.3 全阶段模板

发现：

- 多数阶段模板缺少统一的专家状态落点。
- 产品、研究、UX、实现、发布/归档缺少明确门禁或核验结构。
- v0.3 模板回归报告覆盖不足。

修复：

- 项目级产品、UX、架构、发布模板增加 `阶段研究与核验`、`专家增强记录` 和门禁确认。
- 迭代和 bugfix 模板增加研究核验、专家增强记录、实现门禁和发布/归档门禁。
- 根模板与 Skill 内置模板同步。

## 3. 第二轮回归

### 3.1 Host adapter

结果：通过，`13/13`。

覆盖：

- 显式 `-Host`：`codex`、`cursor`、`claude-code`、`opencode`、`trae`、`zcode`、`generic`。
- `-Host auto`：`.cursor/skills`、`.claude/skills`、`.opencode/skills`、`.trae/skills`、`.zcode/skills`、`.codex/skills`、`.agents/skills`、无预置目录。
- 旧 `-Tool zcode`。
- `-ListHosts`。
- 覆盖保护和 `-Force`。

说明：Trae 仍保持 `needs-real-ide-verification`，脚本路径通过不等于真实 IDE 加载已 confirmed。

### 3.2 专家契约

第二轮发现：

- `docs/internal/08-expert-integration-strategy.md` 的阶段表漏列 `implementation` / `fix`。

修复：

- 接入策略阶段表补充 `implementation` / `fix` 到 `solo-spec-tdd` + `solo-spec-architecture`。

复查结果：

- 当前有效文件不再命中旧角色语义。
- 主 Skill、专家引用和接入策略均包含 `implementation` / `fix` 映射。

### 3.3 全阶段模板

第二轮发现：

- bugfix `plan.md` 缺少 `阶段研究与核验` 和 `专家增强记录`。
- bugfix `archive.md` 缺少 `专家增强记录`。

修复：

- bugfix `plan.md` 补齐研究核验和专家增强记录。
- bugfix `archive.md` 补齐专家增强记录和发布/归档门禁。
- 根模板与 Skill 内置模板同步。

复查结果：

- `templates/solo` 与 `skills/solo-spec/assets/templates/solo` 均为 38 个文件。
- 两侧 SHA256 差异数为 0。
- 高保真稿仍定义为 HTML，PNG 只用于截图/留证语境。

## 4. 结论

多轮子代理回归已完成。第一轮发现的问题均已修复；第二轮剩余问题也已修复并通过本地针对性复查。

最终发布前仍需执行 `docs/verification/v0.3/05-final-release-regression.md` 中的完整本地命令。

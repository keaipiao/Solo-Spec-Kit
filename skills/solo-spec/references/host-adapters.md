# Host Adapters

SoloSpec v0.3 supports multiple Agent hosts through a registry instead of hard-coded tool names.

Use this file when installing, detecting, or reporting SoloSpec skills in a user project.

## Supported Hosts

| Host | Status | Project skill roots | Notes |
|---|---|---|---|
| `codex` | confirmed | `.agents/skills`, `.codex/skills` | Prefer `.agents/skills` for project installs. |
| `cursor` | confirmed | `.cursor/skills`, `.agents/skills`, `.claude/skills`, `.codex/skills` | Cursor can load multiple compatible skill roots. |
| `claude-code` | confirmed | `.claude/skills`, `.agents/skills` | Claude Code skills may also expose slash invocation. |
| `opencode` | confirmed | `.opencode/skills`, `.agents/skills`, `.claude/skills` | OpenCode also supports project rules through `AGENTS.md`. |
| `trae` | needs-real-ide-verification | `.trae/skills`, `.agents/skills` | Treat paths as provisional until verified in Trae IDE. |
| `zcode` | locally-observed | `.zcode/skills`, `.agents/skills` | Verified from local user testing, not a public standard. |
| `generic` | confirmed | `.agents/skills` | Fallback for hosts that support Agent Skills-compatible project roots. |

## Detection Rules

When checking whether a mapped expert is installed:

1. Check the parent directory of the running `solo-spec` skill first. Enhanced installs usually place experts as siblings.
2. Check project skill roots from the active host adapter.
3. If the expert is not found there, check all compatible project skill roots from the registry, not only the currently guessed host.
4. Treat an expert as installed only when `<skills-root>/<expert-name>/SKILL.md` exists.
5. Do not report a mapped expert as missing until the relevant roots have been checked.
6. When reporting unavailable, include the checked roots in the `专家增强` block so false negatives can be diagnosed.

Minimum fallback roots for unknown or partially supported hosts:

```text
.agents/skills
.codex/skills
.cursor/skills
.claude/skills
.opencode/skills
.trae/skills
.zcode/skills
```

Host-specific notes:

- Trae: check `.trae/skills` and `.agents/skills`. Keep Trae status as `needs-real-ide-verification` until confirmed in the real IDE, but filesystem presence is enough to use an installed expert.
- zcode: check `.zcode/skills` and `.agents/skills`. Do this even if the host registry does not expose those experts.

When filesystem access is available, use filesystem checks instead of guessing from the host UI. For example, in a Windows project:

```powershell
Test-Path .trae\skills\solo-spec-qa\SKILL.md
Test-Path .zcode\skills\solo-spec-qa\SKILL.md
Test-Path .agents\skills\solo-spec-qa\SKILL.md
```

Do not enumerate every installed skill in user-facing output. Report only the current-stage mapped SoloSpec expert and any user-named external skill or tool.

## Install Rules

Installers should:

- Accept a host name, an `auto` mode, and a `generic` fallback.
- Install to the first project skill root for the selected host unless the user explicitly requests another root.
- Keep `zcode` and `trae` statuses visible because they are not confirmed in the same way as `codex`, `cursor`, `claude-code`, `opencode`, and `generic`.
- Preserve backwards compatibility for old install commands when possible.

## Rule Files

When SoloSpec later writes project-level agent guidance:

- Prefer `AGENTS.md` as the cross-host rule file.
- Add host-specific rule files only when the host expects them and the user confirms.
- Never silently overwrite existing project rules outside a SoloSpec managed block.

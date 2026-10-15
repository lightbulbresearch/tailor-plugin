# Developing the Tailor.ai plugin

The plugin lives in [`tailor-ai/`](tailor-ai/). That folder is both a Claude plugin and an
OpenAI (ChatGPT and Codex) plugin:

| File in `tailor-ai/` | Used by |
| --- | --- |
| `.claude-plugin/plugin.json`, `.mcp.json` | Claude (claude.ai, Cowork, Claude Code) |
| `plugin.json`, `mcp.json` | OpenAI, in the Agent Plugins format |
| `skills/`, `assets/`, `README.md`, `LICENSE` | Both |

Build tooling stays outside the plugin folder, so nothing in the plugin is a script: the
directory's validator holds a plugin for review when a script in it refers to its images.

The MCP server itself lives in the private `tailor-ai` repository (`tailor.ai.mcp/`). Its
connector listing text is in `tailor.ai.mcp/LISTING.md` there; keep it in step with the
descriptions here.

## Check and build

Run from the repository root:

```sh
scripts/check.sh                   # manifests agree, OpenAI length limits, skill front matter, README length
claude plugin validate tailor-ai   # Claude's own manifest check
scripts/build-openai-zip.sh        # → dist/<name>-<version>.zip, for platform.openai.com/plugins
```

## Release

1. Raise `version` in both `plugin.json` files (`scripts/check.sh` fails if they differ).
2. Merge to `main`. Anthropic's directory follows `main` (plugin path `tailor-ai`) and
   scans each new commit.
3. Build the ZIP and upload it as a new version in OpenAI's plugin dashboard.

## Try it locally

- Claude Code: `claude --plugin-dir tailor-ai`
- claude.ai: zip the `tailor-ai` folder and use **Customize → Plugins → Add → Upload plugin**.

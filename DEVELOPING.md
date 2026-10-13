# Developing the Tailor plugin

This one folder is both a Claude plugin and an OpenAI (ChatGPT and Codex) plugin:

| File | Used by |
| --- | --- |
| `.claude-plugin/plugin.json`, `.mcp.json` | Claude (claude.ai, Cowork, Claude Code) |
| `plugin.json`, `mcp.json` | OpenAI, in the Agent Plugins format |
| `skills/`, `assets/`, `README.md`, `LICENSE` | Both |

The MCP server itself lives in the private `tailor-ai` repository (`tailor.ai.mcp/`). Its
connector listing text is in `tailor.ai.mcp/LISTING.md` there; keep it in step with the
descriptions here.

## Check and build

```sh
scripts/check.sh              # manifests agree, OpenAI length limits, skill front matter, README length
claude plugin validate .      # Claude's own manifest check
scripts/build-openai-zip.sh   # → dist/<name>-<version>.zip, for platform.openai.com/plugins
```

## Release

1. Raise `version` in both `plugin.json` files (`scripts/check.sh` fails if they differ).
2. Merge to `main`. Anthropic's directory follows `main` and scans each new commit.
3. Build the ZIP and upload it as a new version in OpenAI's plugin dashboard.

## Try it locally

- Claude Code: `claude --plugin-dir .`
- claude.ai: zip the folder and use **Customize → Plugins → Add → Upload plugin**.

# Developing the Tailor.ai plugin

The Claude plugin lives in [`tailor-ai/`](tailor-ai/); the OpenAI (ChatGPT and Codex)
plugin is assembled from it plus [`openai/`](openai/):

| Path | Used by |
| --- | --- |
| `tailor-ai/.claude-plugin/plugin.json`, `tailor-ai/.mcp.json` | Claude (claude.ai, Cowork, Claude Code) |
| `openai/plugin.json`, `openai/mcp.json`, `openai/assets/` | OpenAI, in the Agent Plugins format |
| `tailor-ai/skills/`, `tailor-ai/README.md`, `tailor-ai/LICENSE` | Both |

`tailor-ai/` holds only what Claude reads, so Anthropic's directory scan comes back with
no notes: no scripts, no images, no second manifest, and no listing-only fields (`icon`,
`documentationUrl`, `supportUrl`, `privacyPolicyUrl`, `termsOfServiceUrl`) in the Claude
manifest. Set the icon and those links in the directory's submission form (Listing tab)
instead. `scripts/check.sh` fails if any of them comes back.

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

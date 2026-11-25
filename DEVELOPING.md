# Developing the Tailor.ai plugin

The Claude plugin lives in [`tailor-ai/`](tailor-ai/); the OpenAI (ChatGPT and Codex)
plugin is assembled from it plus [`openai/`](openai/):

| Path | Used by |
| --- | --- |
| `tailor-ai/.claude-plugin/plugin.json`, `tailor-ai/.mcp.json` | Claude (claude.ai, Cowork, Claude Code) |
| `openai/plugin.json`, `openai/mcp.json`, `openai/assets/` | OpenAI, in the Agent Plugins format |
| `tailor-ai/skills/`, `tailor-ai/README.md`, `tailor-ai/LICENSE` | Both |

`tailor-ai/` holds only what Claude reads, so Anthropic's directory scan stays quiet: no
scripts, no second manifest, and no listing-only fields (`icon`, `documentationUrl`,
`supportUrl`, `privacyPolicyUrl`, `termsOfServiceUrl`) in the Claude manifest. The
directory finds the icon at `tailor-ai/.claude-plugin/icon.png` (a copy of
`openai/assets/logo.png`) and the privacy policy from the Markdown link on the README's
privacy line; set the other links in the submission form (Listing tab).
`scripts/check.sh` fails if any of this drifts.

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

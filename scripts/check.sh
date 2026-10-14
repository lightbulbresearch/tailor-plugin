#!/bin/sh
# Checks the two manifests agree and the listing text fits OpenAI's limits.
# Run from the repository root: scripts/check.sh
set -eu

python3 - <<'EOF'
import json, re, sys
from pathlib import Path

errors = []
claude = json.loads(Path(".claude-plugin/plugin.json").read_text())
openai = json.loads(Path("plugin.json").read_text())
json.loads(Path(".mcp.json").read_text())
mcp = json.loads(Path("mcp.json").read_text())

for key in ("name", "version", "description"):
    if claude.get(key) != openai.get(key):
        errors.append(f"{key} differs between .claude-plugin/plugin.json and plugin.json")

claude_url = json.loads(Path(".mcp.json").read_text())["mcpServers"]["Tailor.ai"]["url"]
if mcp["mcpServers"]["Tailor.ai"]["url"] != claude_url:
    errors.append("MCP server URL differs between .mcp.json and mcp.json")

ui = openai["extensions"]["com.openai"]["interface"]
for key, limit in (("displayName", 30), ("shortDescription", 30), ("longDescription", 4000)):
    if len(ui[key]) > limit:
        errors.append(f"interface.{key} is {len(ui[key])} characters (max {limit})")
for prompt in ui.get("defaultPrompt", []):
    if len(prompt) > 128:
        errors.append(f"defaultPrompt over 128 characters: {prompt!r}")
for key in ("composerIcon", "logo"):
    if not Path(ui[key]).is_file():
        errors.append(f"interface.{key} file missing: {ui[key]}")

cases = openai["extensions"]["com.openai"]["review"]["test_cases"]
if len(cases["positive"]) != 5 or len(cases["negative"]) != 3:
    errors.append("OpenAI review needs exactly 5 positive and 3 negative test cases")

for skill in sorted(Path("skills").glob("*/SKILL.md")):
    front = re.match(r"---\n(.*?)\n---\n", skill.read_text(), re.S)
    fields = dict(line.split(": ", 1) for line in front.group(1).splitlines()) if front else {}
    if fields.get("name") != skill.parent.name or not fields.get("description"):
        errors.append(f"{skill}: front matter needs name = folder name and a description")

words = len(re.sub(r"```.*?```", "", Path("README.md").read_text(), flags=re.S).split())
if words < 40:
    errors.append(f"README has {words} words (Anthropic needs 40+)")

for error in errors:
    print(f"✗ {error}", file=sys.stderr)
if errors:
    sys.exit(1)
print(f"✔ manifests agree (v{claude['version']}), listing fits, {len(list(Path('skills').glob('*/SKILL.md')))} skills")
EOF

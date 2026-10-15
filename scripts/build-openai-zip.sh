#!/bin/sh
# Builds the ZIP to upload at platform.openai.com/plugins: the Agent Plugins
# manifest, mcp.json, skills and assets, without the Claude-only files.
# Run from the repository root: scripts/build-openai-zip.sh
set -eu

root="$(cd "$(dirname "$0")/.." && pwd)"
"$root/scripts/check.sh"
cd "$root/tailor-ai"
version=$(python3 -c 'import json; print(json.load(open("plugin.json"))["version"])')
name=$(python3 -c 'import json; print(json.load(open("plugin.json"))["name"])')
out="$root/dist/$name-$version.zip"
mkdir -p "$root/dist"
rm -f "$out"
zip -qrX "$out" plugin.json mcp.json skills assets README.md LICENSE -x '*.DS_Store'
echo "→ dist/$name-$version.zip"
unzip -l "$out" | tail -n +4 | sed '$d' | sed '$d' | awk '{print "  " $4}'

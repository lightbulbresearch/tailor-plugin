#!/bin/sh
# Builds the ZIP to upload at platform.openai.com/plugins: the Agent Plugins
# manifest, mcp.json and assets from openai/, plus the skills, README and
# LICENSE from tailor-ai/ (without the Claude-only files).
# Run from the repository root: scripts/build-openai-zip.sh
set -eu

root="$(cd "$(dirname "$0")/.." && pwd)"
"$root/scripts/check.sh"
version=$(python3 -c 'import json,sys; print(json.load(open(sys.argv[1]))["version"])' "$root/openai/plugin.json")
name=$(python3 -c 'import json,sys; print(json.load(open(sys.argv[1]))["name"])' "$root/openai/plugin.json")
out="$root/dist/$name-$version.zip"
stage="$(mktemp -d)"
trap 'rm -rf "$stage"' EXIT
cp -R "$root/openai/plugin.json" "$root/openai/mcp.json" "$root/openai/assets" "$stage/"
cp -R "$root/tailor-ai/skills" "$root/tailor-ai/README.md" "$root/tailor-ai/LICENSE" "$stage/"
mkdir -p "$root/dist"
rm -f "$out"
(cd "$stage" && zip -qrX "$out" plugin.json mcp.json skills assets README.md LICENSE -x '*.DS_Store')
echo "→ dist/$name-$version.zip"
unzip -l "$out" | tail -n +4 | sed '$d' | sed '$d' | awk '{print "  " $4}'

#!/usr/bin/env bash
set -euo pipefail

# Setup script for GitHub Copilot CLI with this repo's agent harness.
# Run once after cloning the repo to configure MCP servers and verify
# that the symlinked skills directory resolves correctly.
#
# Prerequisites:
#   - Node.js 22+ (for Copilot CLI and npx)
#   - GitHub Copilot CLI installed: npm install -g @github/copilot
#
# Usage:
#   bash scripts/setup-copilot.sh

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

echo "=== Copilot CLI setup for agentify ==="
echo ""

# 1. Verify symlink
echo "[1/4] Checking .github/skills symlink..."
if [ -L "$REPO_ROOT/.github/skills" ] && [ -d "$REPO_ROOT/.github/skills" ]; then
  SKILL_COUNT=$(find -L "$REPO_ROOT/.github/skills" -name "SKILL.md" -type f | wc -l)
  echo "  ✓ Symlink OK — $SKILL_COUNT skills found"
else
  echo "  ✗ Symlink missing or broken. Creating it..."
  mkdir -p "$REPO_ROOT/.github"
  ln -sf ../.cursor/skills "$REPO_ROOT/.github/skills"
  if [ -d "$REPO_ROOT/.github/skills" ]; then
    echo "  ✓ Symlink created"
  else
    echo "  ✗ Failed to create symlink. Check that .cursor/skills/ exists."
    exit 1
  fi
fi

# 2. Verify Copilot CLI is installed
echo ""
echo "[2/4] Checking Copilot CLI..."
if command -v copilot &>/dev/null; then
  echo "  ✓ Copilot CLI found: $(command -v copilot)"
else
  echo "  ✗ Copilot CLI not found."
  echo "    Install it with: npm install -g @github/copilot"
  echo "    Requires Node.js 22+ and a GitHub Copilot subscription."
fi

# 3. Check .github/mcp.json
echo ""
echo "[3/4] Checking MCP configuration..."
if [ -f "$REPO_ROOT/.github/mcp.json" ]; then
  echo "  ✓ .github/mcp.json exists (Linear MCP via OAuth)"
  echo "    Copilot CLI will auto-load this when run from the repo root."
  echo "    On first use, you'll be prompted to authenticate with Linear via OAuth."
else
  echo "  ✗ .github/mcp.json not found."
fi

# 4. Verify AGENTS.md and copilot-instructions.md
echo ""
echo "[4/4] Checking agent instruction files..."
[ -f "$REPO_ROOT/AGENTS.md" ] && echo "  ✓ AGENTS.md present" || echo "  ✗ AGENTS.md missing"
[ -f "$REPO_ROOT/.github/copilot-instructions.md" ] && echo "  ✓ .github/copilot-instructions.md present" || echo "  ✗ .github/copilot-instructions.md missing"

echo ""
echo "=== Setup complete ==="
echo ""
echo "To start working:"
echo "  cd $REPO_ROOT"
echo "  copilot"
echo ""
echo "On first run with Linear MCP, you'll be prompted to authenticate via OAuth."
echo "The GitHub MCP server is built into Copilot CLI — no setup needed."

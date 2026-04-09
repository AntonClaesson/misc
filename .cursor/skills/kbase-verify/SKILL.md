---
name: kbase-verify
description: Visually verify kbase wiki pages in Obsidian using computer use. Use after ingesting content and before opening a PR to confirm Mermaid diagrams, wikilinks, LaTeX, and page structure render correctly.
---

# kbase Visual Verification

Use this skill after ingesting content into the kbase wiki and before opening a PR. It launches Obsidian on the Cloud Agent's VNC desktop and visually checks that wiki pages render correctly.

## Prerequisites

- The VNC desktop must be running (DISPLAY=:1). Cloud Agent VMs have this by default.
- Obsidian must be installed. If not, install it:
  ```bash
  cd /tmp && wget -q "https://github.com/obsidianmd/obsidian-releases/releases/download/v1.12.7/obsidian_1.12.7_amd64.deb" -O obsidian.deb && sudo dpkg -i obsidian.deb
  ```
- `scrot` must be installed for screenshots. If not: `sudo apt-get update -qq && sudo apt-get install -y scrot`
- `xdotool` is needed for window interaction (pre-installed on Cloud Agent VMs).

## Step 1: Ensure Obsidian Vault Config Exists

Check that `projects/kbase/.obsidian/` has a minimal config. If not, create one:

```bash
mkdir -p /workspace/projects/kbase/.obsidian
```

Create `projects/kbase/.obsidian/app.json`:
```json
{
  "alwaysUpdateLinks": true,
  "showFrontmatter": false,
  "defaultViewMode": "preview"
}
```

Create `projects/kbase/.obsidian/core-plugins-migration.json`:
```json
{
  "file-explorer": true,
  "global-search": true,
  "switcher": true,
  "graph": true,
  "backlink": true,
  "outgoing-link": true,
  "tag-pane": true,
  "page-preview": true,
  "command-palette": true,
  "markdown-importer": true,
  "word-count": true,
  "outline": true
}
```

Register the vault globally:
```bash
mkdir -p ~/.config/obsidian
cat > ~/.config/obsidian/obsidian.json << 'EOF'
{
  "vaults": {
    "kbase": {
      "path": "/workspace/projects/kbase",
      "ts": 1712600000000,
      "open": true
    }
  },
  "updateDisabled": true,
  "frame": "native"
}
EOF
```

## Step 2: Launch Obsidian

```bash
DISPLAY=:1 obsidian --no-sandbox --disable-gpu &
sleep 5
```

Verify it's running:
```bash
DISPLAY=:1 xdotool search --name "Obsidian"
```

If no window IDs returned, Obsidian didn't start. Check for errors and retry.

## Step 3: Navigate to Pages and Take Screenshots

Use the quick switcher (Ctrl+O) to open pages:

```bash
DISPLAY=:1 xdotool key ctrl+o
sleep 0.5
DISPLAY=:1 xdotool type --delay 30 "<page name>"
sleep 0.5
DISPLAY=:1 xdotool key Return
sleep 2
```

Screenshot the page:
```bash
mkdir -p /opt/cursor/artifacts/screenshots
DISPLAY=:1 scrot /opt/cursor/artifacts/screenshots/<descriptive-name>.png
```

To scroll within a page, use Ctrl+Home / Ctrl+End or arrow keys after clicking in the content area.

## Step 4: What to Verify

For each new or updated wiki page, check:

1. **Wikilinks** render as clickable links (colored text), not raw `[[...]]` brackets.
2. **Mermaid diagrams** render as visual graphics, not code blocks.
3. **LaTeX math** renders as formatted equations, not raw `$...$` text.
4. **Tables** render as formatted tables, not pipe characters.
5. **Frontmatter** displays as Properties panel (or is hidden), not raw YAML.
6. **Headings and structure** look correct.

## Step 5: Check Graph View

Open the graph view with Ctrl+G:

```bash
DISPLAY=:1 xdotool key ctrl+g
sleep 2
DISPLAY=:1 scrot /opt/cursor/artifacts/screenshots/graph-view.png
```

Verify:
- New pages appear as nodes in the graph.
- Connections (edges) exist between related pages.
- No isolated orphan nodes that should be connected.

## Step 6: Fix Issues

If anything renders incorrectly:
1. Close Obsidian or switch away.
2. Fix the markdown source files.
3. Relaunch / refresh Obsidian and re-verify.

## Step 7: Attach Evidence to PR

Reference key screenshots in the PR description using artifact paths:

```markdown
<img alt="Wiki page rendering" src="/opt/cursor/artifacts/screenshots/page-name.png" />
<img alt="Graph view" src="/opt/cursor/artifacts/screenshots/graph-view.png" />
```

## Notes

- Obsidian is an Electron app. Always use `--no-sandbox --disable-gpu` flags on Cloud Agent VMs.
- The `.obsidian/` config directory is `.gitignore`d — it's local agent state, not committed.
- First launch may show onboarding dialogs. Dismiss them with Escape or by clicking through.
- If Obsidian crashes (zombie processes), kill and relaunch: `pkill -9 obsidian && sleep 1 && DISPLAY=:1 obsidian --no-sandbox --disable-gpu &`

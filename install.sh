#!/bin/sh
# Gauntlet one-line install for macOS and Linux:
#   curl -fsSL https://raw.githubusercontent.com/NawafSheikh/gauntlet-plugin/main/install.sh | sh
#
# Adds the Gauntlet plugin to every AI coding agent found on this computer
# (Claude Code, Codex), starts the local Gauntlet agent, and tells you what
# to do on your phone or watch. Nothing is sent anywhere but GitHub (to fetch
# the plugin); Gauntlet has no servers.
set -eu
REPO=NawafSheikh/gauntlet-plugin
added=""

if command -v claude >/dev/null 2>&1; then
  echo "Claude Code found: adding the Gauntlet plugin..."
  claude plugin marketplace add "$REPO" >/dev/null
  claude plugin install gauntlet@gauntlet >/dev/null
  added="Claude Code"
fi
if command -v codex >/dev/null 2>&1; then
  echo "Codex found: adding the Gauntlet plugin..."
  codex plugin marketplace add "$REPO" >/dev/null
  codex plugin add gauntlet@gauntlet >/dev/null
  added="${added:+$added, }Codex"
fi
if [ -z "$added" ]; then
  echo "No supported AI agent found. Install Claude Code (https://claude.com/claude-code) or Codex first, then run this again."
  exit 1
fi
echo "Added to: $added"

# The newest installed copy of the plugin's launcher, which picks this OS and CPU.
launcher=$(ls -t "$HOME"/.claude/plugins/cache/gauntlet/gauntlet/*/native/gauntlet 2>/dev/null | head -n 1 || true)
if [ -n "$launcher" ]; then
  # Start it now rather than at the next session, so the phone finds this computer right away.
  nohup "$launcher" serve >/dev/null 2>&1 &
  echo "The Gauntlet agent is running."
else
  echo "The agent starts with your next Claude Code or Codex session."
fi
case "$added" in *Codex*) echo "In Codex, run /hooks once and trust the Gauntlet hooks." ;; esac
echo
echo "Next: open Gauntlet on your phone or watch (same Wi-Fi)."
echo "This computer opens a page in your browser: check the code matches and click Allow."

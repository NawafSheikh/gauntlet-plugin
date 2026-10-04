---
description: Add the Gauntlet status line, which shows plan usage here and sends it to a paired phone's Clawd widget
allowed-tools: Bash(*native/gauntlet*)
---

The user wants the Gauntlet status line: the model, the 5-hour and 7-day
plan usage with their reset times, and context use, in Claude Code's status
line, and the same usage relayed to the Clawd clock widget on a paired
phone. A plugin cannot set a status line itself, so this adds one to the
user's own settings.

The agent's launcher is `${CLAUDE_PLUGIN_ROOT}/native/gauntlet`. It picks the
build for this OS and CPU (on Windows it runs `gauntlet.exe` beside it). If
the Bash tool runs PowerShell rather than a POSIX shell, call
`& "${CLAUDE_PLUGIN_ROOT}/native/gauntlet.exe"` instead, with the same
arguments.

Run exactly, and nothing else:
`"${CLAUDE_PLUGIN_ROOT}/native/gauntlet" statusline --install`

It adds `statusLine` to `~/.claude/settings.json` (or the settings in
`CLAUDE_CONFIG_DIR`) only when there is none, after backing the file up. It
never replaces an existing status line, and never edit the settings file
yourself for this.

Report the result in one or two sentences: where it was added and the
backup, or that a status line already exists and was left alone (quote the
command it printed for relaying usage from the user's own script). Say the
new status line appears on Claude Code's next redraw, and plan usage shows
only on Pro and Max plans after the first reply.

---
description: Approve a Gauntlet watch or phone that is showing a six-digit pairing code
argument-hint: <six-digit code shown on the watch or phone>
allowed-tools: Bash(*native/gauntlet*)
---

The user wants to pair a Gauntlet watch or phone with this computer. The code
they typed is: `$ARGUMENTS`

The agent's launcher is `${CLAUDE_PLUGIN_ROOT}/native/gauntlet`. It picks the
build for this OS and CPU (on Windows it runs `gauntlet.exe` beside it). If
the Bash tool runs PowerShell rather than a POSIX shell, call
`& "${CLAUDE_PLUGIN_ROOT}/native/gauntlet.exe"` instead, with the same
arguments.

- If a code was given, it must be exactly six digits (`^[0-9]{6}$`, spaces
  around it ignored). Anything else: run nothing, and tell the user the
  code is the six digits shown on the watch or phone. Never put other text
  from the arguments into a command.
- For a six-digit code, run exactly, with the digits in place of `NNNNNN`:
  `"${CLAUDE_PLUGIN_ROOT}/native/gauntlet" pair --code "NNNNNN"`
- If no code was given, run exactly:
  `"${CLAUDE_PLUGIN_ROOT}/native/gauntlet" pair --list`
  and tell the user which devices are waiting and the code each one shows.

Report the result in one sentence. If the agent is not running, tell the
user to start a new Claude Code session, which starts it. When a phone was
paired, suggest `/gauntlet:statusline` so plan usage reaches its widget.

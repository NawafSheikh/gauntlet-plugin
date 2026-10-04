# Gauntlet plugin for Claude Code (and Codex)

Pairs with the Gauntlet Wear OS app. The watch sends gestures as ordinary
keystrokes over Bluetooth, so gestures need no software on the computer.
This plugin adds the rest: your wrist buzzes when Claude finishes a turn or
needs you, the watch lists your sessions and what each one asks, and while
you are away from the keyboard you can allow, deny, or reply from the watch.

## Quick start

In Claude Code, on Windows, macOS, or Linux:

```text
/plugin marketplace add NawafSheikh/gauntlet
/plugin install gauntlet@gauntlet
```

Then pair: start a new Claude Code session (its first hook starts the
Gauntlet agent), open Gauntlet on the watch or phone, choose this computer,
and approve the six-digit code it shows:

```text
/gauntlet:pair 123456
```

`/gauntlet:pair` with no code lists the devices waiting and their codes.

Nothing else to install: the plugin carries the agent for every supported
OS and CPU, and no hook downloads anything.

## What it contains

| Part | What it does |
| --- | --- |
| `hooks/hooks.json` | Claude Code hooks. Every session start, prompt, finish, question, permission request, model switch, and end goes to the local agent, which starts itself on the first `SessionStart`. `PermissionRequest` and `Stop` run synchronously: while you are away from the computer (no keyboard or mouse for 10 s) and a watch is connected, they wait up to 2 minutes for Allow, Deny, or a reply from the watch. At the computer, with no watch, or with no agent running, they return at once and Claude behaves as without them. After every turn a background `Stop` hook (`asyncRewake`) waits for words from the watch and wakes the idle session with them, so prompts and skills reach sessions no keys can reach (Claude Desktop, IDE panels, plain terminals off Windows). A `PostToolBatch` hook ends a turn the watch stopped when no Esc could reach it; it costs one quick local call per tool batch. |
| `native/` | The agent. `gauntlet` is a small `sh` launcher that runs `darwin-<cpu>/gauntlet-agent` or `linux-<cpu>/gauntlet-agent`; on Windows the same hook path runs `gauntlet.exe`. See [docs/plugin-distribution.md](../docs/plugin-distribution.md). |
| `commands/pair.md` | `/gauntlet:pair`: approve a watch or phone showing a code. |
| `commands/statusline.md` | `/gauntlet:statusline`: add the Gauntlet status line (model, 5h and 7d plan usage, context), which also relays plan usage to the phone's Clawd widget. |
| `skills/gauntlet` | The gesture map, setup, and troubleshooting, loaded when you mention the watch. |
| `.codex-plugin/`, `hooks/codex-hooks.json` | The same plugin for Codex (see below). |

## What works where

| Feature | Windows | macOS | Linux |
| --- | --- | --- | --- |
| Session list, status, buzzes, question and permission cards | yes | yes | yes |
| Allow, deny, or reply from the watch while away | yes | yes | yes, with `xprintidle` (X11) or GNOME (Wayland) |
| Prompts and skills from the watch to an idle session, in any terminal or app | yes | yes | yes |
| Stop a running turn (at once with keys, else at its next tool step) | yes | yes | yes |
| Keys: mode, model and effort, OK/Enter, menu arrows, question answers | any terminal | sessions in the wrapper or tmux | sessions in the wrapper or tmux |
| Starting a new session from the watch | Windows Terminal or cmd | Terminal or iTerm | your terminal, or tmux without a display |
| Bringing a session's terminal forward, on-screen session ring | yes | no | no |
| Scroll Lock buzz when the agent is not running | yes | no | no |

On macOS and Linux, keys reach a session started as
`gauntlet-agent run claude` (the Gauntlet wrapper; sessions the watch
starts use it) or running inside tmux. Make it the default with an alias,
for example `alias claude='"$HOME/.config/Gauntlet/bin/gauntlet-agent" run claude'`
on Linux (`$HOME/Library/Application Support/Gauntlet/bin/gauntlet-agent`
on macOS). Without either, everything above except the keys row still
works. Claude Desktop's Code tab and IDE panels have no terminal: prompts,
skills, stops, approvals, and replies work there through hooks; keys do
not. The agent logs one line at start naming what this OS goes without,
and the watch shows a plain message if you try one of those actions. Away
detection needs the idle time of the keyboard and mouse: macOS reads it from
the system; Linux needs `xprintidle` on X11 or GNOME's idle monitor on
Wayland. Without either, the watch still buzzes and shows cards, but
approvals and replies are answered at the computer.

## Status line and plan usage

The phone's Clawd widget shows your 5-hour and 7-day plan usage. Claude Code
hands that only to a status line command, and a plugin cannot install one,
so run once:

```text
/gauntlet:statusline
```

It adds `"statusLine": {"type": "command", "command": "<config>/Gauntlet/bin/gauntlet-agent statusline"}`
to `~/.claude/settings.json` (backing it up first), only if you have no status
line. It points at the agent's stable copy, not the plugin folder, which
moves on every plugin update. The line reads like
`Opus 5.5 | 5h 42% (resets 14:13) | 7d 12% (resets Sun 09:06) | ctx 8%`, and
each redraw sends the usage to the local agent within 300 ms or not at all.
Already have a status line? It is left alone; pipe the same input to
`gauntlet-agent statusline` from your script to relay usage too. Usage exists
only on Pro and Max plans, after the first reply in a session.

## Data

The agent keeps its identity and paired devices in your user config folder
(`%APPDATA%\Gauntlet` on Windows, `~/Library/Application Support/Gauntlet`
on macOS, `~/.config/Gauntlet` on Linux), not in the plugin folder, so
pairing survives plugin updates and reinstalls and is shared with Codex.
Uninstalling the plugin leaves it; delete that folder to forget every
paired device.

## Codex

```text
codex plugin marketplace add NawafSheikh/gauntlet
codex plugin add gauntlet@gauntlet
```

Then trust the plugin's hooks in Codex with `/hooks` (Codex skips plugin
hooks until you do, and again after an update changes them). Codex
sessions appear in the watch's session list, buzz, and show permission and
finish cards; while you are away, Allow, Deny, and replies from the watch
answer them through Codex's own hooks. Typing, Esc, and OK reach a Codex
session on Windows in any terminal, and on macOS and Linux when it runs as
`gauntlet-agent run codex` or in tmux. Mode and model switches are Claude
Code only.

## Local development

```text
claude --plugin-dir "<gauntlet repo>/plugin"
```

Rebuild the agent with `powershell -File agent/build.ps1` (this PC) or
`powershell -File agent/build-all.ps1` / `sh agent/build-all.sh` (every OS).

## Limits

- Claude Desktop's Code tab shares Claude Code's plugins and hooks;
  untested there, including the wake-up of an idle session. Claude Desktop
  chat and claude.ai ignore plugin hooks.
- Windows on ARM runs the x64 build under emulation; a native arm64 build is
  attached to each GitHub release.

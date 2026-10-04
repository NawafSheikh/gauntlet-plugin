---
description: "Teach or tune a watch gesture with Claude. Record samples on the watch, measure them, and improve detection."
argument-hint: "the gesture, for example snap, or my pinch is missed"
allowed-tools: Bash(*native/gauntlet*)
---

The user wants to train a Gauntlet watch gesture. They said: `$ARGUMENTS`

The agent's launcher is `${CLAUDE_PLUGIN_ROOT}/native/gauntlet` (on Windows
in PowerShell: `& "${CLAUDE_PLUGIN_ROOT}/native/gauntlet.exe"`).

**If this session is inside the Gauntlet source repository** (it has
`core/src/main/kotlin/com/gauntlet/core/gesture/` and
`.claude/skills/gesture-tuning/SKILL.md`): load the `gesture-tuning` skill
and follow it. It records evidence, tunes the detectors one change at a time,
and ships only changes that beat the current settings on recorded data.

**Anywhere else** (a user with the published app):
1. Open the live gesture page, which shows each detection as it happens and
   records labelled samples on this computer only:
   `"${CLAUDE_PLUGIN_ROOT}/native/gauntlet" gestures --print`
   Give the user the link it prints (it opens on this PC).
2. Ask them to open Gauntlet on the watch, then perform the gesture 10 times,
   a second apart, and label each one on the page. Then 30 seconds of normal
   movement (typing, walking) with no gesture, labelled "none".
3. Summarise from the page: how many were caught, how many were missed, and
   any false detections in the "none" stretch.
4. Explain honestly what can change today: detection is tuned in the app's
   source by the developer; the recordings and summary are what to send them
   (the user chooses whether to share anything; recordings stay on this PC).

Recordings are personal biometric data: never upload, copy, or commit them.

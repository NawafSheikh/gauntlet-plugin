---
description: Change how Gauntlet looks on your phone and watch (widget, wallpaper, watch face) by describing it
argument-hint: what you want, e.g. "calmer, darker wallpaper" or "transparent widget"
allowed-tools: Bash(*native/gauntlet*)
---

The user wants to change how Gauntlet looks. They said: `$ARGUMENTS`

The agent's launcher is `${CLAUDE_PLUGIN_ROOT}/native/gauntlet` (on Windows
in PowerShell: `& "${CLAUDE_PLUGIN_ROOT}/native/gauntlet.exe"`).

1. Run `"${CLAUDE_PLUGIN_ROOT}/native/gauntlet" customise list` to see every
   setting and its allowed values. Use only those; never invent a setting.
2. Map what the user asked for onto those settings, for example:
   - "darker", "dimmer", "less bright" wallpaper -> `wallpaper.brightness dim`
   - "brighter" -> `wallpaper.brightness bright`
   - "calmer", "less movement", "save battery" -> `wallpaper.motion calm`
   - "more alive", "more animation" -> `wallpaper.motion lively`
   - "see-through", "transparent" widget -> `widget.background transparent`
3. Run one command per setting, exactly:
   `"${CLAUDE_PLUGIN_ROOT}/native/gauntlet" customise <setting> <value>`
   Never put the user's own words into the command; only a listed setting
   and one of its listed values.
4. Watch face colours and layout are changed on the watch itself: long-press
   the Clawd face, tap Customize, and pick a colour. Say so when the user
   asks about the watch face.
5. If nothing matches, show the user the list and ask which they want.

Reply in one or two sentences: what changed, and that the phone shows it at
once (the widget on its next refresh).

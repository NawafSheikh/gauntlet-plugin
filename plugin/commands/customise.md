---
description: Design your own phone wallpaper with live session controls, or tweak the look, by describing it
argument-hint: "what you want, for example a rainy neon city with my sessions as glowing signs"
allowed-tools: Bash(*native/gauntlet*), Read, Write
---

The user wants to change how Gauntlet looks. They said: `$ARGUMENTS`

The agent's launcher is `${CLAUDE_PLUGIN_ROOT}/native/gauntlet` (on Windows
in PowerShell: `& "${CLAUDE_PLUGIN_ROOT}/native/gauntlet.exe"`).

## Designing the wallpaper (most requests)

The phone's live wallpaper can be anything the user describes: a **skin**,
one JSON file of layers (shapes, gradients, text, pictures, the Clawd and
Codex characters, rain, snow, stars) bound to live session data, with
controls the user can tap (next session, talk, OK, open).

1. Read the format first: `${CLAUDE_PLUGIN_ROOT}/skills/gauntlet/skins.md`.
   Use only the fields, words and data keys it lists.
2. Design for the user's request. Make it beautiful: a clear focal point,
   a restrained palette, generous space, text that stays readable over the
   background, and at least one live control (the session name with
   `"tap": "next"`, and a talk button) unless they ask for none.
3. Write it to a file in the current folder, for example `gauntlet-skin.json`.
4. Apply it: `"${CLAUDE_PLUGIN_ROOT}/native/gauntlet" skin apply gauntlet-skin.json`.
   If it is refused, the message says what to fix; fix it and apply again.
5. It prints the path of the picture the phone drew. **Read that picture**,
   compare it with what the user asked for, and refine (spacing, contrast,
   sizes, colours) until it looks right; two or three rounds is normal.
6. Pictures: if the user gives an image (or you make one, as a PNG or
   JPEG of at most 160 KB), send it with
   `"${CLAUDE_PLUGIN_ROOT}/native/gauntlet" skin asset <name> <file>` and
   use it as an `image` layer or the background.
7. Tell the user it is on their phone, and that `skin off` brings back the
   built-in wallpaper.

## Small tweaks

For "dimmer", "calmer" or "transparent widget", the older settings still
work: run `"${CLAUDE_PLUGIN_ROOT}/native/gauntlet" customise list`, then
`customise <setting> <value>` with only a listed setting and value. Never
put the user's own words into a command.

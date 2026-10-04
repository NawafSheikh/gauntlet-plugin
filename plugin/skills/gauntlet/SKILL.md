---
name: gauntlet
description: Use when the user mentions their Gauntlet watch, wrist gestures, watch haptics or buzzing, or asks how to control Claude Code hands-free from a Wear OS watch. Covers the gesture map, setup, and troubleshooting.
---

# Gauntlet watch control

The user may be driving this session from a Wear OS watch running Gauntlet.
The watch is a Bluetooth keyboard and mouse. Every gesture arrives as an
ordinary keystroke, so nothing here needs a tool call to work.

## Gesture map (CLAUDE scene on the watch)

| Gesture | Keystroke | Effect in Claude Code |
| --- | --- | --- |
| Swipe left or right | Ctrl+Shift+Tab, Ctrl+Tab | Previous or next Windows Terminal tab |
| Swipe up or down | Up, Down | History, or move through a picker or permission prompt |
| Double pinch | Enter | Submit, or confirm the highlighted option |
| Fist | Esc | Cancel input, interrupt, or decline |
| Pinch | Left click | Click where the watch points |
| Draw an O | Ctrl+Shift+T, then types `claude` and Enter | New terminal tab running a fresh Claude session |
| Raise the watch to the mouth | Speech typed as text | Dictate a prompt |

The watch buzzes once when a turn ends and three times when Claude is waiting
on a permission prompt or a question. That comes from this plugin's hooks,
which pulse the Scroll Lock LED; the watch reads the LED over its Bluetooth
keyboard link.

## Prompts spoken while pointing

The user can aim the watch at the screen, hold the side button, and talk:
"look at this [1], and that [2], I don't like it". Each [n] marks where the
mouse pointer rested when they said the word before it. This plugin's prompt
hook adds, next to such a prompt, what each mark points at (the element and
window under it, and screen coordinates) and the path of a screenshot with a
numbered ring at each mark.

- Treat [n] as a precise reference to that spot, not as literal text.
- Read the screenshot when the element name alone does not settle what they
  mean (canvas apps, images, terminals, anything without accessible names).
- A mark noted as estimated means the pointer was moving; say so if the
  target is ambiguous instead of guessing.

## How to behave when the user is on the watch

- Keep answers short and put the question or decision last, so it is on
  screen when the buzz brings them back.
- When you need a yes or no, prefer a permission prompt or a short numbered
  choice: the user can answer with swipes, a double pinch, or a fist.
- Do not ask the user to type long text; they may only have dictation.

## Todos from the phone or watch

The user can queue todos on the phone or watch, now or for a set time. A
todo arrives in a session as a prompt that starts "Gauntlet todo <id>".
Do the task, then mark it done so the phone and watch show it finished:
`gauntlet-agent todo done <id> "<one line on what you did>"` (the prompt
gives the full path to run). `gauntlet-agent todo list` shows them all.

## Setup

1. Open Gauntlet on the phone or watch on the same Wi-Fi. It finds this PC
   by itself, and the PC opens a pairing page in its browser: check the code
   matches and click Allow. Without a browser, approve with
   `/gauntlet:pair <code>`.
2. Check the agent with `"${CLAUDE_PLUGIN_ROOT}/native/gauntlet" status`
   (on Windows in PowerShell:
   `& "${CLAUDE_PLUGIN_ROOT}/native/gauntlet.exe" status`).
3. More PCs: in the phone app, Your PCs > Add another PC.
4. On macOS and Linux, buzzes, cards, watch approvals and replies, prompts
   and skills to idle sessions, and stops work everywhere. Keys (mode,
   model, OK/Enter, menus) reach sessions started as
   `gauntlet-agent run claude` or running in tmux. Focusing terminals and
   the session ring are Windows-only.

## Troubleshooting

- **No buzz:** the watch must be connected as a keyboard. If Gauntlet was
  paired before version 0.2, remove the device in Windows Bluetooth settings
  and pair again, because the keyboard gained an LED report.
- **Keystrokes go to the wrong window:** gestures type into whatever has
  focus; click the terminal first or point at it and pinch.
- **Scroll Lock shows on screen:** each pulse flips it and flips it back, so
  it always ends where it started.

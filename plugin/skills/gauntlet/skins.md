# Skins: wallpapers and widgets your agent designs

A skin is one JSON file that describes a live wallpaper (and later widgets
and the watch face) as layers. Claude writes it from what the user asks
for (`/customise make it a rainy neon street`), the agent checks it, and the
phone draws it. It is a description only: nothing in a skin ever runs as
code, so skins are safe to share.

Live data and controls are part of the format: any value can follow a
session, and any layer can be a control (next session, talk, OK).

## Shape

```json
{
  "version": 1,
  "name": "Rainy neon",
  "background": { "gradient": ["#0b1026", "#2a1b3d"] },
  "layers": [
    { "type": "particles", "kind": "rain", "density": 0.6, "color": "#7dd3fc55" },
    { "type": "text", "x": 0.5, "y": 0.18, "size": 0.09, "align": "center",
      "font": "pixel", "text": "{time.hhmm}", "color": "#ffffff" },
    { "type": "character", "who": "lead", "x": 0.5, "y": 0.55, "size": 0.35 },
    { "type": "text", "x": 0.5, "y": 0.72, "size": 0.04, "align": "center",
      "text": "{session.name}",
      "color": { "if": "session.working", "then": "#38bdf8", "else": "#94a3b8" },
      "tap": "next" },
    { "type": "arc", "x": 0.5, "y": 0.55, "r": 0.24, "width": 0.012,
      "value": "usage.fiveHour", "color": "#d77757", "track": "#ffffff22" },
    { "type": "rect", "x": 0.3, "y": 0.86, "w": 0.4, "h": 0.07, "radius": 0.035,
      "fill": "#ffffff18", "tap": "talk",
      "anim": { "prop": "opacity", "from": 0.6, "to": 1, "ms": 1600, "loop": "pingpong" } }
  ]
}
```

## Start from the Star Sea

`"background": { "scene": "starsea" }` keeps the built-in animated Star Sea
(sea, moon, lighthouse, Clawd and the Codex pod acting out your sessions)
and draws the skin's layers over it. This is the best start for most
requests: add a few light touches in the pixel font (`"font": "pixel"`)
rather than rebuilding the scene. `"pixel": true` draws the skin's own
layers at the scene's resolution so they match its pixel art (keep text in
pixel mode large: it is drawn about five times smaller).

## Positions

Positions and sizes are fractions of the screen, so one skin fits every
phone: `x` and `w` of its width, `y` and `h` of its height, and `r`,
`size`, `radius`, `width` and `strokeWidth` of its width. `rect`, `image`,
`bar` and `sessions` sit at their top-left corner (x, y); `circle`, `arc`
and `character` at their centre; `text` at its anchor (x by `align`, y its
middle). Colours are `#rrggbb` or `#rrggbbaa`.

## Layers

| type | fields |
|---|---|
| `rect` | x, y, w, h, radius, fill, stroke, strokeWidth |
| `circle` | x, y, r, fill, stroke, strokeWidth |
| `text` | x, y, size, text, color, align (`left`, `center`, `right`), font (`sans`, `mono`, `pixel`), weight (`normal`, `bold`), maxLines |
| `image` | x, y, w, h, asset, fit (`cover`, `contain`), radius, opacity |
| `character` | x, y, size, who (`clawd`, `codex`, `lead`): `lead` is whoever leads the session in focus; it acts out the session's mood |
| `particles` | kind (`rain`, `snow`, `stars`, `sparks`, `bubbles`), density (0 to 1), color |
| `arc` | x, y, r, width, value (a 0 to 1 data key), color, track |
| `bar` | x, y, w, h, value, color, track, radius |
| `sessions` | x, y, w, h, style (`pills`, `list`, `dots`), max (1 to 8): every session, tap one to switch to it |

Every layer may also have:

- `visible`: a condition (below); hidden when false.
- `opacity`: 0 to 1.
- `anim`: `{ "prop": "opacity|x|y|scale|rotate", "from", "to", "ms", "loop": "pingpong|repeat|once" }`.
- `tap`: `next`, `prev`, `talk`, `ok`, `open` (the app at that session), `pause`.

## Live data

Text may hold `{key}` placeholders. A colour, opacity or text may instead be
`{ "if": <condition>, "then": X, "else": Y }`.

| key | value |
|---|---|
| `time.hhmm`, `time.date`, `time.day` | text |
| `session.name`, `session.status`, `session.cli`, `session.project`, `session.lastLine` | the session in focus |
| `sessions.count`, `sessions.working` | numbers, as text |
| `usage.fiveHour`, `usage.sevenDay` | 0 to 1 (for arc and bar `value`) |
| `usage.fiveHourText`, `usage.sevenDayText` | `42%` |
| `pc.name` | text |

Conditions: `session.working`, `session.needsYou`, `session.idle`,
`session.codex`, `any.working`, `any.needsYou`, `linked`, `music.playing`,
`night` (local 19:00 to 06:00).

## Widget

A skin may also carry a home-screen widget: `"widget": { "background": ..., "layers": [...] }`,
the same layers with positions as fractions of the widget. A widget is still
(no `anim`, no `particles`: home screens redraw it rarely), has at most 24
layers, and at most 8 of them respond to taps. The user adds it once from
the home screen's widget list ("Gauntlet skin").

## Assets

`image` layers name an asset: a picture the user picked on the phone, or
one Claude made, sent with `gauntlet skin asset <name> <file.png|jpg>`
(PNG or JPEG, at most 160 KB each, 8 per skin). Assets live on the phone.

## Limits

At most 64 layers, text at most 200 characters each, the file at most
64 KB. The agent refuses anything else with a message saying what to fix.

## The loop

1. Claude writes `skin.json` and runs `gauntlet skin apply skin.json`.
2. The agent checks it and sends it to the phone, which draws it.
3. The phone sends back a picture of the result (a JPEG, 540 px wide);
   the agent saves it and prints its path. Claude looks at it and refines until the user likes it.

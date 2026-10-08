---
name: taste
description: Design judgment for Gauntlet skins. Load before designing or refining a phone live wallpaper, home-screen widget or watch skin (/customise, "make my widget", "new wallpaper", "it looks generic"). Reads the brief, sets three dials, picks a palette and type, avoids AI-looking defaults, and critiques the rendered picture before calling it done.
---

# Taste for skins

A skin is looked at hundreds of times a day, on a lock screen, between app
icons, on a wrist. It has to be calm, legible and specific to this user.
Most generated designs fail the same way: they reach for a default look
instead of reading the request. These rules correct that.

Adapted for Gauntlet skins from taste-skill by Leonxlnx
(https://github.com/Leonxlnx/taste-skill, MIT, see `LICENSE-taste-skill`).
The format itself is in `../gauntlet/skins.md`: use only what it lists.

## 1. Read the brief first

Before writing any JSON, say one line to the user:

> Reading this as: <surface: wallpaper / widget / watch> for <mood>, in a <visual family>, dials <V/M/D>.

Signals to read: the words they used ("calm", "cozy", "cyberpunk",
"minimal", "like my old Pebble"), a picture they gave, what they do
(their sessions, projects, the time they work), and the surface. If the
read could go two very different ways, ask **one** question
("closer to a quiet night sky or a busy neon street?"). Otherwise proceed.

## 2. Three dials

| Dial | 1 | 10 | Default |
|---|---|---|---|
| VARIANCE | strict symmetry | off-grid, asymmetric | 6 |
| MOTION | still | lots moving | 4 |
| DENSITY | one thing on a field | packed with data | 3 |

| Request sounds like | V | M | D |
|---|---|---|---|
| calm, minimal, clean, focus | 4 | 2 | 2 |
| cozy, warm, lo-fi, pixel | 5 | 4 | 3 |
| bold, playful, wild, party | 8 | 7 | 4 |
| dashboard, stats, "show me everything" | 3 | 2 | 7 |
| watch skin (always) | ≤5 | ≤3 | ≤3 |
| widget (always) | any | 0 (widgets are still) | any |

How the dials map to the format:
- **VARIANCE**: under 5, align to a centre or a shared left edge. 5 and up,
  put the focal point off-centre (x 0.3 or 0.7, y on a third) and leave a
  large empty area on the other side.
- **MOTION**: the number of `anim` and `particles` layers. 1-3: at most one
  slow thing (`ms` 2400 or more). 4-6: up to three, one particle layer at
  `density` 0.5 or less. 7+: up to five, still only one fast one.
- **DENSITY**: 1-3 shows two or three data keys; 7+ may use `sessions`,
  bars and arcs together, with `mono` for every number.

## 3. Colour

- One palette per skin: one background family, one neutral for text, **one
  accent**. The accent marks what is live (working, needs you); nothing else
  uses it.
- No pure `#000000` and no pure `#ffffff` fields: use an off-black
  (`#0b0d12`, `#111214`) or a tinted white (`#f1f5f9`).
- Text contrast at least 4.5:1 against what sits behind it. Over a photo or
  particles, put a soft `rect` behind the text (`#0000004d` style alpha) or
  move the text.
- Desaturate accents; keep saturation of large areas low.
- **Purple-to-blue gradient with neon glow is the AI default. Do not use it**
  unless the user asks for purple; if they do, commit to one violet with
  calm neutrals.
- Rotate palettes. Families to pick from (choose by mood, never the same one
  twice in a row for the same user):
  - Night sea: `#0b1220` `#13233a` text `#e2e8f0` accent `#5eead4`
  - Ember: `#120d0b` `#2a1712` text `#f5e9e2` accent `#f97352`
  - Forest: `#0d1410` `#1a2a20` text `#e7efe6` accent `#d9b44a`
  - Paper (light): `#eef0f2` `#dfe3e8` text `#1c2128` accent `#2f6fed`
  - Cobalt mono: `#0a0f1f` `#0f1a3a` text `#f1f5ff` accent `#ffffff`
  - Terracotta slate: `#1b1f24` `#2b3138` text `#eceff1` accent `#d9734e`
  - Rose dusk: `#160f14` `#2b1a24` text `#f6e9ef` accent `#f49ac1`

## 4. Type

- Three fonts exist: `sans`, `mono`, `pixel`. Use **at most two** in one skin.
  `pixel` belongs with the Star Sea or a pixel-art request; `mono` for numbers
  in dense designs.
- At most three sizes per surface. Hierarchy comes from size **and** colour
  (the secondary line in the text colour at 60-70% alpha), not size alone.
- Minimum `size`: 0.035 on the wallpaper, 0.06 on a widget, 0.07 on the watch.
  Pixel text is drawn about five times smaller in `"pixel": true` mode: go big.
- No giant clock that shouts. A clock is either the focal point (and then
  the only large thing) or a quiet line.
- Text is short. One idea per line, `maxLines` set, no filler words
  ("seamless", "elevate", "unleash"). Never use the em dash; use a colon or
  a new line. At most one `·` per line.

## 5. Composition by surface

**Wallpaper** (portrait, fractions of the width and height)
- The launcher draws the clock and widgets in the top third and app icons in
  the bottom quarter. The skin's focal point goes in the band y 0.35 to 0.75,
  or deliberately in a space the user said is empty.
- Margins: nothing important within 0.06 of an edge.
- One focal point (the character, a shape, a big number). Everything else is
  quieter: smaller, dimmer, or moving slower.
- At least one live control (`session.name` with `"tap": "next"`) unless the
  user asks for none.

**Widget** (fractions of the widget)
- Still: no `anim`, no `particles`. Design for the size it will get: a 2x1
  holds one line and one number; a 4x2 holds a focal value, two secondary
  values and up to three tap targets.
- Tap targets at least 0.18 of the widget's width and 0.25 of its height.
- A rounded `rect` background (`radius` about 0.08) unless the user asks for
  transparent; match the wallpaper's palette so the home screen reads as one.

**Watch** (round, centre 0.5, 0.5)
- The console's text sits in the middle: keep the area within 0.3 of the
  centre dark and empty. Decoration goes near the rim (radius 0.35 to 0.47).
- Calm: at most one slow animation, particles at `density` 0.3 or less.

## 6. AI tells: do not ship these

- Purple/blue gradient plus neon glow on everything.
- Everything centred in a vertical stack with equal gaps.
- Three equal boxes in a row.
- Glow circles behind every element.
- Thin "HUD" lines, crosshairs, corner brackets and fake coordinates as decoration.
- Fake version or status strings ("v2.0", "SYSTEM ONLINE", "NODE_01").
- Status dots in front of every line (a dot only when it means a real state).
- Rainbow of accents: more than one accent colour.
- Particles at full density with no reason, or two particle layers fighting.
- Text over a busy background with nothing behind it.
- Emoji as icons.

## 7. Critique the picture, then refine

After `skin apply`, read the phone and watch pictures it prints. Score each
from 1 to 5 and say the scores in one line:

1. **Focal point**: is the eye drawn to one thing first?
2. **Legibility**: can every word be read at arm's length? Contrast?
3. **Space**: margins even, nothing cramped, nothing awkwardly floating?
4. **Fit**: does it match what they asked for, and the dials?
5. **Restraint**: anything to remove? (There usually is.)

Fix the lowest score first, apply again, look again. Two or three rounds is
normal; stop when every score is 4 or more. Then tell the user what you
made in one or two sentences and how to tweak it.

## 8. Pre-flight

- [ ] One-line design read given.
- [ ] One accent; no `#000000`; text contrast checked.
- [ ] Two fonts at most, three sizes at most, sizes above the minimums.
- [ ] Motion matches the MOTION dial; widget has none.
- [ ] Wallpaper focal point clear of the launcher's clock and icons; watch
      middle kept dark.
- [ ] None of the AI tells.
- [ ] At least one live control.
- [ ] Rendered picture read and scored.

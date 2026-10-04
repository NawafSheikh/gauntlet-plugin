# Gauntlet

See, approve and talk to your AI coding agents from your phone and watch.
Works with Claude Code, Codex, OpenCode and Antigravity on Windows, macOS and Linux. No account,
no servers: your phone and watch talk only to your own computers.

## Install (one line)

Windows (PowerShell):

```powershell
irm https://raw.githubusercontent.com/NawafSheikh/gauntlet-plugin/main/install.ps1 | iex
```

macOS and Linux:

```sh
curl -fsSL https://raw.githubusercontent.com/NawafSheikh/gauntlet-plugin/main/install.sh | sh
```

Then open the Gauntlet app on your phone or watch on the same Wi-Fi. Your
computer opens a page in its browser: check the code matches and click
**Allow**. That's it.

## If your phone cannot find the computer

- Same Wi-Fi? Both must be on the same network (or your own Tailscale network).
- Windows on a network marked **Public** blocks incoming connections: set the
  network to **Private** (Settings > Network > Wi-Fi), or allow Gauntlet when
  Windows asks. Company-managed laptops may not allow either.
- New folder in Claude Code? Accept its "trust this folder" prompt first;
  Claude runs no plugin hooks before that.

## Or install by hand

Claude Code:

```text
/plugin marketplace add NawafSheikh/gauntlet-plugin
/plugin install gauntlet@gauntlet
```

Codex: `codex plugin marketplace add NawafSheikh/gauntlet-plugin`, then
`codex plugin add gauntlet@gauntlet`, then trust the hooks once with `/hooks`.

## Privacy

See [docs/privacy-policy.md](docs/privacy-policy.md). In short: nothing
leaves your own devices.

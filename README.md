# Gauntlet

See, approve and talk to your AI coding agents from your phone and watch.
Works with Claude Code and Codex on Windows, macOS and Linux. No account,
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

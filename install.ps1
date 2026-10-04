# Gauntlet one-line install for Windows:
#   irm https://raw.githubusercontent.com/NawafSheikh/gauntlet-plugin/main/install.ps1 | iex
#
# Adds the Gauntlet plugin to every AI coding agent found on this computer
# (Claude Code, Codex), starts the local Gauntlet agent, and tells you what
# to do on your phone or watch. Nothing is sent anywhere but GitHub (to fetch
# the plugin); Gauntlet has no servers.
$ErrorActionPreference = 'Stop'
$Repo = 'NawafSheikh/gauntlet-plugin'

function Say($text, $color = 'Gray') { Write-Host $text -ForegroundColor $color }

function Add-ToClaude {
    if (-not (Get-Command claude -ErrorAction SilentlyContinue)) { return $false }
    Say 'Claude Code found: adding the Gauntlet plugin...'
    claude plugin marketplace add $Repo | Out-Null
    claude plugin install gauntlet@gauntlet | Out-Null
    return $true
}

function Add-ToCodex {
    if (-not (Get-Command codex -ErrorAction SilentlyContinue)) { return $false }
    Say 'Codex found: adding the Gauntlet plugin...'
    codex plugin marketplace add $Repo | Out-Null
    codex plugin add gauntlet@gauntlet | Out-Null
    return $true
}

# The newest installed copy of the agent the plugin carries.
function Find-Agent {
    $roots = @("$env:USERPROFILE\.claude\plugins\cache\gauntlet\gauntlet", "$env:USERPROFILE\.codex\plugins")
    Get-ChildItem $roots -Recurse -Filter gauntlet.exe -ErrorAction SilentlyContinue |
        Where-Object { $_.DirectoryName -like '*native*' } |
        Sort-Object LastWriteTime -Descending | Select-Object -First 1 -ExpandProperty FullName
}

$added = @()
if (Add-ToClaude) { $added += 'Claude Code' }
if (Add-ToCodex) { $added += 'Codex' }
if (-not $added) {
    Say 'No supported AI agent found. Install Claude Code (https://claude.com/claude-code) or Codex first, then run this again.' Yellow
    exit 1
}
Say ("Added to: " + ($added -join ', ')) Green

$agent = Find-Agent
if ($agent) {
    # Start it now rather than at the next session, so the phone finds this PC right away.
    Start-Process -FilePath $agent -ArgumentList 'serve' -WindowStyle Hidden
    Say 'The Gauntlet agent is running.' Green
} else {
    Say 'The agent starts with your next Claude Code or Codex session.' Yellow
}
if ($added -contains 'Codex') { Say 'In Codex, run /hooks once and trust the Gauntlet hooks.' Yellow }
Say ''
Say 'Next: open Gauntlet on your phone or watch (same Wi-Fi).' White
Say 'This PC opens a page in your browser: check the code matches and click Allow.' White

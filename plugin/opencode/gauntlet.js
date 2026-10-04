// Gauntlet for OpenCode: tells the local Gauntlet agent about this
// session (started, working, finished, needs you, closed), so the phone and
// watch list it next to Claude Code and Codex sessions. Nothing leaves this
// computer: it talks only to the agent's loopback API, using the token the
// agent writes for programs on this machine.
//
// Install: copy to ~/.config/opencode/plugins/gauntlet.js (the Gauntlet
// installer does this when it finds OpenCode).
import { readFile } from "node:fs/promises"
import { homedir, platform } from "node:os"
import { join } from "node:path"

function agentDir() {
  if (process.env.GAUNTLET_DATA_DIR) return process.env.GAUNTLET_DATA_DIR
  const home = homedir()
  if (platform() === "win32") return join(process.env.APPDATA || join(home, "AppData", "Roaming"), "Gauntlet", "agent")
  if (platform() === "darwin") return join(home, "Library", "Application Support", "Gauntlet", "agent")
  return join(process.env.XDG_CONFIG_HOME || join(home, ".config"), "Gauntlet", "agent")
}

// The agent's address and token; re-read each time, since it changes when the agent restarts.
async function endpoint() {
  try {
    return JSON.parse(await readFile(join(agentDir(), "local.json"), "utf8"))
  } catch {
    return null // the agent is not running: nothing to tell
  }
}

async function tell(event, sessionId, cwd, extra = {}) {
  const ep = await endpoint()
  if (!ep || !sessionId) return
  try {
    await fetch(`http://${ep.addr}/hook`, {
      method: "POST",
      headers: { authorization: `Bearer ${ep.token}`, "content-type": "application/json" },
      body: JSON.stringify({ cli: "opencode", event, sessionId, cwd, pid: process.pid, at: Date.now(), ...extra }),
      signal: AbortSignal.timeout(3000),
    })
  } catch {
    // The agent may be restarting; the next event will reach it.
  }
}

function idOf(event) {
  const p = event.properties || {}
  return p.sessionID || p.sessionId || p.info?.id || p.id || ""
}

export const Gauntlet = async ({ directory }) => ({
  event: async ({ event }) => {
    const id = idOf(event)
    switch (event.type) {
      case "session.created":
        return tell("SessionStart", id, directory)
      case "session.status": {
        const status = event.properties?.status?.type || event.properties?.status
        if (status === "busy") return tell("UserPromptSubmit", id, directory)
        if (status === "idle") return tell("Stop", id, directory)
        return
      }
      case "session.idle":
        return tell("Stop", id, directory)
      case "permission.asked":
        return tell("Notification", id, directory, {
          notificationType: "permission_prompt",
          title: "OpenCode",
          message: String(event.properties?.title || event.properties?.type || "OpenCode needs your permission"),
        })
      case "session.deleted":
        return tell("SessionEnd", id, directory)
    }
  },
})

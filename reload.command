#!/bin/bash
# Reload the Agentify launchd service to pick up the new server.py + path.
# Usage: double-click this file in Finder, or run ./reload.command

set -e
LABEL="com.dobby.agentify"
PLIST="$HOME/Library/LaunchAgents/${LABEL}.plist"

echo "→ Unloading ${LABEL}…"
launchctl unload "${PLIST}" 2>/dev/null || true

sleep 1

echo "→ Loading ${LABEL}…"
launchctl load "${PLIST}"

sleep 2

echo "→ Checking status:"
launchctl list | grep "${LABEL}" || echo "(not found — check /tmp/agentify-error.log)"

echo ""
echo "→ Probing http://localhost:8810/healthz …"
curl -sS http://localhost:8810/healthz || echo "(no response — check /tmp/agentify-error.log)"

echo ""
echo "→ Probing https://useagentify.com/ …"
curl -sS -o /dev/null -w "HTTP %{http_code} · %{size_download} bytes · %{time_total}s\n" https://useagentify.com/

echo ""
echo "✓ Done. Tail logs with: tail -f /tmp/agentify.log"
read -n 1 -s -r -p "Press any key to close…"
echo

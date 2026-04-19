#!/bin/bash
# Push agentify to GitHub and notify Jonas/Finn via Finlynk relay
cd ~/Desktop/agentify

echo "=== Pushing to GitHub ==="
git push origin main 2>&1
echo ""

echo "=== Notifying Jonas/Finn about logo refresh ==="
curl -s -X POST "https://relay.finlynk.net/relay/send" \
  -H "X-API-Key: dobby-relay-key-2026" \
  -H "Content-Type: application/json" \
  -d '{"from":"dobby","to":"jonas","message":"Hey Jonas/Finn — just shipped a brand refresh for Agentify. New logo system with 3 directions: enclosed (dot in squircle), loop (infinity/orchestration mark), and bracket ({agent} between curves). All use a warm coral #c4644a accent on dark backgrounds. Updated the site at useagentify.com with the enclosed mark as the primary. Check it out and let us know what you think!"}'
echo ""

echo "=== Asking for logo feedback ==="
curl -s -X POST "https://relay.finlynk.net/relay/question" \
  -H "X-API-Key: dobby-relay-key-2026" \
  -H "Content-Type: application/json" \
  -d '{"from":"dobby","to":"jonas","question":"Which of the 3 logo directions do you and Finn prefer for Agentify — enclosed (dot in squircle), loop (infinity mark), or bracket ({agent} between curves)? Any tweaks you'\''d suggest to the chosen one?"}'
echo ""

echo "=== Done ==="
# Clean up this script
rm -f ~/Desktop/agentify/push-and-notify.command

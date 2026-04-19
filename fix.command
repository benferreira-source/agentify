#!/bin/bash
# fix.command — deeper diagnosis + hard-reload + fallback nohup spawn + gh auth attempt.

cd "$(dirname "$0")"

BOT="8376286915:AAEjHvw7qbmwQCN4tfPk3acUzADYfjv6-mk"
CHAT="-5133143507"
LABEL="com.dobby.agentify"
PLIST="$HOME/Library/LaunchAgents/${LABEL}.plist"
PORT=8810
UID_NUM=$(id -u)

tg() {
  curl -sS -o /dev/null "https://api.telegram.org/bot${BOT}/sendMessage" \
    --data-urlencode "chat_id=${CHAT}" \
    --data-urlencode "text=$1" 2>/dev/null || true
}
hr() { echo ""; echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"; }

hr; echo "A · System info"
sw_vers
/opt/homebrew/bin/python3 --version
which gh && gh --version | head -1

hr; echo "B · Port 8810 occupancy"
lsof -iTCP:${PORT} -sTCP:LISTEN -n -P || echo "(nothing listening — good)"

hr; echo "C · Run server.py directly in foreground for 3s to capture any exception"
# Kill any stuck launchd job first
launchctl bootout gui/${UID_NUM}/${LABEL} 2>/dev/null
launchctl unload "$PLIST" 2>/dev/null
sleep 1
lsof -ti :${PORT} 2>/dev/null | xargs -r kill -9

TMPLOG=$(mktemp)
/opt/homebrew/bin/python3 /Users/dobby/Desktop/agentify/server.py > "$TMPLOG" 2>&1 &
PYPID=$!
sleep 2
echo "  pid=${PYPID}"
if kill -0 ${PYPID} 2>/dev/null; then
  echo "  ✓ server running standalone"
  curl -sS -o /dev/null -w "  local /healthz → HTTP %{http_code}\n" http://localhost:${PORT}/healthz
  kill ${PYPID} 2>/dev/null
else
  echo "  ✗ server died. Output:"
  sed 's/^/    /' "$TMPLOG"
  tg "❌ server.py crashes when run directly: $(head -c 300 $TMPLOG | tr '\n' ' ')"
fi
wait ${PYPID} 2>/dev/null

hr; echo "D · Bootstrap via modern launchctl"
launchctl bootstrap gui/${UID_NUM} "$PLIST"
sleep 2
launchctl print gui/${UID_NUM}/${LABEL} 2>&1 | grep -E "(state|last exit code|pid|program)" | head -20

hr; echo "E · Healthcheck"
sleep 2
LOCAL=$(curl -sS -o /dev/null -w "%{http_code}" http://localhost:${PORT}/healthz --max-time 5)
PUBLIC=$(curl -sS -o /dev/null -w "%{http_code}" https://useagentify.com/ --max-time 10)
echo "  local  → HTTP ${LOCAL}"
echo "  public → HTTP ${PUBLIC}"

if [ "$LOCAL" != "200" ]; then
  echo ""
  echo "F · launchd still broken — falling back to direct nohup spawn"
  lsof -ti :${PORT} | xargs -r kill -9
  nohup /opt/homebrew/bin/python3 /Users/dobby/Desktop/agentify/server.py \
    > /tmp/agentify.log 2> /tmp/agentify-error.log &
  sleep 2
  LOCAL=$(curl -sS -o /dev/null -w "%{http_code}" http://localhost:${PORT}/healthz --max-time 5)
  PUBLIC=$(curl -sS -o /dev/null -w "%{http_code}" https://useagentify.com/ --max-time 10)
  echo "  after nohup: local=${LOCAL} public=${PUBLIC}"
fi

hr; echo "G · Error log tail"
echo "--- /tmp/agentify.log ---"
tail -30 /tmp/agentify.log 2>/dev/null || echo "(empty)"
echo "--- /tmp/agentify-error.log ---"
tail -30 /tmp/agentify-error.log 2>/dev/null || echo "(empty)"

hr; echo "H · gh auth status"
if gh auth status 2>&1 | tee /tmp/gh_auth_status.txt; then
  GH_USER=$(gh api user --jq .login 2>/dev/null)
  echo "  user: ${GH_USER}"
  echo ""
  echo "I · Create repo + push"
  cd /Users/dobby/Desktop/agentify
  [ -d .git ] && rm -rf .git
  git init -b main -q
  git config user.email "benferreira@icloud.com"
  git config user.name "Ben Ferreira"
  cat > .gitignore <<'EOF'
.DS_Store
__pycache__/
*.pyc
node_modules/
.env
EOF
  git add . && git commit -m "Initial commit — Agentify site + server + docs" -q
  if gh repo view "${GH_USER}/agentify" &>/dev/null; then
    git remote remove origin 2>/dev/null
    git remote add origin "https://github.com/${GH_USER}/agentify.git"
    git push -u origin main --force 2>&1 | tail -5
  else
    gh repo create agentify --public --source=. --remote=origin --push \
      --description "AI receptionist for service businesses — never miss another job."
  fi
  REPO="https://github.com/${GH_USER}/agentify"
else
  REPO="(gh not authed — run: gh auth login)"
fi

hr; echo "FINAL"
FINAL_LOCAL=$(curl -sS -o /dev/null -w "%{http_code}" http://localhost:${PORT}/healthz --max-time 5)
FINAL_PUB=$(curl -sS -o /dev/null -w "%{http_code}" https://useagentify.com/ --max-time 10)
echo "  site:   https://useagentify.com   HTTP ${FINAL_PUB}"
echo "  local:  http://localhost:${PORT}/       HTTP ${FINAL_LOCAL}"
echo "  repo:   ${REPO}"

MSG="Agentify deploy report:
site https://useagentify.com → HTTP ${FINAL_PUB}
local :${PORT} → HTTP ${FINAL_LOCAL}
repo: ${REPO}"
tg "$MSG"

echo ""
read -n 1 -s -r -p "Press any key to close…"
echo

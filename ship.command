#!/bin/bash
# ship.command — one-click: fix server, reload launchd, create GitHub repo, push, notify Ben.
# Double-click in Finder.

set +e  # keep going even if a step fails — we log each
cd "$(dirname "$0")"

BOT="8376286915:AAEjHvw7qbmwQCN4tfPk3acUzADYfjv6-mk"
CHAT="-5133143507"
LABEL="com.dobby.agentify"
PLIST="$HOME/Library/LaunchAgents/${LABEL}.plist"
PORT=8810
SITE_URL="https://useagentify.com"

tg() {
  local msg="$1"
  curl -sS -o /dev/null "https://api.telegram.org/bot${BOT}/sendMessage" \
    --data-urlencode "chat_id=${CHAT}" \
    --data-urlencode "text=${msg}" \
    --data-urlencode "parse_mode=Markdown" 2>/dev/null || true
}

hr() { echo "────────────────────────────────────────"; }

tg "🚀 *Agentify deploy starting* — fixing server.py + pushing to GitHub"

hr
echo "STEP 1 · Python version check"
/opt/homebrew/bin/python3 --version
/opt/homebrew/bin/python3 -c "import sys; print('sys.path ok:', sys.version_info)" || echo "python broken"

hr
echo "STEP 2 · Syntax check server.py"
/opt/homebrew/bin/python3 -c "import py_compile; py_compile.compile('server.py', doraise=True)" \
  && echo "✓ server.py compiles" \
  || { echo "✗ server.py has syntax errors"; tg "❌ server.py failed to compile"; }

hr
echo "STEP 3 · Kill anything on :${PORT} and reload launchd"
# Unload plist (ignore errors)
launchctl unload "$PLIST" 2>/dev/null
# Kill any lingering process bound to the port
lsof -ti :${PORT} | xargs -r kill -9 2>/dev/null
sleep 1
launchctl load "$PLIST"
sleep 3

echo "launchctl list:"
launchctl list | grep "${LABEL}" || echo "(not in list — check logs)"

hr
echo "STEP 4 · Healthcheck"
LOCAL=$(curl -sS -o /dev/null -w "%{http_code}" http://localhost:${PORT}/healthz --max-time 5)
PUBLIC=$(curl -sS -o /dev/null -w "%{http_code}" ${SITE_URL}/ --max-time 10)
echo "  local  http://localhost:${PORT}/healthz  → HTTP ${LOCAL}"
echo "  public ${SITE_URL}/                       → HTTP ${PUBLIC}"

if [ "$LOCAL" != "200" ]; then
  echo ""
  echo "⚠ Local server not responding. Last 50 lines of error log:"
  tail -50 /tmp/agentify-error.log 2>/dev/null || echo "(no error log)"
  echo ""
  echo "Last 50 lines of stdout log:"
  tail -50 /tmp/agentify.log 2>/dev/null || echo "(no log)"
  tg "⚠️ Local server not responding on :${PORT} — check /tmp/agentify-error.log"
fi

hr
echo "STEP 5 · GitHub repo"

# Ensure gh is installed
if ! command -v gh &>/dev/null; then
  echo "✗ GitHub CLI (gh) not installed. Install: brew install gh"
  tg "❌ gh CLI missing — run: brew install gh && gh auth login"
  REPO_URL=""
else
  # Ensure authed
  if ! gh auth status &>/dev/null; then
    echo "✗ gh not authenticated. Run in Terminal: gh auth login"
    tg "❌ gh not authenticated — run: gh auth login"
    REPO_URL=""
  else
    GH_USER=$(gh api user --jq .login)
    echo "  Authed as: ${GH_USER}"

    # Fresh git init (wipes any stale .git from sandbox)
    if [ -d .git ]; then
      rm -rf .git
    fi
    git init -b main
    git config user.email "benferreira@icloud.com"
    git config user.name "Ben Ferreira"

    # .gitignore just in case
    cat > .gitignore <<'EOF'
.DS_Store
__pycache__/
*.pyc
node_modules/
.env
.vercel
EOF

    git add .
    git commit -m "Initial commit — Agentify marketing site + server + docs" -q

    # Create repo if doesn't exist
    if gh repo view "${GH_USER}/agentify" &>/dev/null; then
      echo "  Repo ${GH_USER}/agentify already exists — adding remote and pushing"
      git remote remove origin 2>/dev/null
      git remote add origin "https://github.com/${GH_USER}/agentify.git"
      git push -u origin main --force
    else
      echo "  Creating repo ${GH_USER}/agentify (public)…"
      gh repo create agentify --public --source=. --remote=origin --push \
        --description "AI receptionist for service businesses — never miss another job."
    fi

    REPO_URL="https://github.com/${GH_USER}/agentify"
    echo "  ✓ Repo: ${REPO_URL}"
  fi
fi

hr
echo "STEP 6 · Final report"
echo "  Site:  ${SITE_URL}  (HTTP ${PUBLIC})"
echo "  Repo:  ${REPO_URL:-<not created>}"
echo "  Local: HTTP ${LOCAL}"

MSG="✅ *Agentify shipped*%0A%0A🌐 Site: ${SITE_URL} (HTTP ${PUBLIC})%0A📦 Repo: ${REPO_URL:-not created}%0A🔧 Local: HTTP ${LOCAL}"
curl -sS -o /dev/null "https://api.telegram.org/bot${BOT}/sendMessage" \
  --data-urlencode "chat_id=${CHAT}" \
  --data "text=${MSG}" \
  --data "parse_mode=Markdown" 2>/dev/null

echo ""
echo "✓ Done."
read -n 1 -s -r -p "Press any key to close…"
echo

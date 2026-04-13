#!/usr/bin/env bash
# Push this repo to GitHub. Run once: ./push.sh
set -e
cd "$(dirname "$0")"

if ! command -v gh >/dev/null 2>&1; then
  echo "Error: gh CLI not found. Install with: brew install gh"
  exit 1
fi

# The initial git init happened inside a sandbox and left stale lock files
# that can't be cleaned from there. Re-init cleanly from the user's shell.
if [ -d .git ]; then
  echo "→ Re-initializing .git (clearing sandbox lock files)…"
  rm -rf .git
fi

git init -b main
git config user.email "benferreira@icloud.com"
git config user.name "Ben Ferreira"
git add .
git commit -m "Initial commit — Agentify marketing site + GTM playbook

Apple.com-meets-Stripe dark aesthetic, single-file index.html.
Instrument Serif + DM Sans, #050505 canvas, animated phone mockup
with live call transcript, scroll-reveal sections.

- index.html (single-file site, embedded CSS/JS)
- docs/GTM-PLAYBOOK.md (outbound strategy, ICP, pricing, funnel)
- public/favicon.svg, og-image.png
- CNAME: agentify.benops.dev
- vercel.json, .gitignore, README.md, push.sh"

# Create the repo on GitHub, set as origin, push main.
gh repo create agentify --public --source=. --remote=origin --push \
  --description "Agentify — AI receptionist for independent businesses. Marketing site + GTM playbook."

echo ""
echo "✓ Pushed. Repo URL:"
gh repo view --json url --jq .url

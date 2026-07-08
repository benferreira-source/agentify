#!/usr/bin/env bash
# Push this repo to GitHub. Run once: ./push.sh
set -e
cd "$(dirname "$0")"

if ! command -v gh >/dev/null 2>&1; then
  echo "Error: gh CLI not found. Install with: brew install gh"
  exit 1
fi

# If origin remote exists, just add/commit/push. Otherwise, initialize fresh.
if git remote get-url origin &>/dev/null; then
  echo "→ Origin remote exists — committing and pushing…"
  git add .
  git commit -m "Update Agentify site" || echo "(nothing to commit)"
  git push origin main
else
  # No origin — might be a stale sandbox .git or first run.
  if [ -d .git ]; then
    echo "→ Stale .git with no origin — re-initializing…"
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
- CNAME: useagentify.com
- vercel.json, .gitignore, README.md, push.sh"

  # Create the repo on GitHub, set as origin, push main.
  gh repo create agentify --public --source=. --remote=origin --push \
    --description "Agentify — AI receptionist for independent businesses. Marketing site + GTM playbook."
fi

echo ""
echo "✓ Pushed. Repo URL:"
gh repo view --json url --jq .url

# Agentify handoff for Matt

Copy-paste this to send to Matt once the deploy completes.

---

**Subject: Agentify — site + repo are live**

Matt,

Quick rundown:

- **Live site:** https://useagentify.com
- **GitHub repo:** https://github.com/benferreira-source/agentify
- **GTM playbook:** https://github.com/benferreira-source/agentify/blob/main/docs/GTM-PLAYBOOK.md

Stack is one file of HTML (`index.html`) — no build step. Dark aesthetic, Instrument Serif + DM Sans, #0071e3 accent, live-call phone demo, pricing, FAQ, the whole thing.

**For edits:**
1. Clone the repo (`gh repo clone benferreira-source/agentify`)
2. Edit `index.html` directly
3. Open a PR against `main` — I'll review and merge

**For design direction:** aesthetic tokens are at the top of `index.html` CSS. Apple.com-meets-Stripe on dark canvas.

**For outbound strategy:** read `docs/GTM-PLAYBOOK.md` — ICP, channels, demo script, unit economics, 30/60/90 targets.

Site is hosted on my Mac mini behind Cloudflared, so any change you push that I pull to `/Users/dobby/Desktop/agentify/` is live immediately. If we want auto-deploy from GitHub, Vercel hookup is in `vercel.json` — ten minutes to wire up.

What's your first take? Want to split the outbound lists this week?

— Ben

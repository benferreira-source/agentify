# Agentify

Marketing site + GTM playbook for **Agentify** — an AI receptionist for independent businesses.

**Live site:** [useagentify.com](https://useagentify.com)

---

## Repo layout

```
agentify/
├── index.html              # Single-file marketing site (embedded CSS + JS)
├── docs/
│   └── GTM-PLAYBOOK.md     # Go-to-market playbook (internal)
├── public/
│   ├── favicon.svg
│   └── og-image.png        # social preview
├── CNAME                   # custom domain for GitHub Pages / Vercel
├── vercel.json             # Vercel deploy config
├── .gitignore
└── README.md
```

## Stack

- **Pure HTML / CSS / vanilla JS** — no build step, no framework
- **Fonts:** Instrument Serif (display) + DM Sans (body) via Google Fonts
- **Hosting:** Vercel (or GitHub Pages — both supported)

## Run locally

Any static server works. With Python:

```bash
cd agentify
python3 -m http.server 8000
# open http://localhost:8000
```

With Node:

```bash
npx serve .
```

## Deploy — Vercel (recommended)

```bash
# one-time: link the repo to Vercel
npx vercel link

# deploy a preview
npx vercel

# ship to production
npx vercel --prod
```

Vercel auto-redeploys on every push to `main`.

Point the custom domain `useagentify.com` to Vercel in:
**Project → Settings → Domains → Add `useagentify.com`**.

## Deploy — GitHub Pages (alternative)

1. Settings → Pages → Source: `main` branch, `/` root
2. Add a `CNAME` file with `useagentify.com` (already included)
3. Point DNS: `CNAME agentify → benops.github.io`

## Working on design with Matt

Matt — feel free to:
- Edit `index.html` directly and push to a feature branch
- Open PRs against `main` — Ben reviews
- Drop design screenshots or Figma exports in `docs/` if helpful

**Design source of truth:** the aesthetic is Apple.com-meets-Stripe on a dark canvas (see `index.html` top-of-file CSS tokens for the palette).

| Token | Value | Use |
| ----- | ----- | --- |
| `--bg` | `#050505` | page background |
| `--text` | `#fafafa` | primary text |
| `--accent` | `#0071e3` | CTAs, links, focus |
| `--green` | `#30d158` | live indicators, trust marks |
| `--text-muted` | `#86868b` | secondary copy |
| serif | Instrument Serif | display headlines |
| sans | DM Sans | body + UI |

## Copy changes

The site is one file. Find-and-replace the copy directly in `index.html`. Sections are clearly labeled with HTML comments (`<!-- ========== HERO ========== -->`).

## GTM playbook

See `docs/GTM-PLAYBOOK.md` for outbound strategy, ICP, pricing, and funnel math. Keep it updated — commit diffs with context in the message.

## License

Proprietary. All rights reserved © Agentify 2026.

# Agentify — Go-To-Market Playbook

**Version:** 1.0
**Last updated:** April 2026
**Owners:** Ben Ferreira, Matt

---

## 1. Positioning

**One-line pitch:** Agentify is an AI receptionist that answers every call, books every job, and follows up with leads — 24/7 — for independent businesses that can't afford a full-time front desk.

**Who we sell to:**
- Home services (HVAC, plumbing, electricians, cleaning, pest control)
- Personal services (salons, spas, barber shops, pet grooming)
- Professional services (dental, chiropractic, law, accounting)
- Specialty trades (auto detailing, mobile repair, landscaping)

**Geographic focus:** Minneapolis / Twin Cities metro first. We're local, we understand the market, and we can do in-person setups when it helps close.

**Who we don't sell to (yet):**
- Multi-location chains (long sales cycle, procurement friction)
- Enterprise (not the product)
- Solo creators with < $80k revenue (won't pay for it, won't get enough value)

---

## 2. The "missed call" demonstration

The core pitch is the problem itself: call a prospect's business. They don't pick up. Voicemail. That missed call *is* the pitch.

**The outbound call script:**

> "Hey, this is Ben with Agentify — I was actually just calling because I tried your business line a few minutes ago and got voicemail. That's exactly the problem we solve. We build AI receptionists for businesses like yours — always on, books appointments, follows up with leads. Got 30 seconds?"

If they laugh, you're in. If they're annoyed, acknowledge and move on — they're not the buyer.

---

## 3. Outbound channels

### 3.1 Cold email (primary — highest leverage)

**Volume target:** 200/day per founder = 400/day total.

**Domain setup:**
- Use secondary domains (e.g., `getagentify.com`, `agentify-ai.com`) to protect `agentify.benops.dev` deliverability
- 3 mailboxes per secondary domain, warmed for 3 weeks before sending
- SPF, DKIM, DMARC configured; MailerLite or Instantly for sending + warmup

**Subject lines that work:**
- `quick q about {{business_name}}`
- `missed call at {{business_name}}`
- `{{city}} — how you handle after-hours calls`

**Body template (short-form):**
```
Hey {{first_name}},

Called {{business_name}} a few minutes ago — went to voicemail.
Not a complaint, just what happens after hours at most small
businesses. That's the problem we solve.

We build AI receptionists that answer every call, book
appointments, and follow up with leads 24/7. Human in the loop,
no contracts, live in days.

Worth a 20-min look?

— Ben
```

**Follow-up cadence:** Day 3, Day 7, Day 14, Day 21. Stop after 4 touches.

### 3.2 AI cold calling

**Tool:** Bland.ai or Vapi for the outbound agent; our own call handling for live transfers.

**Volume target:** 500 dials/day. Expect ~4% pickup, ~15% of pickups agree to a demo. That's ~3 demos/day from cold calling alone.

**Script:** Short — the "I just called you and got voicemail" hook (§2). If interested, transfer to Ben or Matt for the actual book. Never let the AI close — the product has a human in the loop, so should the sale.

### 3.3 LinkedIn

**Personal profiles:** Ben and Matt both. Post 3×/week with Twin Cities–focused content:
- Before/after customer stories (anonymized if needed)
- "Why missed calls cost you $X,XXX a month" math posts
- Short video demos of the agent handling a real scenario

**Outbound DMs:** Only to decision-makers at Twin Cities SMBs. Start conversations, don't pitch. Ask what they're doing for after-hours coverage. Book demos from there.

**Target:** 20 qualified connections/day → 5–10 relevant conversations/day → 2 demos/week from LinkedIn.

### 3.4 SMS

**Only to leads who've opted in** (form fills, previous callers, referrals). TCPA/10DLC compliant. We're not cold-SMSing businesses.

**Use cases:**
- Demo confirmations: "Confirmed for Thu 2pm. I'll call you."
- No-show recovery: "Sorry we missed each other — grab any 15-min slot: {link}"
- Post-demo nudge: "Hey, any questions? Happy to jump on a quick call if helpful."

### 3.5 Local networking (high-close, low-volume)

- Chamber of Commerce events (Minneapolis, St. Paul, Edina)
- Trade association meetings (local HVAC, plumbing associations)
- BNI chapters
- 1–2 events/week, Ben and Matt split them

Target: 2 demos/week from networking. Close rate is ~3× higher than cold outbound.

---

## 4. Sales funnel

```
Outbound (email + cold call + LinkedIn) → Demo booked → 30-min demo call → Signed → Build (3–5 days) → Go live
```

### 4.1 The demo call (30 min, Zoom)

**Opening (5 min):**
- Intro, rapport, understand their business
- Ask: "Walk me through a typical day — what eats your time?"
- Ask: "How many calls a week go to voicemail? How many leads do you think you're losing?"

**Show (15 min):**
- Live demo of a similar business's agent (we have 3 canned ones: HVAC, salon, dental)
- Call the demo number, show the transcript populating in real time
- Show the owner dashboard: every conversation, override button, tuning controls

**Close (10 min):**
- Proposal: $599 Cloud or $999 Local — which fits?
- Timeline: 3–5 days from signed to live
- Payment: Stripe link sent on the call, or "want me to build the proposal first?"

**If they say "let me think about it":** Send a recap email same day. Follow up in 72 hours. After that, it's a no.

### 4.2 What closes

Top reasons people say yes:
1. **The demo is real.** They heard the agent handle a call. It wasn't hypothetical.
2. **No contract.** Month-to-month is a huge lower-risk signal for SMBs burned by 36-month lock-ins.
3. **Live in days, not months.** "When can I have this?" "Next week." That's unusual.
4. **Human in the loop.** They're not being replaced — they're being given a tool.

### 4.3 What kills deals

- **Complexity.** If the demo takes more than 2 clicks to show value, they drop.
- **"We already have someone."** Reframe: the agent doesn't replace them, it handles overflow and after-hours.
- **Price anchor.** If they've been quoted $99/month answering services, $599 setup feels high. Emphasize *one-time*, not monthly.

---

## 5. Onboarding / delivery (3–5 days)

| Day | Owner | Work |
| --- | --- | --- |
| 0 | Ben/Matt | Close call; collect intake form (hours, services, pricing, FAQs, calendar) |
| 1 | Eng | Build agent, configure calendar integration, set up phone number |
| 2 | Eng | Internal QA: 20 test calls covering happy path + edge cases |
| 3 | Ben/Matt | Screen-share walkthrough with client; client approval |
| 4 | Eng | Go live; forward client's existing line to Agentify number |
| 5+ | Ben/Matt | Daily check-in for week 1; weekly for month 1 |

**No client sees the agent touch their real customers before they've approved it.** Non-negotiable.

---

## 6. Pricing & unit economics

**Setup fee (one-time):**
- $599 — Cloud (no hardware)
- $999 — Local hardware (dedicated on-prem device)

**Monthly (after setup):**
- Discussed on the call — starts at $149/mo, scales with call volume

**Unit targets:**
- Goal: 50 paying clients by end of Q3 2026
- Average MRR per client: $200
- Target MRR at 50 clients: $10k/mo + $30k+ in one-time setup revenue through the quarter
- CAC target: < $400 blended (currently ~$280 from cold email + $650 from cold calling)

---

## 7. Tracking & ops

**Metrics we watch weekly:**
- Outbound sent (email, calls, DMs)
- Demos booked
- Show rate
- Close rate
- Time-to-live (signed → first live call)
- Churn (monthly)

**Tools:**
- CRM: we'll start in a spreadsheet, move to HubSpot Free when >50 open opps
- Calendar: Cal.com for demo scheduling
- Call recording: Gong (when budget allows; Zoom cloud recording for now)
- Email sending: Instantly.ai
- Tracking: UTM'd links on every outbound message, GA4 on agentify.benops.dev

---

## 8. 30/60/90-day priorities

**Next 30 days:**
- Launch this site publicly
- 2 founders × 200 emails/day for 20 working days = 8,000 cold emails sent
- Target: 10 signed clients
- Refine ICP based on who closes fastest

**Next 60 days:**
- Add LinkedIn content cadence (3 posts/week each)
- Run first paid cold-calling campaign (~$2k budget test)
- Target: 25 signed clients cumulative
- Build 3 ICP-specific landing pages (HVAC, salons, dental)

**Next 90 days:**
- Launch referral program ($100 per referred client)
- Hire first contract BDR for cold calling
- Target: 50 signed clients cumulative
- First case study + testimonial video from a flagship client

---

## 9. Playbook changelog

| Date | Author | Change |
| ---- | ------ | ------ |
| 2026-04-13 | Ben | Initial version pushed to repo alongside site launch |

---

*Internal doc. Update freely — commit the diff.*

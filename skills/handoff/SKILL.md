---
name: handoff
category: Workflow
tags: ["handoff", "client", "documentation", "deployment", "runbook", "maintenance", "Brick City Creative"]
description: >
  Structures project handoff to clients at the end of a Brick City Creative engagement.
  Use this skill when a project is wrapping up, when asked "what should I document before
  handing this off", when preparing a client for self-sufficiency, or when creating a
  maintenance guide. Trigger on phrases like "hand off", "handoff", "closing out", "client
  documentation", "maintenance guide", "deployment runbook", "things the client should know",
  or "wrapping up the project".
---

# Handoff Skill

You are preparing a complete project handoff for a Brick City Creative client. Your job is
to produce documentation that allows the client — or any future developer — to operate,
maintain, and evolve the project without calling Pete for every change.

## Role

Documentation lead and handoff coordinator. Be thorough about the things that break, honest
about limitations, and organized about credentials and processes.

## The Core Problem

Most handoff failures happen because:
1. Knowledge lives only in Pete's head
2. Credentials are scattered or missing
3. "Obvious" things are never written down
4. The client doesn't know what they don't know

This skill prevents all four.

---

## Handoff Checklist

### 1. Repository & Code

- [ ] README.md exists and covers: purpose, local setup, build commands, deploy commands
- [ ] All environment variables documented in `.env.example` (never actual values)
- [ ] Hardcoded dev URLs replaced with config
- [ ] Unused branches deleted, default branch is `main`
- [ ] All open issues triaged: closed, backlogged, or noted as known limitations
- [ ] Code comments removed for anything self-evident; complex logic explained

### 2. Credentials & Access

- [ ] Domain registrar login documented (or transferred to client)
- [ ] Hosting account login documented (or transferred)
- [ ] CMS admin accounts created for client with appropriate roles
- [ ] Analytics property access granted to client email
- [ ] Any API keys — are they in the client's account or Pete's?
- [ ] Email service, form service, payment processor — same question
- [ ] Password manager entry or credentials doc provided securely (never email plaintext)

### 3. Deployment Runbook

Document exactly how to deploy, step by step:

```markdown
## How to Deploy

1. {Step 1 — e.g., "Merge PR to main"}
2. {Step 2 — e.g., "CI/CD triggers automatically" or "Run: npm run build"}
3. {Step 3 — e.g., "Verify on staging at staging.example.com"}
4. {Step 4 — e.g., "Promote to production"}
5. {Step 5 — e.g., "Verify the homepage loads and contact form works"}

Rollback: {describe how to revert if something goes wrong}
```

### 4. Things That Will Break

This is the most important section. Be honest:

```markdown
## Known Fragile Points

- **{Dependency / integration / process}** — {what will go wrong, when, and what to do}
- **SSL certificate renewal** — renews automatically via {Let's Encrypt / host}, expires {date}
- **Third-party API** — {name} key expires {date} or rotates on {event}
- **Content types** — {what the CMS will and won't do gracefully}
```

Typical failure modes to check:
- API keys that expire
- SSL certificates
- CMS plugin/extension updates that break functionality
- Email deliverability (SPF/DKIM/DMARC)
- Form service limits
- Analytics tags that stop firing after a CMS update
- Image optimization that breaks on certain formats

### 5. Maintenance Guide

What the client needs to do regularly:

```markdown
## Routine Maintenance

| Task | Frequency | How |
|------|-----------|-----|
| Content updates | As needed | {CMS name}: {brief instructions} |
| Backups | Weekly | {Automatic via host / manual: instructions} |
| Plugin/theme updates | Monthly | {WP admin → Updates, or describe process} |
| Uptime monitoring | Ongoing | {Tool name and who gets alerts} |
| Analytics review | Monthly | {GA4 or tool, who has access} |
```

### 6. Training Notes

What the client needs to know to operate the site:

- How to log into the CMS
- How to add/edit content (page, post, product, etc.)
- How to handle form submissions
- What to do if the site goes down (contact host, check status page)
- What NOT to change without talking to a developer first

If a Loom video or screen recording was made, link it here.

### 7. Who to Call

```markdown
## Support Contacts

| Issue | Contact | Notes |
|-------|---------|-------|
| Hosting down | {Host name} support | {URL or phone} |
| Domain issue | {Registrar} support | {URL} |
| Email delivery | {Email provider} support | {URL} |
| Code changes | Pete Benoit — Brick City Creative | pete@brickcitycreative.com |
```

---

## Handoff Document Template

Produce a `HANDOFF.md` in the project root:

```markdown
# {Project Name} — Client Handoff

**Client:** {name}
**Handoff date:** {date}
**Built by:** Pete Benoit, Brick City Creative

---

## Access & Credentials

{Describe where to find credentials — do not include them here. Reference the password
manager entry or credentials doc.}

---

## How to Deploy

{Step-by-step deployment runbook}

---

## Routine Maintenance

{Maintenance table}

---

## Things That Will Break

{Fragile points list}

---

## Training Notes

{What the client needs to know to operate this}

---

## Support Contacts

{Support table}

---

## Notes for Future Developers

{Architecture decisions, non-obvious choices, things that look wrong but are intentional}
```

---

## Rules

- Never include actual credentials in any document that goes into version control.
- "Things That Will Break" is not optional. Every project has something fragile.
- If the client can't read the maintenance guide and act on it, it's too technical.
  Rewrite it until they can.
- Get written confirmation that the client received and reviewed the handoff. Keep a copy.
- If access transfer hasn't happened (domain, hosting), the handoff is not complete.

## Project Context

Check AGENTS.md or local context for:
- Client name and contact
- Specific platforms (host, CMS, registrar, analytics)
- Any non-standard workflows or approval chains
- Retainer terms that affect post-launch support responsibility

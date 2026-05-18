# context/

CONTEXT.md templates for domain modeling.

---

## What This Is

A `CONTEXT.md` is a shared vocabulary document that lives in a project repo and gives the agent
a map of the domain — what things are called, what they mean, and how they relate. It's the
difference between an agent that says "the lesson materialization cascade" and one that says
"when a lesson inside a section of a course is given a spot in the file system."

Without a CONTEXT.md, agents invent their own language as they go. They use 20 words where one
project-specific term would do, and they lose precision across sessions.

---

## What Goes in a CONTEXT.md

A CONTEXT.md covers three things:

**1. The domain glossary**
Terms that have specific meaning in this project that wouldn't be obvious to an outside reader.
Not general programming terms — those don't need definition. The project-specific ones do.

```markdown
## Glossary

**Bento card** — The base card component used on project and blog pages. Defined in `style.css`
as `.bento-card`. Never inline its styles; always use the class.

**Twitter ledger** — `public/twitter-ledger.json`. Controls which blog posts have been tweeted.
A post absent from this file will be auto-tweeted on the next script run.

**Slug** — The URL path segment for a page (e.g., `scroll-driven-animations`). Always lowercase,
hyphen-separated, descriptive enough to stand alone as a headline fragment.
```

**2. Key relationships and dependencies**
Which parts of the system talk to each other. Not a full architecture diagram — just the
non-obvious connections an agent would otherwise have to rediscover.

```markdown
## Key Relationships

- `vite.config.js` drives page registration, RSS generation, sitemap, and OG image triggers
- `siteheader.js` must load before `sitenav.js` on every page — order matters
- `projects.json` is the source of truth for the homepage projects grid — update it when
  adding or renaming a project page
```

**3. Active decisions and their rationale**
Choices that were made deliberately and shouldn't be undone without knowing why. This is the
part that prevents an agent from "helpfully" reverting a design decision because it looks like
an oversight.

```markdown
## Decisions

**No em-dashes anywhere.** Not in copy, titles, meta descriptions, or comments. Rewrite
sentences that need them. This is a voice rule, not a technical constraint.

**Mobile GPU rule.** `filter: blur(120px)` on orbs and `backdrop-filter` on cards are disabled
on mobile via a kill rule in `style.css`. Never add these without verifying the kill rule covers
them. This was a real performance regression that caused 10-15s load times on mobile Safari.
```

---

## Templates in This Folder

Each template here is a starter CONTEXT.md for a common project type. Copy the relevant one
into a project, fill in the specifics, and commit it to the project root.

| Template | For |
|----------|-----|
| `static-site.md` | Static HTML sites (Vite, Eleventy, plain HTML) |
| `js-library.md` | Open source JavaScript/TypeScript libraries |
| `web-app.md` | Single-page or server-rendered web applications |
| `bigcommerce.md` | BigCommerce stores with Stencil theme and API integrations |
| `federal-app.md` | Federal web projects (Section 508, USWDS, FedRAMP, ATO) |
| `drupal.md` | Drupal sites — hook system, config management, Twig theming |
| `va-gov.md` | VA.gov properties — VADS, 508, GTM/GA4, vets-website/content-build |
---

## Where CONTEXT.md Lives

In the project root, alongside `AGENTS.md`. Both files serve different purposes:

- `AGENTS.md` — instructions for the agent: what to do, what not to do, how to build
- `CONTEXT.md` — knowledge for the agent: what things are called, why decisions were made

An agent reads both. AGENTS.md drives behavior. CONTEXT.md informs language and prevents
decisions from being undone silently.

---

## When to Write One

A CONTEXT.md earns its existence when:
- You find yourself re-explaining the same term or relationship in multiple sessions
- An agent undoes a deliberate decision because it looks like an oversight
- The project has domain-specific language that isn't obvious from the code

A project doesn't need a CONTEXT.md on day one. Write it when the pain of not having one
becomes obvious.

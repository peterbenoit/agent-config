---
name: new-blog-post
description: >
  Use when creating a new blog post. Covers the writing quality bar, content requirements, head
  tags, JSON-LD schema, layout pattern, and publication checklist. Trigger on phrases like
  "new blog post", "write a post", "add a post", "publish a post", or any task involving
  creating a new blog post file.
---

# New Blog Post

> Check AGENTS.md for project-specific setup — build pipeline, registration requirements,
> analytics snippets, and post-publish scripts vary by project.

## Writing Quality Bar

A post must clear these before publishing. No exceptions.

**Content minimum:** Not a stub. Covers its topic with enough specifics (examples, code, dates,
names, version numbers) that a reader learns something concrete. Bullet-point outlines with thin
prose need more work.

**Voice:** Direct, opinionated, earned. Write as someone who has actually used or been burned by
the thing. Avoid hedging ("might be", "some would argue"). Take a position.

**Structure:**
- Open with a specific observation or moment that creates tension — not "In this post I'll discuss…"
- Each section answers "why does this matter now?" — historical context alone isn't enough
- Close by connecting pieces back to a single idea, not just trailing off

**Slug naming:** Descriptive noun phrase that could stand alone as a headline fragment.
- Good: `things-the-web-killed`, `scroll-driven-animations`, `css-starting-style`
- Avoid: `web-dead`, `stuff`, `tips`, anything that needs the title for context

**The "so what" test:** Re-read the conclusion. If someone could finish it and ask "okay, but so
what?" — the post needs a stronger payoff. Every post should leave one clear takeaway.

**Avoid:**
- Listicles with just a sentence per item — give interesting items real paragraphs
- Opening with a definition ("SOAP stands for…") — assume the reader knows, start with the story
- Section headings that are just noun labels ("Background", "Conclusion") — make them specific
- Hedged conclusions that summarize what you just said instead of landing somewhere new

---

## Technical Requirements

1. **Required `<head>` tags:**
   - `<title>` — 50–70 chars. Common pattern: `{Post Title} | {Site Name}`
   - `<meta property="og:title" content="...">`
   - `<meta name="description" content="...">`
   - `<meta property="article:published_time" content="YYYY-MM-DD">`
   - `<meta name="category" content="...">` (used for filtering, RSS, and auto-promotion)
   - Full Open Graph + Twitter card tags
   - `BlogPosting` JSON-LD schema — include `headline`, `datePublished`, `author`, `url`

2. **Analytics** — see AGENTS.md for project-specific analytics snippets before `</head>`.

3. **Blog post layout pattern:**
   - `<main id="main-content">` wraps article content. Breadcrumb nav stays outside `<main>`;
     footer stays outside `</main>`.
   - Blog post header and article should not reuse general page card styles — they have their own
     spacing and typography context. Check AGENTS.md or local overlay for project conventions.

4. **Post promotion / social publishing** — check AGENTS.md for any post-publish scripts,
   ledger files, or social automation tools this project uses.

5. **Required scripts** — check AGENTS.md for project-specific script tags required before `</body>`.

6. **Related content** (optional): If a related project exists, include a "What I've built with
   this" section inside `</article>`, not as a separate section after it.

---

## Project Context

Check AGENTS.md or local skill overlays for:
- File location conventions and naming requirements (slug format, directory structure)
- Build pipeline integration (what auto-generates on save/build vs. what requires manual steps)
- Analytics snippets and tracking IDs
- Social/promotion automation (tweet scripts, ledger files, scheduled publishing)
- Site-specific layout components and required script tags
- Content registration requirements (JSON feeds, sitemaps, post indexes)

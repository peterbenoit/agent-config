---
name: new-blog-post
description: >
  Use when creating a new blog post for peterbenoit.com. Covers writing quality bar, technical
  requirements, required head tags, JSON-LD schema, twitter ledger, layout pattern, and required
  scripts. Trigger on phrases like "new blog post", "write a post", "add a post", "publish a post",
  or any task involving creating /blog/<slug>/index.html.
---

# New Blog Post — peterbenoit.com

> **Zero manual registration needed.** `vite.config.js`, `sitemap.xml`, `feed.xml`,
> `blog-posts.json`, and OG images are all auto-generated — just create the file.

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

1. **Required `<head>` tags** (RSS plugin warns and skips the post if missing):
   - `<title>` — 50–70 chars. Pattern: `{Post Title} | Peter Benoit`
   - `<meta property="og:title" content="...">`
   - `<meta name="description" content="...">`
   - `<meta property="article:published_time" content="YYYY-MM-DD">`
   - `<meta name="category" content="CSS">` (or `Hiking`, `JavaScript`, etc.)
   - Open Graph + Twitter card tags (see project page skill for full list)
   - `BlogPosting` JSON-LD schema — include `headline`, `datePublished`, `author`, `url`

2. **Google Analytics + Vercel Analytics** — same snippets as project pages, before `</head>`.

3. **Blog post layout pattern:**
   - `<main id="main-content">` wraps article content inside the outer `<div class="relative z-10 ...">`. Breadcrumb `<nav>` stays outside `<main>`; footer stays outside `</main>`.
   - **Do NOT use `bento-card`** classes on header or article. Use:
     - `<header class="p-6 md:py-8 md:px-0 flex flex-col gap-4">`
     - `<article class="px-6 py-8 md:px-0 post-body">`
   - **Location metadata** (if post references a trail/place):
     ```html
     <span>·</span>
     <span class="text-slate-600"><a
         href="https://www.alltrails.com/trail/..."
         class="hover:text-{accent}-400 transition-colors inline-flex items-center gap-1"
         target="_blank" rel="noopener noreferrer">
       <svg class="w-3 h-3" aria-hidden="true"><use href="/icons.svg#icon-location-marker"/></svg>
       Trail Name · Location, ST
     </a></span>
     ```
   - **Footer:** Use full site footer component (see `marshall-swamp` or `silver-springs`). The simple two-link pattern is deprecated.

4. **Twitter ledger** — add an entry to `public/twitter-ledger.json` with `tweeted_at: null` at the top of the array. This holds the post from being auto-tweeted.
   - A post **absent from the ledger entirely** will be auto-tweeted on the next script run.
   - **To tweet when ready:** delete the entry, then run:
     ```sh
     node tools/tweet-new-posts.js
     ```
   - **Dry-run:** `DRY_RUN=1 node tools/tweet-new-posts.js`

5. **Required scripts before `</body>`** — in this exact order:
   ```html
   <script type="module" src="/src/siteheader.js"></script>
   <script type="module" src="/src/sitenav.js"></script>
   <script type="module" src="/src/theme-picker.js"></script>
   ```

6. **Related content** (optional): If a related project exists, include a "What I've built with
   this" section inside `</article>`, not as a separate section after it.

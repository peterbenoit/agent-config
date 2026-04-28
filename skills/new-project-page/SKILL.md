---
name: new-project-page
description: >
  Use when creating a new project page for peterbenoit.com. Covers the full checklist: file
  location, required head tags, OG metadata, JSON-LD schema, analytics snippets, page structure,
  accent color selection, Related section pattern, projects.json registration, and required scripts.
  Trigger on phrases like "new project page", "add a project", "create a page for", or any task
  that involves building a new /<slug>/index.html project page.
---

# New Project Page — peterbenoit.com

> **Zero manual registration needed.** `vite.config.js`, `sitemap.xml`, `feed.xml`, and OG images
> are all auto-generated — just create the file.

## Checklist

1. **Pick one accent color pair** from the table in AGENTS.md — use it consistently for orbs,
   badges, hover colors, icons, and CTAs throughout the page.

2. **Required `<head>` tags:**
   - `<title>` — 50–60 chars. Pattern: `{Product}: {Tagline} | Peter Benoit`
   - `<meta name="description" content="...">`
   - `<link rel="canonical" href="https://peterbenoit.com/{slug}/">`
   - Open Graph: `og:type`, `og:url`, `og:title`, `og:description`, `og:image`
   - Twitter: `twitter:card`, `twitter:url`, `twitter:title`, `twitter:description`,
     `twitter:image`, `twitter:creator`
   - `<link rel="alternate" type="application/rss+xml" title="Peter Benoit Blog" href="/feed.xml">`
   - `SoftwareSourceCode` JSON-LD schema block (see any existing project page for shape)

3. **Google Analytics + Vercel Analytics** — add before `</head>`:
   ```html
   <!-- Google Analytics -->
   <script async src="https://www.googletagmanager.com/gtag/js?id=G-GQEC09BG5Z"></script>
   <script defer src="/src/gtag-init.js"></script>
   <!-- Vercel Analytics -->
   <script>window.va = window.va || function () { (window.vaq = window.vaq || []).push(arguments); };</script>
   <script defer src="/_vercel/insights/script.js"></script>
   ```

4. **Standard page structure** (in order):
   breadcrumb nav → hero card → content sections → Related (if applicable) → footer

5. **`<main>` landmark required:**
   ```html
   <main id="main-content" class="relative z-10 w-full max-w-4xl mx-auto flex flex-col gap-6">
   ```
   Footer lives outside `</main>`.

6. **Add a Related section** (see pattern below) if related blog posts or other tools exist.

7. **Footer pattern:**
   ```html
   <a href="/">Peter Benoit</a> © 2026 &nbsp;·&nbsp; <a href="{project-url}">{product name}</a>
   ```

8. **Register in `public/projects.json`** — the homepage Projects grid renders from this file.
   Include: `name`, `url`, `desc`, `types[]`, `openSource: true/false`, `featured`.

9. **Required scripts before `</body>`** — in this exact order:
   ```html
   <script type="module" src="/src/siteheader.js"></script>
   <script type="module" src="/src/sitenav.js"></script>
   <script type="module" src="/src/theme-picker.js"></script>
   ```

## Related Section Pattern

Two categories (writing + tools):
```html
<section class="bento-card p-6 md:p-8 bg-slate-900/50 backdrop-blur-md border border-slate-800 rounded-3xl shadow-xl">
    <h2 class="font-outfit font-semibold text-xl text-white mb-5">Related</h2>
    <div class="divide-y divide-slate-800">
        <div class="pb-5">
            <p class="text-slate-500 text-xs uppercase tracking-wide font-medium mb-3">Writing</p>
            <ul class="space-y-2">
                <li><a href="/blog/<slug>/" class="text-slate-200 hover:text-{accent}-400 transition-colors text-sm">Post title. One-line description →</a></li>
            </ul>
        </div>
        <div class="pt-5">
            <p class="text-slate-500 text-xs uppercase tracking-wide font-medium mb-3">Tools</p>
            <ul class="space-y-2">
                <li><a href="/<slug>/" class="text-slate-200 hover:text-{accent}-400 transition-colors text-sm">Tool name. One-line description →</a></li>
            </ul>
        </div>
    </div>
</section>
```

One category only — omit `divide-y` wrapper, render the group directly.

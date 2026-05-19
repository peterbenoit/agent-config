---
name: new-project-page
category: Content
tags: [project-page, html, seo, og, json-ld, tailwind]
updated: 2026-05-18
triggers: ["add a project","create a page for"]
description: >
  Use when creating a new project page. Covers the full checklist: file location, required head
  tags, OG metadata, JSON-LD schema, analytics, page structure, accent color selection, Related
  section pattern, project registration, and required scripts. Trigger on phrases like "new project
  page", "add a project", "create a page for", or any task that involves building a new project
  landing page.
---

# New Project Page

> Check AGENTS.md for project-specific setup — file conventions, analytics snippets, registration
> requirements, and required scripts vary by project.

## Checklist

1. **Pick one accent color pair** from the project's design system — use it consistently for
   orbs, badges, hover colors, icons, and CTAs throughout the page.

2. **Required `<head>` tags:**
   - `<title>` — 50–60 chars. Common pattern: `{Product}: {Tagline} | {Site Name}`
   - `<meta name="description" content="...">`
   - `<link rel="canonical" href="{canonical-url}">`
   - Open Graph: `og:type`, `og:url`, `og:title`, `og:description`, `og:image`
   - Twitter: `twitter:card`, `twitter:url`, `twitter:title`, `twitter:description`,
     `twitter:image`, `twitter:creator`
   - RSS feed link (if the site has one)
   - `SoftwareSourceCode` JSON-LD schema block (see any existing project page for shape)

3. **Analytics** — see AGENTS.md for project-specific analytics snippets to add before `</head>`.

4. **Standard page structure** (in order):
   breadcrumb nav → hero card → content sections → Related (if applicable) → footer

5. **`<main>` landmark required:**
   ```html
   <main id="main-content">
   ```
   Footer lives outside `</main>`.

6. **Add a Related section** (see pattern below) if related blog posts or other tools exist.

7. **Footer pattern:** site credit + link to the project itself.

8. **Register the project** in whatever index or data file the site uses to render the projects
   list. Check AGENTS.md for the file location and required fields.

9. **Required scripts before `</body>`** — check AGENTS.md for the exact script tags this
   project uses.

## Related Section Pattern

Group links by category (writing, tools, etc.):

```html
<section aria-label="Related">
    <h2>Related</h2>
    <div>
        <div>
            <p>Writing</p>
            <ul>
                <li><a href="/blog/<slug>/">Post title. One-line description →</a></li>
            </ul>
        </div>
        <div>
            <p>Tools</p>
            <ul>
                <li><a href="/<slug>/">Tool name. One-line description →</a></li>
            </ul>
        </div>
    </div>
</section>
```

One category only — omit the grouping wrapper, render the list directly.

---

## Project Context

Check AGENTS.md or local skill overlays for:
- File location conventions and slug format
- Accent color assignments for this site's projects
- Analytics snippets and tracking IDs
- The project registry file and required fields
- Site-specific HTML component patterns (cards, layout wrappers, background decoration)
- Required script tags for the header, nav, and theme system

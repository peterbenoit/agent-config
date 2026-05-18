---
name: seo
category: Content
tags: [seo, meta, structured-data, canonical, indexing, search]
updated: 2026-05-18
description: >
  Act as the SEO advisor for any web project. Use when diagnosing indexing problems, writing
  titles and meta descriptions, reviewing structured data, checking canonical tags, or making
  decisions that affect how a site appears in search. Trigger on phrases like "will this rank",
  "meta description for", "why isn't this indexed", "structured data", "title tag", "canonical",
  "Search Console error", "indexing problem", or any question about search visibility.
---

# SEO

You are the SEO advisor. Your job is to make sure the right pages get found by the right people.
Fix what's broken before optimizing what's working.

---

## Title Tag Rules

- 50–60 chars for most pages; up to ~70 for blog posts when the headline needs full phrasing
- Lead with the most descriptive term — not the site name
- Pattern for product/tool pages: `{Product}: {Tagline} | {Site Name}`
- Pattern for content pages: `{Descriptive Topic} | {Site Name}`
- Never: `{Site Name} | {Page}` — wastes the most important characters
- Never: generic labels like `Blog | {Site}` or `Home | {Site}`

## Meta Description Rules

- 150–160 chars
- Specific and active — reads like a sentence from the page, not a pitch about it
- Answers: what will I find here, and why does it matter?
- Avoid: "Discover how to...", "In this post we explore...", "Learn about..."

---

## Indexing Diagnosis Workflow

When a page isn't getting indexed:

```
1. Is the page in the sitemap?
2. Does the page have a noindex meta tag or X-Robots-Tag?
3. Is the canonical tag correct and pointing to this URL (not elsewhere)?
4. Is the page linked from any other indexed page on the site?
5. Does the page have enough unique, substantial content to be worth indexing?
6. Is crawl budget a factor? (Too many thin pages hurt overall site indexing)
```

Common causes:
- Page exists but isn't linked from navigation or any other indexed page
- Canonical pointing to a redirect or wrong URL
- Redirect stub pages without noindex
- Thin content that Google doesn't consider worth indexing

---

## Structured Data Patterns

### SoftwareSourceCode
```json
{
  "@context": "https://schema.org",
  "@type": "SoftwareSourceCode",
  "name": "Project Name",
  "description": "...",
  "url": "https://example.com/slug/",
  "codeRepository": "https://github.com/user/repo",
  "programmingLanguage": "JavaScript",
  "author": { "@type": "Person", "name": "Author Name", "url": "https://example.com" }
}
```

### BlogPosting
```json
{
  "@context": "https://schema.org",
  "@type": "BlogPosting",
  "headline": "Post Title",
  "datePublished": "YYYY-MM-DD",
  "author": { "@type": "Person", "name": "Author Name", "url": "https://example.com" },
  "url": "https://example.com/blog/slug/"
}
```

### Article (explainers, long-form)
```json
{
  "@context": "https://schema.org",
  "@type": "Article",
  "headline": "Article Title",
  "datePublished": "YYYY-MM-DD",
  "author": { "@type": "Person", "name": "Author Name", "url": "https://example.com" },
  "url": "https://example.com/<section>/<slug>/"
}
```

### Person + ProfessionalService (portfolio homepage)
```json
{
  "@context": "https://schema.org",
  "@type": ["Person", "ProfessionalService"],
  "name": "Full Name",
  "url": "https://example.com",
  "description": "...",
  "sameAs": ["https://github.com/...", "https://linkedin.com/in/..."]
}
```

---

## Page-Level SEO Checklist

For every new page before publishing:
- [ ] Title is the right length and follows the naming pattern
- [ ] Meta description is 150–160 chars, specific, not generic
- [ ] Canonical tag points to the correct URL for this page
- [ ] Correct structured data type is present and valid
- [ ] Page is linked from at least one other indexed page
- [ ] Robots meta allows indexing (`index, follow`)
- [ ] OG + Twitter card tags are populated (social signals compound with search)
- [ ] Page has enough unique content to be worth indexing

---

## Content vs. SEO

SEO is not the reason to create content. Content serves the reader first. If a page exists purely
for search with nothing original to say, it will rank poorly and deserves to. The highest-leverage
SEO work on most sites is fixing technical problems, not manufacturing content.

---

## Project Context

Check AGENTS.md or local skill overlays for site-specific configuration: base URL, sitemap
generation method, known indexing issues, redirect patterns, and any site-specific structured
data requirements.
